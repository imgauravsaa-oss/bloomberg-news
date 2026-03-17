class NewsArticle {
  final int id;
  final String time;
  final String region;
  final String category;
  final String headline;
  final String summary;
  final String urgency;
  final DateTime fetchedAt;

  NewsArticle({
    required this.id,
    required this.time,
    required this.region,
    required this.category,
    required this.headline,
    required this.summary,
    required this.urgency,
    required this.fetchedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] ?? 0,
      time: json['time'] ?? '',
      region: json['region'] ?? 'WORLD',
      category: json['category'] ?? 'WORLD',
      headline: json['headline'] ?? '',
      summary: json['summary'] ?? '',
      urgency: json['urgency'] ?? 'low',
      fetchedAt: DateTime.now(),
    );
  }
}
