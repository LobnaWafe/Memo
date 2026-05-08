import 'package:flutter/material.dart';
import 'package:memo/core/app_colors.dart';

class EmptyMonth extends StatelessWidget {
  const EmptyMonth({super.key});

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
              style: TextStyle(color: AppColors.accentPurple, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
