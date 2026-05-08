import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/features/calender/presentation/widgets/memory_card.dart';

import 'package:memo/shared/data/memory_model.dart';

class DayGroup extends StatelessWidget {
  final DateTime date;
  final List<MemoryModel> memories;

  const DayGroup({super.key, required this.date, required this.memories});

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
                  color: AppColors.accentPurple,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 1,
                  color: AppColors.accentPurple.withOpacity(0.25),
                ),
              ),
            ],
          ),
        ),
        ...memories.map((m) => MemoryCard(memory: m)),
      ],
    );
  }
}
