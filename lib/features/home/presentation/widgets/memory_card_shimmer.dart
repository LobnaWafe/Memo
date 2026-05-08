import 'package:flutter/material.dart';
import 'package:memo/core/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class MemoryCardShimmer extends StatelessWidget {
  const MemoryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkCard : AppColors.lightGray;
    final highlightColor =
        isDark ? AppColors.darkSurface : AppColors.creamWhite;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        children: List.generate(
          3,
          (i) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (i % 2 == 0)
                  Container(
                    height: 180,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 14,
                            width: 120,
                            color: Colors.white,
                          ),
                          const Spacer(),
                          Container(
                            height: 24,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                          height: 14,
                          width: double.infinity,
                          color: Colors.white),
                      const SizedBox(height: 6),
                      Container(
                          height: 14,
                          width: double.infinity,
                          color: Colors.white),
                      const SizedBox(height: 6),
                      Container(height: 14, width: 200, color: Colors.white),
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

class GridShimmer extends StatelessWidget {
  const GridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkCard : AppColors.lightGray,
      highlightColor: isDark ? AppColors.darkSurface : AppColors.creamWhite,
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: List.generate(
          12,
          (i) => Container(color: Colors.white),
        ),
      ),
    );
  }
}
