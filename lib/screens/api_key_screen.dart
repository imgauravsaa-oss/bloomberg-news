import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/terminal_theme.dart';
import 'home_screen.dart';

class ApiKeyScreen extends StatefulWidget {
  const ApiKeyScreen({super.key});

  @override
  State<ApiKeyScreen> createState() => _ApiKeyScreenState();
}

class _ApiKeyScreenState extends State<ApiKeyScreen> {
  final _ctrl = TextEditingController();
  bool _obscure = true;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final key = _ctrl.text.trim();
    if (key.isEmpty) {
      setState(() => _error = 'ENTER YOUR API KEY');
      return;
    }
    if (!key.startsWith('sk-ant-')) {
      setState(() => _error = 'INVALID KEY FORMAT — SHOULD START WITH sk-ant-');
      return;
    }
    setState(() { _saving = true; _error = null; });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('anthropic_api_key', key);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TerminalTheme.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Logo
              RichText(
                text: const TextSpan(children: [
                  TextSpan(
                    text: 'CLAUDE ',
                    style: TextStyle(
                      color: TerminalTheme.amber,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                      letterSpacing: 2,
                    ),
                  ),
                  TextSpan(
                    text: 'TERMINAL',
                    style: TextStyle(
                      color: TerminalTheme.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'monospace',
                      letterSpacing: 2,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 8),
              const Text(
                'BLOOMBERG-STYLE LIVE NEWS',
                style: TextStyle(
                  color: TerminalTheme.textDim,
                  fontSize: 10,
                  fontFamily: 'monospace',
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 60),

              // Divider line
              Container(height: 1, color: TerminalTheme.border),
              const SizedBox(height: 32),

              const Text(
                'API KEY REQUIRED',
                style: TextStyle(
                  color: TerminalTheme.amber,
                  fontSize: 11,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your Anthropic API key to fetch live world news.\nYour key is stored only on this device.',
                style: TextStyle(
                  color: TerminalTheme.textMuted,
                  fontSize: 12,
                  height: 1.6,
                  fontFamily: 'monospace',
                ),
              ),

              const SizedBox(height: 28),

              // Input
              Container(
                decoration: BoxDecoration(
                  color: TerminalTheme.bgCard,
                  border: Border.all(
                    color: _error != null ? TerminalTheme.bearRed : TerminalTheme.border,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        obscureText: _obscure,
                        style: const TextStyle(
                          color: TerminalTheme.textPrimary,
                          fontFamily: 'monospace',
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'sk-ant-api03-...',
                          hintStyle: TextStyle(
                            color: TerminalTheme.textDim,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        onSubmitted: (_) => _save(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: TerminalTheme.textDim,
                        size: 18,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ],
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: TerminalTheme.bearRed,
                    fontSize: 10,
                    fontFamily: 'monospace',
                    letterSpacing: 0.5,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: _saving ? null : _save,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    color: TerminalTheme.amber,
                    alignment: Alignment.center,
                    child: _saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'CONNECT TO TERMINAL',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                              letterSpacing: 1.5,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // How to get key
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: TerminalTheme.border),
                  color: TerminalTheme.bgCard,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'HOW TO GET YOUR KEY',
                      style: TextStyle(
                        color: TerminalTheme.amber,
                        fontSize: 9,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...[
                      '1. Go to console.anthropic.com',
                      '2. Sign up or log in',
                      '3. Navigate to API Keys',
                      '4. Click "Create Key"',
                      '5. Copy and paste it here',
                    ].map((step) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        step,
                        style: const TextStyle(
                          color: TerminalTheme.textMuted,
                          fontSize: 11,
                          fontFamily: 'monospace',
                          height: 1.5,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
