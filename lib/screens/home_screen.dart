import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/news_provider.dart';
import '../models/news_article.dart';
import '../theme/terminal_theme.dart';
import '../widgets/news_card.dart';
import '../widgets/ticker_tape.dart';
import 'detail_screen.dart';
import 'settings_screen.dart';

const _regions = ['ALL', 'EUROPE', 'ASIA', 'AMERICAS', 'MIDDLE EAST', 'AFRICA', 'WORLD'];
const _categories = ['ALL', 'POLITICS', 'CONFLICT', 'ECONOMY', 'CLIMATE', 'DIPLOMACY', 'TECH', 'HEALTH', 'SCIENCE'];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabCtrl;
  int _navIndex = 0;
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _regions.length, vsync: this);
    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) {
        context.read<NewsProvider>().setRegion(_regions[_tabCtrl.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(builder: (ctx, provider, _) {
      final tickerItems = provider.articles.take(8).map((a) =>
        '${a.category}  ${a.headline.substring(0, a.headline.length.clamp(0, 50))}…'
      ).toList();

      return Scaffold(
        backgroundColor: TerminalTheme.bg,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(provider),
              if (tickerItems.isNotEmpty)
                TickerTape(items: tickerItems),
              _buildTabBar(),
              _buildCategoryBar(provider),
              Expanded(
                child: _navIndex == 0
                    ? _buildFeed(provider)
                    : _navIndex == 1
                        ? _buildBreaking(provider)
                        : const SettingsScreen(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      );
    });
  }

  Widget _buildHeader(NewsProvider provider) {
    return Container(
      color: TerminalTheme.bgCard,
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 0),
      child: Row(
        children: [
          // Logo / Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'CLAUDE ',
                      style: TextStyle(
                        color: TerminalTheme.amber,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                        letterSpacing: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: 'TERMINAL',
                      style: TextStyle(
                        color: TerminalTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'monospace',
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                provider.lastUpdated != null
                    ? 'UPDATED ${DateFormat('HH:mm:ss').format(provider.lastUpdated!)}'
                    : 'INITIALIZING...',
                style: const TextStyle(
                  fontSize: 9,
                  color: TerminalTheme.textDim,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Live indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: TerminalTheme.urgentRed, width: 1),
            ),
            child: Row(
              children: [
                _PulseDot(),
                const SizedBox(width: 4),
                const Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 9,
                    color: TerminalTheme.urgentRed,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Refresh button
          IconButton(
            onPressed: provider.loading ? null : provider.fetchNews,
            icon: provider.loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: TerminalTheme.amber,
                    ),
                  )
                : const Icon(Icons.refresh, color: TerminalTheme.amber, size: 20),
            padding: EdgeInsets.zero,
          ),
          IconButton(
            onPressed: () => setState(() => _navIndex = 2),
            icon: const Icon(Icons.settings, color: TerminalTheme.textMuted, size: 18),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: TerminalTheme.bgCard,
      child: TabBar(
        controller: _tabCtrl,
        isScrollable: true,
        labelColor: TerminalTheme.amber,
        unselectedLabelColor: TerminalTheme.textDim,
        indicatorColor: TerminalTheme.amber,
        indicatorWeight: 2,
        labelStyle: const TextStyle(
          fontSize: 10,
          fontFamily: 'monospace',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
        tabs: _regions.map((r) => Tab(text: r, height: 36)).toList(),
      ),
    );
  }

  Widget _buildCategoryBar(NewsProvider provider) {
    return Container(
      height: 32,
      color: const Color(0xFF0D1117),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final active = provider.activeCategory == cat;
          return GestureDetector(
            onTap: () => provider.setCategory(cat),
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: active
                    ? (cat == 'ALL' ? TerminalTheme.amber : TerminalTheme.categoryColor(cat))
                    : TerminalTheme.border,
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 9,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : TerminalTheme.textDim,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeed(NewsProvider provider) {
    if (provider.loading && provider.articles.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: TerminalTheme.amber, strokeWidth: 1.5),
            SizedBox(height: 16),
            Text(
              'FETCHING LIVE NEWS...',
              style: TextStyle(
                color: TerminalTheme.textDim,
                fontSize: 11,
                letterSpacing: 1,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      );
    }

    if (provider.error != null && provider.articles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, color: TerminalTheme.textDim, size: 40),
              const SizedBox(height: 12),
              Text(
                provider.error!,
                style: const TextStyle(color: TerminalTheme.bearRed, fontSize: 11, fontFamily: 'monospace'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: provider.fetchNews,
                child: const Text('RETRY', style: TextStyle(color: TerminalTheme.amber, letterSpacing: 1)),
              ),
            ],
          ),
        ),
      );
    }

    final articles = provider.filtered;

    if (articles.isEmpty) {
      return const Center(
        child: Text(
          'NO STORIES FOR THIS FILTER',
          style: TextStyle(color: TerminalTheme.textDim, fontSize: 11, fontFamily: 'monospace'),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollCtrl,
      itemCount: articles.length + (provider.loading ? 1 : 0),
      itemBuilder: (_, i) {
        if (i == articles.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator(color: TerminalTheme.amber, strokeWidth: 1)),
          );
        }
        return NewsCard(
          article: articles[i],
          onTap: () => _openDetail(articles[i]),
        );
      },
    );
  }

  Widget _buildBreaking(NewsProvider provider) {
    final breaking = provider.breaking;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: TerminalTheme.border)),
          ),
          child: Row(
            children: [
              _PulseDot(),
              const SizedBox(width: 8),
              const Text(
                'BREAKING & HIGH URGENCY',
                style: TextStyle(
                  color: TerminalTheme.urgentRed,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  fontFamily: 'monospace',
                ),
              ),
              const Spacer(),
              Text(
                '${breaking.length} STORIES',
                style: const TextStyle(color: TerminalTheme.textDim, fontSize: 10, fontFamily: 'monospace'),
              ),
            ],
          ),
        ),
        Expanded(
          child: breaking.isEmpty
              ? const Center(
                  child: Text(
                    'NO BREAKING NEWS',
                    style: TextStyle(color: TerminalTheme.textDim, fontFamily: 'monospace'),
                  ),
                )
              : ListView.builder(
                  itemCount: breaking.length,
                  itemBuilder: (_, i) => NewsCard(
                    article: breaking[i],
                    onTap: () => _openDetail(breaking[i]),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: TerminalTheme.bgCard,
        border: Border(top: BorderSide(color: TerminalTheme.border)),
      ),
      child: BottomNavigationBar(
        currentIndex: _navIndex.clamp(0, 1),
        onTap: (i) => setState(() => _navIndex = i),
        backgroundColor: Colors.transparent,
        selectedItemColor: TerminalTheme.amber,
        unselectedItemColor: TerminalTheme.textDim,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontSize: 9, fontFamily: 'monospace', letterSpacing: 0.5),
        unselectedLabelStyle: const TextStyle(fontSize: 9, fontFamily: 'monospace', letterSpacing: 0.5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list, size: 20), label: 'FEED'),
          BottomNavigationBarItem(icon: Icon(Icons.flash_on, size: 20), label: 'BREAKING'),
        ],
      ),
    );
  }

  void _openDetail(NewsArticle article) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(article: article)),
    );
  }
}

class _PulseDot extends StatefulWidget {
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.4, end: 1.0).animate(_ctrl);
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
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: TerminalTheme.urgentRed.withOpacity(_anim.value),
        ),
      ),
    );
  }
}
