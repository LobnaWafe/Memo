import 'package:flutter/material.dart';
import 'package:memo/core/app_colors.dart';

class DayCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSelected;
  final bool hasData;
  final bool isFuture;
  final bool isWeekend;

  const DayCell({
    super.key,
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.hasData,
    required this.isFuture,
    required this.isWeekend,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.transparent;
    Color textColor;
    FontWeight fontWeight = FontWeight.w500;

    if (isSelected) {
      bgColor = AppColors.accentPurple;
      textColor = Colors.white;
      fontWeight = FontWeight.w800;
    } else if (isToday) {
      textColor = AppColors.amber;
      fontWeight = FontWeight.w700;
    } else if (isWeekend) {
      textColor = AppColors.roseAccent;
    } else if (isFuture) {
      textColor = AppColors.mist;
    } else {
      textColor = AppColors.ink;
    }

    return Center(
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: fontWeight,
              ),
            ),
            if (hasData && !isSelected)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isToday
                        ? AppColors.amber
                        : AppColors.accentRose.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
