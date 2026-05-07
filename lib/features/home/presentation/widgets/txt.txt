import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/models/memory.dart';

// ─── Dummy Models ────────────────────────────────────────────────

// ─── Dummy Data ──────────────────────────────────────────────────
final _dummyMemories = [
  Memory(
    id: '1',
    title: 'Morning walk in the park',
    content: 'The air was fresh and birds were singing...',
    date: DateTime(2025, 5, 7),
    emoji: '🌿',
    isFavorite: true,
  ),
  Memory(
    id: '2',
    title: 'Coffee with an old friend',
    content: 'We talked for hours about old times...',
    date: DateTime(2025, 5, 5),
    emoji: '☕',
  ),
  Memory(
    id: '3',
    title: 'Finished my book',
    content: 'What an ending! Totally unexpected twist...',
    date: DateTime(2025, 4, 28),
    emoji: '📚',
    isFavorite: true,
  ),
  Memory(
    id: '4',
    title: 'Rainy afternoon',
    content: 'Stayed home, watched movies all day long...',
    date: DateTime(2025, 4, 20),
    emoji: '🌧️',
  ),
];

final _onThisDayMemories = [_dummyMemories[0], _dummyMemories[2]];

// ─── App Colors ──────────────────────────────────────────────────
// ─── Home Screen ─────────────────────────────────────────────────
class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  bool _isDark = false;

  void _toggleTheme() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    final bg = _isDark ? AppColors.darkBg : AppColors.creamWhite;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _HomeAppBar(isDark: _isDark, onToggleTheme: _toggleTheme),
          _OnThisDayBanner(isDark: _isDark),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            sliver: _MemoriesList(isDark: _isDark),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }
}

// ─── App Bar ─────────────────────────────────────────────────────
class _HomeAppBar extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const _HomeAppBar({required this.isDark, required this.onToggleTheme});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning ☀️';
    if (hour < 17) return 'Good afternoon 🌤️';
    return 'Good evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final textColor = isDark ? AppColors.darkText : AppColors.ink;
    final bgColor = isDark ? AppColors.darkBg : AppColors.creamWhite;

    return SliverAppBar(
      expandedHeight: 148, // ← fixed height — enough room, no overflow
      floating: false,
      pinned: true,
      backgroundColor: bgColor,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // ← prevents overflow
              children: [
                // Greeting chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.amber.withOpacity(0.15)
                        : AppColors.amberGlow,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.amber.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getGreeting(),
                    style: TextStyle(
                      color: isDark ? AppColors.amber : AppColors.inkLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Title
                Text(
                  'Your Journal',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                // Date
                Text(
                  DateFormat('EEEE, MMMM d').format(now),
                  style: TextStyle(
                    color: isDark ? AppColors.darkMist : AppColors.mist,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        _AppBarAction(
          icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          isDark: isDark,
          onTap: onToggleTheme,
        ),
        _AppBarAction(icon: Icons.search_rounded, isDark: isDark, onTap: () {}),
        _AppBarAction(
          icon: Icons.favorite_border_rounded,
          isDark: isDark,
          onTap: () {},
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}

class _AppBarAction extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _AppBarAction({
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.only(right: 4, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDark ? AppColors.darkText : AppColors.ink,
        ),
      ),
    );
  }
}

// ─── On This Day Banner ──────────────────────────────────────────
class _OnThisDayBanner extends StatelessWidget {
  final bool isDark;
  const _OnThisDayBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final memories = _onThisDayMemories;
    if (memories.isEmpty) return const SliverToBoxAdapter(child: SizedBox());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 16),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.warmWhite,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark
                    ? AppColors.amber.withOpacity(0.25)
                    : AppColors.amber.withOpacity(0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.amber.withOpacity(isDark ? 0.08 : 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon with glow
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.amber.withOpacity(0.15)
                        : AppColors.amberLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('✨', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'On This Day',
                        style: TextStyle(
                          color: isDark ? AppColors.darkText : AppColors.ink,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${memories.length} memor${memories.length == 1 ? 'y' : 'ies'} from the past',
                        style: TextStyle(
                          color: isDark ? AppColors.darkMist : AppColors.mist,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : AppColors.fog.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: isDark ? AppColors.darkMist : AppColors.mist,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Memories List ───────────────────────────────────────────────
class _MemoriesList extends StatelessWidget {
  final bool isDark;
  const _MemoriesList({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final memories = _dummyMemories;

    if (memories.isEmpty) {
      return SliverToBoxAdapter(child: _EmptyState(onAction: () {}));
    }

    // Group by month
    final grouped = <String, List<Memory>>{};
    for (final m in memories) {
      final key = DateFormat('MMMM yyyy').format(m.date);
      grouped.putIfAbsent(key, () => []).add(m);
    }

    final entries = grouped.entries.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index >= entries.length) return null;
        final entry = entries[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MonthHeader(label: entry.key, isDark: isDark),
            ...entry.value.map((m) => _MemoryCard(memory: m, isDark: isDark)),
            const SizedBox(height: 8),
          ],
        );
      }, childCount: grouped.length),
    );
  }
}

// ─── Month Header ────────────────────────────────────────────────
class _MonthHeader extends StatelessWidget {
  final String label;
  final bool isDark;
  const _MonthHeader({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? AppColors.darkMist : AppColors.mist,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.06),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Memory Card ─────────────────────────────────────────────────
class _MemoryCard extends StatelessWidget {
  final Memory memory;
  final bool isDark;

  const _MemoryCard({required this.memory, required this.isDark});

  // Pick a soft accent per emoji category
  Color _accentColor() {
    switch (memory.emoji) {
      case '🌿':
      case '🌱':
        return AppColors.sage;
      case '☕':
      case '🍵':
        return AppColors.dustyRose;
      case '📚':
      case '📖':
        return AppColors.sky;
      case '🌧️':
        return AppColors.sky;
      default:
        return AppColors.fog;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor();
    final cardBg = isDark ? AppColors.darkCard : AppColors.warmWhite;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.black.withOpacity(0.05),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Emoji badge
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isDark
                        ? accent.withOpacity(0.18)
                        : accent.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Center(
                    child: Text(
                      memory.emoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              memory.title,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.ink,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                letterSpacing: -0.2,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (memory.isFavorite) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.favorite_rounded,
                              size: 14,
                              color: AppColors.amber,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        memory.content,
                        style: TextStyle(
                          color: isDark ? AppColors.darkMist : AppColors.mist,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      // Date pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.06)
                              : Colors.black.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          DateFormat('MMM d, yyyy').format(memory.date),
                          style: TextStyle(
                            color: isDark ? AppColors.darkMist : AppColors.mist,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Empty State ─────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final VoidCallback onAction;
  const _EmptyState({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📓', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 20),
          const Text(
            'Your journal awaits',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Start capturing your memories,\nthoughts, and moments.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.mist, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Add First Memory',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
