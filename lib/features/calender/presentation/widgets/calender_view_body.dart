import 'package:flutter/material.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/features/calender/presentation/data/dummy_memories.dart';
import 'package:memo/features/calender/presentation/widgets/calendar_widget.dart';
import 'package:memo/features/calender/presentation/widgets/month_summary_sliver.dart';
import 'package:memo/features/calender/presentation/widgets/selected_day_sliver.dart';
import 'package:memo/models/memory.dart';

class CalenderViewBody extends StatefulWidget {
  const CalenderViewBody({super.key});

  @override
  State<CalenderViewBody> createState() => _CalenderViewBodyState();
}

class _CalenderViewBodyState extends State<CalenderViewBody> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isDark = false;
  late final Map<DateTime, List<Memory>> _grouped;

  @override
  void initState() {
    super.initState();
    _grouped = buildGrouped();
  }

  List<Memory> _getMemoriesForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _grouped[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDark ? AppColors.darkBg : AppColors.creamWhite,
      appBar: _buildAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Calendar ──
          SliverToBoxAdapter(
            child: CalendarWidget(
              isDark: _isDark,
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              grouped: _grouped,
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
              },
              onPageChanged: (focused) {
                setState(() {
                  _focusedDay = focused;
                  _selectedDay = null;
                });
              },
            ),
          ),

          // ── Content below calendar ──
          if (_selectedDay != null)
            SelectedDaySliver(
              selectedDay: _selectedDay!,
              memories: _getMemoriesForDay(_selectedDay!),
              isDark: _isDark,
            )
          else
            MonthSummarySliver(
              grouped: _grouped,
              focusedDay: _focusedDay,
              isDark: _isDark,
            ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: _isDark ? AppColors.darkBg : AppColors.creamWhite,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 22,
      title: Text(
        'Calendar',
        style: TextStyle(
          color: _isDark ? AppColors.softPurple : AppColors.accentPurple,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
        ),
      ),
      actions: [
        // Today button
        GestureDetector(
          onTap: () => setState(() {
            _focusedDay = DateTime.now();
            _selectedDay = DateTime.now();
          }),
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: _isDark
                  ? AppColors.amber.withOpacity(0.15)
                  : AppColors.amberGlow,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.amber.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Today',
              style: TextStyle(
                color: _isDark ? AppColors.amber : AppColors.inkLight,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        // Theme toggle
        GestureDetector(
          onTap: () => setState(() => _isDark = !_isDark),
          child: Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 14, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: _isDark
                  ? Colors.white.withOpacity(0.07)
                  : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 17,
              color: _isDark ? AppColors.darkText : AppColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}
