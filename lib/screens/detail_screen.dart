import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../theme/terminal_theme.dart';

class DetailScreen extends StatelessWidget {
  final NewsArticle article;
  const DetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final catColor = TerminalTheme.categoryColor(article.category);
    final urgencyColor = article.urgency == 'high'
        ? TerminalTheme.urgentRed
        : article.urgency == 'med'
            ? TerminalTheme.amber
            : TerminalTheme.textMuted;

    return Scaffold(
      backgroundColor: TerminalTheme.bg,
      appBar: AppBar(
        backgroundColor: TerminalTheme.bgCard,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TerminalTheme.amber),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          article.category,
          style: TextStyle(
            color: catColor,
            fontSize: 12,
            fontFamily: 'monospace',
            letterSpacing: 1,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: urgencyColor, width: 1),
            ),
            child: Text(
              article.urgency.toUpperCase(),
              style: TextStyle(color: urgencyColor, fontSize: 9, letterSpacing: 1, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meta row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  color: catColor,
                  child: Text(
                    article.category,
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.8),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${article.region}  ·  ${article.time}',
                  style: const TextStyle(fontSize: 10, color: TerminalTheme.textMuted, fontFamily: 'monospace'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Headline
            Text(
              article.headline,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: TerminalTheme.textPrimary,
                height: 1.35,
                letterSpacing: 0.2,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 16),

            // Divider
            Container(height: 2, width: 40, color: TerminalTheme.amber),
            const SizedBox(height: 20),

            // Summary
            Text(
              article.summary,
              style: const TextStyle(
                fontSize: 15,
                color: TerminalTheme.textSecondary,
                height: 1.8,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 32),

            // Urgency meter
            _UrgencyMeter(urgency: article.urgency),
            const SizedBox(height: 24),

            // Footer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: TerminalTheme.border),
                color: TerminalTheme.bgCard,
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: TerminalTheme.textDim, size: 14),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'AI-generated summary via Claude web search. Not financial or legal advice.',
                      style: TextStyle(
                        fontSize: 10,
                        color: TerminalTheme.textDim,
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UrgencyMeter extends StatelessWidget {
  final String urgency;
  const _UrgencyMeter({required this.urgency});

  @override
  Widget build(BuildContext context) {
    final levels = ['LOW', 'MED', 'HIGH'];
    final idx = levels.indexOf(urgency.toUpperCase());
    final colors = [TerminalTheme.bullGreen, TerminalTheme.warnYellow, TerminalTheme.urgentRed];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'URGENCY LEVEL',
          style: TextStyle(fontSize: 9, color: TerminalTheme.textDim, letterSpacing: 1, fontFamily: 'monospace'),
        ),
        const SizedBox(height: 6),
        Row(
          children: List.generate(3, (i) => Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: i < 2 ? 3 : 0),
              color: i <= idx ? colors[idx] : TerminalTheme.border,
            ),
          )),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            urgency.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              color: idx >= 0 ? colors[idx] : TerminalTheme.textDim,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}
