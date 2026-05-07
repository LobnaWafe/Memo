import 'package:flutter/material.dart';
import 'package:memo/core/app_colors.dart';

class StatChip extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;
  final bool isDark;

  const StatChip({
    super.key,
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
