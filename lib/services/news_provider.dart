import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/news_article.dart';
import '../services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsService _service = NewsService();

  List<NewsArticle> _articles = [];
  bool _loading = false;
  String? _error;
  DateTime? _lastUpdated;
  String _activeRegion = 'ALL';
  String _activeCategory = 'ALL';
  Timer? _refreshTimer;
  int _refreshIntervalMinutes = 5;

  List<NewsArticle> get articles => _articles;
  bool get loading => _loading;
  String? get error => _error;
  DateTime? get lastUpdated => _lastUpdated;
  String get activeRegion => _activeRegion;
  String get activeCategory => _activeCategory;
  int get refreshInterval => _refreshIntervalMinutes;

  List<NewsArticle> get filtered {
    return _articles.where((a) {
      final regionMatch = _activeRegion == 'ALL' || a.region == _activeRegion;
      final catMatch = _activeCategory == 'ALL' || a.category == _activeCategory;
      return regionMatch && catMatch;
    }).toList();
  }

  List<NewsArticle> get breaking =>
      _articles.where((a) => a.urgency == 'high').toList();

  void setRegion(String region) {
    _activeRegion = region;
    notifyListeners();
  }

  void setCategory(String cat) {
    _activeCategory = cat;
    notifyListeners();
  }

  void setRefreshInterval(int minutes) {
    _refreshIntervalMinutes = minutes;
    _startAutoRefresh();
    notifyListeners();
  }

  Future<void> fetchNews() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final articles = await _service.fetchLatestNews();
      // Prepend new articles, dedup by headline
      final existing = {for (var a in _articles) a.headline: a};
      for (final a in articles) {
        existing[a.headline] = a;
      }
      _articles = existing.values.toList()
        ..sort((a, b) => b.fetchedAt.compareTo(a.fetchedAt));
      if (_articles.length > 50) _articles = _articles.take(50).toList();
      _lastUpdated = DateTime.now();
      _error = null;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    }

    _loading = false;
    notifyListeners();
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      Duration(minutes: _refreshIntervalMinutes),
      (_) => fetchNews(),
    );
  }

  void startAutoRefresh() {
    _startAutoRefresh();
    fetchNews();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
