import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TickerBar extends StatefulWidget {
  const TickerBar({super.key});

  @override
  State<TickerBar> createState() => _TickerBarState();
}

class _TickerBarState extends State<TickerBar> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  final List<Map<String, dynamic>> _tickers = [
    {'sym': 'SPX',     'val': '5,421',   'chg': '+1.4%',  'up': true},
    {'sym': 'NDX',     'val': '19,084',  'chg': '+1.9%',  'up': true},
    {'sym': 'BTC',     'val': '72,341',  'chg': '+3.9%',  'up': true},
    {'sym': 'GOLD',    'val': '2,387',   'chg': '+0.5%',  'up': true},
    {'sym': 'WTI',     'val': '84.72',   'chg': '+2.1%',  'up': true},
    {'sym': 'DXY',     'val': '103.44',  'chg': '-0.7%',  'up': false},
    {'sym': 'EUR/USD', 'val': '1.0821',  'chg': '+0.3%',  'up': true},
    {'sym': 'VIX',     'val': '13.82',   'chg': '-0.9%',  'up': false},
    {'sym': '10Y',     'val': '4.21%',   'chg': '-8bps',  'up': false},
    {'sym': 'ETH',     'val': '3,942',   'chg': '+2.0%',  'up': true},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startScrolling();
  }

  void _startScrolling() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    _scroll();
  }

  void _scroll() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted) break;
      if (_scrollController.hasClients) {
        final max = _scrollController.position.maxScrollExtent;
        final current = _scrollController.offset;
        if (current >= max) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(current + 1.5);
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      color: const Color(0xFF0D1117),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _tickers.length * 20,
        itemBuilder: (context, index) {
          final t = _tickers[index % _tickers.length];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t['sym'],
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 10,
                    color: const Color(0xFFFF8C00),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  t['val'],
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 10,
                    color: const Color(0xFFC8CDD6),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  t['chg'],
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 10,
                    color: t['up'] ? const Color(0xFF00D068) : const Color(0xFFFF3333),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text('◆', style: TextStyle(color: Colors.white.withOpacity(0.1), fontSize: 8)),
              ],
            ),
          );
        },
      ),
    );
  }
}
