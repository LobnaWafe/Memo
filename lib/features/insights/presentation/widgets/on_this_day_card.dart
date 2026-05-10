
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnThisDayCard extends StatelessWidget {
  final List memories;
  const OnThisDayCard({required this.memories});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade300, Colors.purple.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "✨ On this day: ${memories.length} memories captured.",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
