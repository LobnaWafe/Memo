import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/features/calender/presentation/widgets/empty_day.dart';
import 'package:memo/features/calender/presentation/widgets/memory_card.dart';
import 'package:memo/models/memory.dart';
import 'package:memo/shared/data/memory_model.dart';

class SelectedDaySliver extends StatelessWidget {
  final DateTime selectedDay;
  final List<MemoryModel> memories;
  final bool isDark;

  const SelectedDaySliver({
    super.key,
    required this.selectedDay,
    required this.memories,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        // ── Header ──
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
                        color: isDark
                            ? AppColors.softPurple
                            : AppColors.accentPurple,
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

        // ── Empty or List ──
        if (memories.isEmpty)
          SliverToBoxAdapter(child: EmptyDay(isDark: isDark))
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.builder(
              itemCount: memories.length,
              itemBuilder: (context, i) =>
                  MemoryCard(memory: memories[i], isDark: isDark),
            ),
          ),
      ],
    );
  }
}
