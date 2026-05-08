import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo/features/calender/cubit/calender_cubit.dart';
import 'package:memo/features/calender/presentation/widgets/calender_view_body.dart';


class CalenderView extends StatelessWidget {
  const CalenderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalenderCubit(),
      child: const Scaffold(
        body: SafeArea(child: CalenderViewBody()),
      ),
    );
  }
}