import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/features/calender/presentation/widgets/memory_card.dart';
import 'package:memo/models/memory.dart';
import 'package:memo/shared/data/memory_model.dart';

class DayGroup extends StatelessWidget {
  final DateTime date;
  final List<MemoryModel> memories;
  final bool isDark;

  const DayGroup({
    super.key,
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
        ...memories.map((m) => MemoryCard(memory: m, isDark: isDark)),
      ],
    );
  }
}
