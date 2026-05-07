import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/features/calender/presentation/widgets/day_cell.dart';
import 'package:memo/features/calender/presentation/widgets/nav_button.dart';
import 'package:memo/features/calender/presentation/widgets/stat_chip.dart';
import 'package:memo/models/memory.dart';

class CalendarWidget extends StatelessWidget {
  final bool isDark;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Map<DateTime, List<Memory>> grouped;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(DateTime) onPageChanged;

  const CalendarWidget({
    super.key,
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
                        color: isDark
                            ? AppColors.softPurple
                            : AppColors.accentPurple,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                NavButton(
                  icon: Icons.chevron_left_rounded,
                  isDark: isDark,
                  onTap: () {
                    onPageChanged(
                      DateTime(focusedDay.year, focusedDay.month - 1),
                    );
                  },
                ),
                const SizedBox(width: 6),
                NavButton(
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
                  child: DayCell(
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
                StatChip(
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
                StatChip(
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
                StatChip(
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
