import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/features/calender/cubit/calender_cubit.dart';
import 'package:memo/features/calender/cubit/calender_state.dart';
import 'package:memo/features/calender/presentation/widgets/calendar_widget.dart';
import 'package:memo/features/calender/presentation/widgets/month_summary_sliver.dart';
import 'package:memo/features/calender/presentation/widgets/selected_day_sliver.dart';
import 'package:memo/shared/data/memory_model.dart';

class CalenderViewBody extends StatefulWidget {
  const CalenderViewBody({super.key});

  @override
  State<CalenderViewBody> createState() => _CalenderViewBodyState();
}

class _CalenderViewBodyState extends State<CalenderViewBody> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    // تحميل الذكريات من Hive عند فتح الشاشة
    context.read<CalenderCubit>().loadMemories();
  }

  List<MemoryModel> _getMemoriesForDay(
    Map<DateTime, List<MemoryModel>> grouped,
    DateTime day,
  ) {
    final key = DateTime(day.year, day.month, day.day);
    return grouped[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      appBar: _buildAppBar(),
      body: BlocBuilder<CalenderCubit, CalenderState>(
        builder: (context, state) {
          // بينما البيانات بتتحمل
          if (state is CalenderInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          final grouped = state is CalenderLoaded
              ? state.grouped
              : <DateTime, List<MemoryModel>>{};

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Calendar ──
              SliverToBoxAdapter(
                child: CalendarWidget(
                  focusedDay: _focusedDay,
                  selectedDay: _selectedDay,
                  grouped: grouped,
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
                  memories: _getMemoriesForDay(grouped, _selectedDay!),
                )
              else
                MonthSummarySliver(grouped: grouped, focusedDay: _focusedDay),

              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.creamWhite,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 22,
      title: Text(
        'Calendar',
        style: TextStyle(
          color: AppColors.accentPurple,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => setState(() {
            _focusedDay = DateTime.now();
            _selectedDay = DateTime.now();
          }),
          child: Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.amberGlow,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.amber.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Today',
              style: TextStyle(
                color: AppColors.inkLight,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
