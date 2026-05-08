import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memo/constants.dart';
import 'package:memo/shared/data/memory_model.dart';

class GalleryItem extends StatelessWidget {
  final MemoryModel memory;
  final int index;

  const GalleryItem({super.key, required this.memory, required this.index});

  @override
  Widget build(BuildContext context) {
    bool isLarge = index % 2 == 0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),

      child: AspectRatio(
        aspectRatio: isLarge ? 0.7 : 1,

        child: Stack(
          fit: StackFit.expand,

          children: [
            Image.file(File(memory.imagePath!), fit: BoxFit.cover),

            Positioned(
              bottom: 8,
              right: 8,

              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                decoration: BoxDecoration(
                  color: const Color.fromARGB(5, 244, 241, 241),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Text(
                  feelingEmoji(memory.feelingName,),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
