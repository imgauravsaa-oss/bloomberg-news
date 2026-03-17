import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_article.dart';

class NewsService {
  static const String _apiUrl = 'https://api.anthropic.com/v1/messages';

  static const String _systemPrompt = '''
You are a world news aggregator. When asked for news, respond ONLY with a JSON array of news items. No preamble, no markdown, no explanation — just raw JSON.

Each item must have:
- id: number (1, 2, 3...)
- time: string like "2h ago" or "35m ago"
- region: one of "EUROPE", "ASIA", "AMERICAS", "MIDDLE EAST", "AFRICA", "WORLD"
- category: one of "POLITICS", "CONFLICT", "ECONOMY", "CLIMATE", "SOCIETY", "DIPLOMACY", "SCIENCE", "TECH", "HEALTH"
- headline: string (compelling, factual, under 100 chars)
- summary: string (2-3 sentences of factual context)
- urgency: "high" | "med" | "low"

Return 15 diverse, real, current world news stories. Use your web search tool to find actual breaking news from today. Vary regions and categories.
''';

  Future<String?> _getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('anthropic_api_key');
  }

  Future<List<NewsArticle>> fetchLatestNews() async {
    final apiKey = await _getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('No API key set. Please add your key in Settings.');
    }

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
          'anthropic-beta': 'web-search-2025-03-05',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 4000,
          'system': _systemPrompt,
          'tools': [
            {'type': 'web_search_20250305', 'name': 'web_search'}
          ],
          'messages': [
            {
              'role': 'user',
              'content': 'Search for the latest breaking world news right now and return as JSON array.'
            }
          ],
        }),
      );

      if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please update it in Settings.');
      }
      if (response.statusCode != 200) {
        throw Exception('API error: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final contentList = data['content'] as List;

      String? rawJson;
      for (final block in contentList.reversed) {
        if (block['type'] == 'text') {
          rawJson = block['text'] as String;
          break;
        }
      }

      if (rawJson == null) throw Exception('No text response from API');

      rawJson = rawJson.trim();
      if (rawJson.startsWith('```')) {
        rawJson = rawJson
            .replaceFirst(RegExp(r'^```json?\s*', multiLine: true), '')
            .replaceFirst(RegExp(r'\s*```$', multiLine: true), '')
            .trim();
      }

      final List<dynamic> articles = jsonDecode(rawJson);
      return articles.map((a) => NewsArticle.fromJson(a)).toList();
    } catch (e) {
      if (e.toString().contains('API key') || e.toString().contains('Invalid')) rethrow;
      throw Exception('Failed to fetch news: $e');
    }
  }
}
