import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/features/calender/presentation/widgets/day_group.dart';
import 'package:memo/features/calender/presentation/widgets/empty_month.dart';
import 'package:memo/models/memory.dart';

class MonthSummarySliver extends StatelessWidget {
  final Map<DateTime, List<Memory>> grouped;
  final DateTime focusedDay;
  final bool isDark;

  const MonthSummarySliver({
    super.key,
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
        // ── Header ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: Row(
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(focusedDay),
                  style: TextStyle(
                    color: isDark
                        ? AppColors.softPurple
                        : AppColors.accentPurple,
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

        // ── Empty or List ──
        if (monthEntries.isEmpty)
          SliverToBoxAdapter(child: EmptyMonth(isDark: isDark))
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.builder(
              itemCount: monthEntries.length,
              itemBuilder: (context, i) => DayGroup(
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
