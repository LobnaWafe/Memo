import 'package:flutter/material.dart';
import 'package:memo/core/app_colors.dart';

class NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const NavButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.accentPurple.withOpacity(0.25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppColors.accentPurple),
      ),
    );
  }
}
