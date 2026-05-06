import 'package:flutter/material.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/features/add_memory/presentation/widgets/add_memory_view_body.dart';

class AddMemoryView extends StatelessWidget {
  const AddMemoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  AppColors.creamWhite,
      appBar: AppBar(
        backgroundColor: AppColors.creamWhite,
        title: const Text('New Memory'),
       
      ),
      body: SafeArea(child: 
      AddMemoryViewBody()),
    );
  }
}