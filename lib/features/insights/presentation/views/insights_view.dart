import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/features/insights/presentation/view_model/cubit/insights_cubit.dart';
import 'package:memo/features/insights/presentation/widgets/insights_view_body.dart';

class InsightsView extends StatelessWidget {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      appBar: AppBar(
        backgroundColor: AppColors.creamWhite,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          'Insights',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.accentPurple, // ✅ اللون هنا
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => InsightsCubit(),
          child: const InsightsViewBody(),
        ),
      ),
    );
  }
}
