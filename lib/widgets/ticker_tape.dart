import 'package:flutter/material.dart';
import '../../theme/terminal_theme.dart';

class TickerTape extends StatefulWidget {
  final List<String> items;
  const TickerTape({super.key, required this.items});

  @override
  State<TickerTape> createState() => _TickerTapeState();
}

class _TickerTapeState extends State<TickerTape>
    with SingleTickerProviderStateMixin {
  late ScrollController _ctrl;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _ctrl = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _animate());
  }

  void _animate() async {
    if (!mounted) return;
    _running = true;
    while (_running && mounted) {
      if (_ctrl.hasClients) {
        final max = _ctrl.position.maxScrollExtent;
        if (max > 0) {
          await _ctrl.animateTo(
            max,
            duration: Duration(seconds: (max / 40).round()),
            curve: Curves.linear,
          );
          if (mounted) _ctrl.jumpTo(0);
        }
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  void dispose() {
    _running = false;
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      color: const Color(0xFF0D1117),
      child: SingleChildScrollView(
        controller: _ctrl,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: widget.items
              .expand((item) => [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          color: TerminalTheme.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Text(
                      ' ◆ ',
                      style: TextStyle(
                        color: TerminalTheme.amberDim,
                        fontSize: 10,
                      ),
                    ),
                  ])
              .toList(),
        ),
      ),
    );
  }
}
