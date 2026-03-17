import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_item.dart';

class ClaudeService {
  static const String _apiUrl = 'https://api.anthropic.com/v1/messages';
  // Replace with your Anthropic API key
  static const String _apiKey = 'YOUR_ANTHROPIC_API_KEY';

  static const String _systemPrompt = '''
You are a world news aggregator. When asked for news, respond ONLY with a JSON array of news items.
No preamble, no markdown fences, no explanation — just raw JSON array.

Each item must have:
- id: number (1..12)
- time: string like "2h ago" or "35m ago"
- region: one of "EUROPE","ASIA","AMERICAS","MIDDLE EAST","AFRICA","WORLD"
- category: one of "POLITICS","CONFLICT","ECONOMY","CLIMATE","SOCIETY","DIPLOMACY","SCIENCE","TECH"
- headline: string (compelling, factual, under 100 chars)
- summary: string (3-4 sentences of factual context)
- urgency: "high" | "med" | "low"

Return exactly 15 diverse, real, current world news stories from right now. Vary regions and categories.
High urgency = breaking/developing stories. Use web search for latest news.
''';

  static Future<List<NewsItem>> fetchLatestNews() async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
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

    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final content = data['content'] as List;

    // Find last text block
    String? rawText;
    for (final block in content.reversed) {
      if (block['type'] == 'text') {
        rawText = block['text'] as String;
        break;
      }
    }

    if (rawText == null) throw Exception('No text response from Claude');

    // Strip any accidental markdown
    rawText = rawText
        .replaceAll(RegExp(r'^```json\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^```\s*', multiLine: true), '')
        .replaceAll('```', '')
        .trim();

    final List<dynamic> parsed = jsonDecode(rawText);
    return parsed.map((j) => NewsItem.fromJson(j)).toList();
  }
}
