import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/features/add_memory/presentation/view_model/add_memory_cubit/add_memory_cubit.dart';
import 'package:memo/features/add_memory/presentation/widgets/add_memory_view_body.dart';
import 'package:memo/shared/repo/memory_repo_imp.dart';

class AddMemoryView extends StatelessWidget {
  const AddMemoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      appBar: AppBar(
        backgroundColor: AppColors.creamWhite,
        title: const Text('New Memory'),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => AddMemoryCubit(MemoryRepoImpl()),
          child: AddMemoryViewBody(),
        ),
      ),
    );
  }
}
