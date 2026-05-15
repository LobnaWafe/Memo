import 'package:flutter/material.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/features/add_memory/presentation/views/add_memory_view.dart';
import 'package:memo/features/calender/presentation/views/calender_view.dart';
import 'package:memo/features/gallery/presentation/views/gallery_view.dart';
import 'package:memo/features/home/presentation/views/home_view.dart';
import 'package:memo/features/home/presentation/widgets/home_view_body.dart';
import 'package:memo/features/insights/presentation/views/insights_view.dart';

class BottomNavView extends StatefulWidget {
  const BottomNavView({super.key});

  // 💡 إضافة هذا السطر للوصول للـ State من أي مكان
  static _BottomNavViewState? of(BuildContext context) =>
      context.findAncestorStateOfType<_BottomNavViewState>();

  @override
  State<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  int currentIndex = 0;

 
  void changeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<Widget> widgets = [
    HomeScreen(),
    CalenderView(),
    AddMemoryView(), 
    GalleryScreen(),
    InsightsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      extendBody: true,
      body: SafeArea(
        child: widgets[currentIndex],
      ),
      bottomNavigationBar: Bottomnav(
        currentIndex: currentIndex,
        onTap: changeIndex, 
      ),
    );
  }
}

class Bottomnav extends StatelessWidget {
  const Bottomnav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final navHeight = screenHeight < 700 ? 60.0 : 72.0;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: SizedBox(
          height: navHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.calendar_month_rounded,
                label: 'Calendar',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _AddButton(
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.photo_library_rounded,
                label: 'Gallery',
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavItem(
                icon: Icons.insights_rounded,
                label: 'Insights',
                isSelected: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : AppColors.textHint;

      return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                 padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22)),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.softPurple, AppColors.accentPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentPurple.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}