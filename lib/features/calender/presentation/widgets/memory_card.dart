import 'package:flutter/material.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/models/memory.dart';

class MemoryCard extends StatelessWidget {
  final Memory memory;
  final bool isDark;

  const MemoryCard({super.key, required this.memory, required this.isDark});

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
