import 'package:flutter/material.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/features/insights/presentation/widgets/insights_view_body.dart';

class InsightsView extends StatelessWidget {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           backgroundColor:  AppColors.creamWhite,
      appBar: AppBar(
        backgroundColor: AppColors.creamWhite,
        title: const Text('Insights'),
      ),
      body: SafeArea(child: 
      InsightsViewBody()
      ),
    );
  }
}