import 'package:flutter/material.dart';
import 'package:memo/core/app_colors.dart';

class EmptyDay extends StatelessWidget {
  const EmptyDay({super.key});

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
                color: AppColors.accentPurple.withOpacity(0.25),
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
                color: AppColors.accentPurple,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 5),
            // Text(
            //   'Tap + to capture this moment',
            //   style: TextStyle(color: AppColors.accentPurple, fontSize: 13),
            // ),
            // const SizedBox(height: 18),
            // GestureDetector(
            //   onTap: () {},
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 22,
            //       vertical: 10,
            //     ),
            //     decoration: BoxDecoration(
            //       color: AppColors.accentPurple,
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: const Text(
            //       'Add Memory',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontWeight: FontWeight.w700,
            //         fontSize: 13,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
