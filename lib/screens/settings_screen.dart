import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/news_provider.dart';
import '../theme/terminal_theme.dart';
import 'api_key_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _changeKey(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('anthropic_api_key');
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ApiKeyScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _SectionHeader('REFRESH SETTINGS'),
        const SizedBox(height: 8),
        _SettingRow(
          label: 'AUTO-REFRESH INTERVAL',
          value: '${provider.refreshInterval} MIN',
          child: Slider(
            value: provider.refreshInterval.toDouble(),
            min: 1,
            max: 30,
            divisions: 29,
            activeColor: TerminalTheme.amber,
            inactiveColor: TerminalTheme.border,
            onChanged: (v) => provider.setRefreshInterval(v.round()),
          ),
        ),
        const SizedBox(height: 24),
        const _SectionHeader('DATA'),
        const SizedBox(height: 8),
        _InfoRow(label: 'TOTAL STORIES LOADED', value: '${provider.articles.length}'),
        _InfoRow(label: 'BREAKING STORIES', value: '${provider.breaking.length}'),
        _InfoRow(
          label: 'LAST UPDATE',
          value: provider.lastUpdated != null
              ? '${provider.lastUpdated!.hour.toString().padLeft(2, '0')}:${provider.lastUpdated!.minute.toString().padLeft(2, '0')}'
              : '--:--',
        ),
        const SizedBox(height: 24),
        const _SectionHeader('API KEY'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          color: TerminalTheme.bgCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Anthropic API key is stored securely on this device only.',
                style: TextStyle(
                  fontSize: 10,
                  color: TerminalTheme.textMuted,
                  fontFamily: 'monospace',
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _changeKey(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: TerminalTheme.amber),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'CHANGE API KEY',
                    style: TextStyle(
                      color: TerminalTheme.amber,
                      fontSize: 11,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _SectionHeader('ABOUT'),
        const SizedBox(height: 8),
        const _InfoRow(label: 'POWERED BY', value: 'CLAUDE AI'),
        const _InfoRow(label: 'MODEL', value: 'CLAUDE SONNET 4'),
        const _InfoRow(label: 'DATA SOURCE', value: 'LIVE WEB SEARCH'),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 9, color: TerminalTheme.amber, fontFamily: 'monospace',
      fontWeight: FontWeight.w700, letterSpacing: 1.2,
    ),
  );
}

class _SettingRow extends StatelessWidget {
  final String label, value;
  final Widget child;
  const _SettingRow({required this.label, required this.value, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: TerminalTheme.border)),
      color: TerminalTheme.bgCard,
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 10, color: TerminalTheme.textSecondary, fontFamily: 'monospace')),
        Text(value, style: const TextStyle(fontSize: 10, color: TerminalTheme.amber, fontFamily: 'monospace', fontWeight: FontWeight.w700)),
      ]),
      child,
    ]),
  );
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: TerminalTheme.border)),
      color: TerminalTheme.bgCard,
    ),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 10, color: TerminalTheme.textMuted, fontFamily: 'monospace')),
      Text(value, style: const TextStyle(fontSize: 10, color: TerminalTheme.textSecondary, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
    ]),
  );
}
