import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../theme/terminal_theme.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onTap;
  final bool isSelected;

  const NewsCard({
    super.key,
    required this.article,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = TerminalTheme.categoryColor(article.category);
    final urgencyColor = article.urgency == 'high'
        ? TerminalTheme.urgentRed
        : article.urgency == 'med'
            ? TerminalTheme.amber
            : TerminalTheme.border;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isSelected
              ? TerminalTheme.amber.withOpacity(0.08)
              : Colors.transparent,
          border: Border(
            left: BorderSide(color: urgencyColor, width: 3),
            bottom: const BorderSide(color: TerminalTheme.border, width: 0.5),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: catColor,
                  child: Text(
                    article.category,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  article.region,
                  style: const TextStyle(
                    fontSize: 9,
                    color: TerminalTheme.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                if (article.urgency == 'high') ...[
                  _UrgencyDot(),
                  const SizedBox(width: 6),
                ],
                Text(
                  article.time,
                  style: const TextStyle(
                    fontSize: 9,
                    color: TerminalTheme.textDim,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              article.headline,
              style: TextStyle(
                fontSize: 13,
                fontWeight: article.urgency == 'high' ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? TerminalTheme.textPrimary
                    : article.urgency == 'high'
                        ? TerminalTheme.textPrimary
                        : TerminalTheme.textSecondary,
                height: 1.35,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UrgencyDot extends StatefulWidget {
  @override
  State<_UrgencyDot> createState() => _UrgencyDotState();
}

class _UrgencyDotState extends State<_UrgencyDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: TerminalTheme.urgentRed.withOpacity(_anim.value),
          boxShadow: [
            BoxShadow(
              color: TerminalTheme.urgentRed.withOpacity(_anim.value * 0.6),
              blurRadius: 4,
            )
          ],
        ),
      ),
    );
  }
}
