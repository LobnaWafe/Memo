import 'package:flutter/material.dart';
import 'package:memo/features/insights/presentation/widgets/insights_view_body.dart';

class InsightsView extends StatelessWidget {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
      InsightsViewBody()
      ),
    );
  }
}