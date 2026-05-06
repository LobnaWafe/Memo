import 'package:flutter/material.dart';
import 'package:memo/features/add_memory/presentation/widgets/add_memory_view_body.dart';

class AddMemoryView extends StatelessWidget {
  const AddMemoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
      AddMemoryViewBody()),
    );
  }
}