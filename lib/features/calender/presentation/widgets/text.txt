import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/models/memory.dart';

Map<DateTime, List<Memory>> _buildGrouped() {
  final allMemories = [
    Memory(
      id: '1',
      title: 'Morning walk in the park',
      content: 'The air was fresh and birds were singing beautifully...',
      date: DateTime(2025, 5, 7),
      emoji: '🌿',
      isFavorite: true,
    ),
    Memory(
      id: '2',
      title: 'Coffee with an old friend',
      content: 'We talked for hours about old times and laughed a lot...',
      date: DateTime(2025, 5, 5),
      emoji: '☕',
    ),
    Memory(
      id: '3',
      title: 'Sunset at the rooftop',
      content: 'Golden hour never looked so perfect from up there...',
      date: DateTime(2025, 5, 5),
      emoji: '🌅',
      isFavorite: true,
    ),
    Memory(
      id: '4',
      title: 'Finished my book',
      content: 'What an ending! Totally unexpected twist at the last page...',
      date: DateTime(2025, 5, 2),
      emoji: '📚',
      isFavorite: true,
    ),
    Memory(
      id: '5',
      title: 'Rainy afternoon',
      content: 'Stayed home, watched movies all day long with hot cocoa...',
      date: DateTime(2025, 4, 20),
      emoji: '🌧️',
    ),
    Memory(
      id: '6',
      title: 'Family dinner',
      content: 'Mom cooked her famous recipe. The whole family was there...',
      date: DateTime(2025, 4, 15),
      emoji: '🍽️',
    ),
  ];
  final map = <DateTime, List<Memory>>{};
  for (final m in allMemories) {
    final key = DateTime(m.date.year, m.date.month, m.date.day);
    map.putIfAbsent(key, () => []).add(m);
  }
  return map;
}

// ─── Main Widget ─────────────────────────────────────────────────
class CalenderViewBody extends StatefulWidget {
  const CalenderViewBody({super.key});

  @override
  State<CalenderViewBody> createState() => _CalenderViewBodyState();
}

class _CalenderViewBodyState extends State<CalenderViewBody> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isDark = false;
  late final Map<DateTime, List<Memory>> _grouped;

  @override
  void initState() {
    super.initState();
    _grouped = _buildGrouped();
  }

  List<Memory> _getMemoriesForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _grouped[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDark ? AppColors.darkBg : AppColors.creamWhite,
      appBar: _buildAppBar(),
      // ✅ Fix: CustomScrollView بدون IntrinsicHeight/ConstrainedBox
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // الكالندر
          SliverToBoxAdapter(
            child: _CalendarWidget(
              isDark: _isDark,
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              grouped: _grouped,
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
              },
              onPageChanged: (focused) {
                setState(() {
                  _focusedDay = focused;
                  _selectedDay = null;
                });
              },
            ),
          ),

          // المحتوى اللي تحت الكالندر
          if (_selectedDay != null)
            _SelectedDaySliver(
              selectedDay: _selectedDay!,
              memories: _getMemoriesForDay(_selectedDay!),
              isDark: _isDark,
            )
          else
            _MonthSummarySliver(
              grouped: _grouped,
              focusedDay: _focusedDay,
              isDark: _isDark,
            ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: _isDark ? AppColors.darkBg : AppColors.creamWhite,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 22,
      title: Text(
        'Calendar',
        style: TextStyle(
          color: _isDark ? AppColors.darkText : AppColors.ink,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => setState(() {
            _focusedDay = DateTime.now();
            _selectedDay = DateTime.now();
          }),
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: _isDark
                  ? AppColors.amber.withOpacity(0.15)
                  : AppColors.amberGlow,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.amber.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Today',
              style: TextStyle(
                color: _isDark ? AppColors.amber : AppColors.inkLight,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _isDark = !_isDark),
          child: Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 14, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: _isDark
                  ? Colors.white.withOpacity(0.07)
                  : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 17,
              color: _isDark ? AppColors.darkText : AppColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Calendar Widget ─────────────────────────────────────────────
class _CalendarWidget extends StatelessWidget {
  final bool isDark;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Map<DateTime, List<Memory>> grouped;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(DateTime) onPageChanged;

  const _CalendarWidget({
    required this.isDark,
    required this.focusedDay,
    required this.selectedDay,
    required this.grouped,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _hasMemories(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return grouped.containsKey(key) && grouped[key]!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);
    final daysInMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0).day;
    final startWeekday = firstOfMonth.weekday % 7;
    final today = DateTime.now();
    final cardBg = isDark ? AppColors.darkCard : AppColors.warmWhite;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('yyyy').format(focusedDay),
                      style: TextStyle(
                        color: isDark ? AppColors.darkMist : AppColors.mist,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      DateFormat('MMMM').format(focusedDay),
                      style: TextStyle(
                        color: isDark ? AppColors.darkText : AppColors.ink,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _NavButton(
                  icon: Icons.chevron_left_rounded,
                  isDark: isDark,
                  onTap: () {
                    onPageChanged(
                      DateTime(focusedDay.year, focusedDay.month - 1),
                    );
                  },
                ),
                const SizedBox(width: 6),
                _NavButton(
                  icon: Icons.chevron_right_rounded,
                  isDark: isDark,
                  onTap: () {
                    final next = DateTime(
                      focusedDay.year,
                      focusedDay.month + 1,
                    );
                    if (!next.isAfter(DateTime(today.year, today.month + 1))) {
                      onPageChanged(next);
                    }
                  },
                ),
              ],
            ),
          ),

          // ── Week Labels ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                  .asMap()
                  .entries
                  .map(
                    (e) => Expanded(
                      child: Center(
                        child: Text(
                          e.value,
                          style: TextStyle(
                            color: (e.key == 0 || e.key == 6)
                                ? AppColors.roseAccent.withOpacity(0.8)
                                : (isDark
                                      ? AppColors.darkMist
                                      : AppColors.mist),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 6),

          // ── Days Grid ──
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisExtent: 42,
              ),
              itemCount: startWeekday + daysInMonth,
              itemBuilder: (context, index) {
                if (index < startWeekday) return const SizedBox();
                final day = index - startWeekday + 1;
                final date = DateTime(focusedDay.year, focusedDay.month, day);
                final isToday = _isSameDay(date, today);
                final isSelected =
                    selectedDay != null && _isSameDay(date, selectedDay!);
                final hasData = _hasMemories(date);
                final isFuture = date.isAfter(today);
                final isWeekend =
                    date.weekday == DateTime.saturday ||
                    date.weekday == DateTime.sunday;

                return GestureDetector(
                  onTap: isFuture ? null : () => onDaySelected(date, date),
                  child: _DayCell(
                    day: day,
                    isToday: isToday,
                    isSelected: isSelected,
                    hasData: hasData,
                    isFuture: isFuture,
                    isWeekend: isWeekend,
                    isDark: isDark,
                  ),
                );
              },
            ),
          ),

          // ── Stats Strip ──
          Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.04)
                  : AppColors.softBeige.withOpacity(0.6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatChip(
                  label: 'This Month',
                  value:
                      '${grouped.entries.where((e) => e.key.year == focusedDay.year && e.key.month == focusedDay.month).fold(0, (s, e) => s + e.value.length)}',
                  emoji: '📝',
                  isDark: isDark,
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
                _StatChip(
                  label: 'Active Days',
                  value:
                      '${grouped.entries.where((e) => e.key.year == focusedDay.year && e.key.month == focusedDay.month).length}',
                  emoji: '📅',
                  isDark: isDark,
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
                _StatChip(
                  label: 'Favorites',
                  value:
                      '${grouped.entries.where((e) => e.key.year == focusedDay.year && e.key.month == focusedDay.month).expand((e) => e.value).where((m) => m.isFavorite).length}',
                  emoji: '⭐',
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stat Chip ───────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;
  final bool isDark;

  const _StatChip({
    required this.label,
    required this.value,
    required this.emoji,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: isDark ? AppColors.darkText : AppColors.ink,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.darkMist : AppColors.mist,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─── Nav Button ──────────────────────────────────────────────────
class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
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

// ─── Day Cell ────────────────────────────────────────────────────
class _DayCell extends StatelessWidget {
  final int day;
  final bool isToday, isSelected, hasData, isFuture, isWeekend, isDark;

  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.hasData,
    required this.isFuture,
    required this.isWeekend,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.transparent;
    Color textColor;
    FontWeight fontWeight = FontWeight.w500;

    if (isSelected) {
      bgColor = AppColors.ink;
      textColor = Colors.white;
      fontWeight = FontWeight.w800;
    } else if (isToday) {
      bgColor = isDark
          ? AppColors.amber.withOpacity(0.2)
          : AppColors.amberLight;
      textColor = AppColors.amber;
      fontWeight = FontWeight.w700;
    } else if (isFuture) {
      textColor = isDark ? AppColors.darkMist.withOpacity(0.35) : AppColors.fog;
    } else if (isWeekend) {
      textColor = AppColors.roseAccent;
    } else {
      textColor = isDark ? AppColors.darkText : AppColors.ink;
    }

    return Center(
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: fontWeight,
              ),
            ),
            if (hasData && !isSelected)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isToday
                        ? AppColors.amber
                        : AppColors.accentRose.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Selected Day Sliver ─────────────────────────────────────────
class _SelectedDaySliver extends StatelessWidget {
  final DateTime selectedDay;
  final List<Memory> memories;
  final bool isDark;

  const _SelectedDaySliver({
    required this.selectedDay,
    required this.memories,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('EEEE').format(selectedDay),
                      style: TextStyle(
                        color: isDark ? AppColors.darkMist : AppColors.mist,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      DateFormat('MMMM d, yyyy').format(selectedDay),
                      style: TextStyle(
                        color: isDark ? AppColors.darkText : AppColors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (memories.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.amber.withOpacity(0.12)
                          : AppColors.amberGlow,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.amber.withOpacity(0.25),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${memories.length} memor${memories.length == 1 ? 'y' : 'ies'}',
                      style: TextStyle(
                        color: isDark ? AppColors.amber : AppColors.inkLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Empty or list
        if (memories.isEmpty)
          SliverToBoxAdapter(child: _EmptyDay(isDark: isDark))
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.builder(
              itemCount: memories.length,
              itemBuilder: (context, i) =>
                  _MemoryCard(memory: memories[i], isDark: isDark),
            ),
          ),
      ],
    );
  }
}

// ─── Month Summary Sliver ────────────────────────────────────────
class _MonthSummarySliver extends StatelessWidget {
  final Map<DateTime, List<Memory>> grouped;
  final DateTime focusedDay;
  final bool isDark;

  const _MonthSummarySliver({
    required this.grouped,
    required this.focusedDay,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final monthEntries =
        grouped.entries
            .where(
              (e) =>
                  e.key.year == focusedDay.year &&
                  e.key.month == focusedDay.month,
            )
            .toList()
          ..sort((a, b) => b.key.compareTo(a.key));

    final totalMemories = monthEntries.fold(
      0,
      (sum, e) => sum + e.value.length,
    );

    return SliverMainAxisGroup(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: Row(
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(focusedDay),
                  style: TextStyle(
                    color: isDark ? AppColors.darkText : AppColors.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const Spacer(),
                if (totalMemories > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.amber.withOpacity(0.12)
                          : AppColors.amberGlow,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.amber.withOpacity(0.25),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '$totalMemories memor${totalMemories == 1 ? 'y' : 'ies'}',
                      style: TextStyle(
                        color: isDark ? AppColors.amber : AppColors.inkLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Empty or list
        if (monthEntries.isEmpty)
          SliverToBoxAdapter(child: _EmptyMonth(isDark: isDark))
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.builder(
              itemCount: monthEntries.length,
              itemBuilder: (context, i) => _DayGroup(
                date: monthEntries[i].key,
                memories: monthEntries[i].value,
                isDark: isDark,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Day Group ───────────────────────────────────────────────────
class _DayGroup extends StatelessWidget {
  final DateTime date;
  final List<Memory> memories;
  final bool isDark;

  const _DayGroup({
    required this.date,
    required this.memories,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 4),
          child: Row(
            children: [
              Text(
                DateFormat('MMM d').format(date),
                style: TextStyle(
                  color: isDark ? AppColors.darkMist : AppColors.mist,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(width: 8),
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
        ),
        ...memories.map((m) => _MemoryCard(memory: m, isDark: isDark)),
      ],
    );
  }
}

// ─── Memory Card ─────────────────────────────────────────────────
class _MemoryCard extends StatelessWidget {
  final Memory memory;
  final bool isDark;

  const _MemoryCard({required this.memory, required this.isDark});

  Color _accentColor() {
    switch (memory.emoji) {
      case '🌿':
      case '🌱':
      case '🍃':
        return AppColors.sage;
      case '☕':
      case '🍵':
      case '🫖':
        return AppColors.dustyRose;
      case '📚':
      case '📖':
      case '🎵':
        return AppColors.sky;
      case '🌅':
      case '☀️':
        return AppColors.sunflower;
      case '🍽️':
      case '🍕':
      case '🍜':
        return AppColors.peach;
      default:
        return AppColors.fog;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.warmWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.black.withOpacity(0.05),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? accent.withOpacity(0.18)
                        : accent.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Center(
                    child: Text(
                      memory.emoji,
                      style: const TextStyle(fontSize: 21),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              memory.title,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.ink,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (memory.isFavorite)
                            const Icon(
                              Icons.favorite_rounded,
                              size: 13,
                              color: AppColors.amber,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        memory.content,
                        style: TextStyle(
                          color: isDark ? AppColors.darkMist : AppColors.mist,
                          fontSize: 12.5,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

// ─── Empty Day ───────────────────────────────────────────────────
class _EmptyDay extends StatelessWidget {
  final bool isDark;
  const _EmptyDay({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : AppColors.softBeige,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text('📅', style: TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'No memories on this day',
              style: TextStyle(
                color: isDark ? AppColors.darkText : AppColors.ink,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Tap + to capture this moment',
              style: TextStyle(
                color: isDark ? AppColors.darkMist : AppColors.mist,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Add Memory',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty Month ─────────────────────────────────────────────────
class _EmptyMonth extends StatelessWidget {
  final bool isDark;
  const _EmptyMonth({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🗓️', style: TextStyle(fontSize: 38)),
            const SizedBox(height: 12),
            Text(
              'No memories this month yet',
              style: TextStyle(
                color: isDark ? AppColors.darkMist : AppColors.mist,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
