import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memo/core/app_colors.dart';

class AppBarAction extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const AppBarAction({
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 36,
        height: 36,

        margin: const EdgeInsets.only(right: 4, top: 8, bottom: 8),

        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.05),

          borderRadius: BorderRadius.circular(10),
        ),

        child: Icon(
          icon,
          size: 18,

          color: isDark ? AppColors.darkText : AppColors.ink,
        ),
      ),
    );
  }
}