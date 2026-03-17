import 'package:flutter/material.dart';

class NewsItem {
  final int id;
  final String time;
  final String region;
  final String category;
  final String headline;
  final String summary;
  final String urgency;
  final DateTime fetchedAt;
  bool isRead;
  bool isBookmarked;

  NewsItem({
    required this.id,
    required this.time,
    required this.region,
    required this.category,
    required this.headline,
    required this.summary,
    required this.urgency,
    required this.fetchedAt,
    this.isRead = false,
    this.isBookmarked = false,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] ?? 0,
      time: json['time'] ?? '',
      region: json['region'] ?? 'WORLD',
      category: json['category'] ?? 'NEWS',
      headline: json['headline'] ?? '',
      summary: json['summary'] ?? '',
      urgency: json['urgency'] ?? 'low',
      fetchedAt: DateTime.now(),
    );
  }

  static Color categoryColor(String category) {
    switch (category.toUpperCase()) {
      case 'POLITICS':  return const Color(0xFFE63946);
      case 'CONFLICT':  return const Color(0xFFFF4500);
      case 'ECONOMY':   return const Color(0xFF2EC4B6);
      case 'CLIMATE':   return const Color(0xFF57CC99);
      case 'SOCIETY':   return const Color(0xFFA8DADC);
      case 'DIPLOMACY': return const Color(0xFFFFD166);
      case 'SCIENCE':   return const Color(0xFFC77DFF);
      case 'TECH':      return const Color(0xFF4CC9F0);
      default:          return const Color(0xFF888888);
    }
  }
}
