import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo/constants.dart';
import 'package:memo/core/utlis/app_router.dart';
import 'package:memo/features/add_memory/presentation/view_model/add_memory_cubit/add_memory_cubit.dart';
import 'package:memo/features/add_memory/presentation/widgets/date_selector.dart';
import 'package:memo/features/add_memory/presentation/widgets/image_section.dart';
import 'package:memo/features/add_memory/presentation/widgets/tags_section.dart';
import 'package:path_provider/path_provider.dart';

class AddMemoryViewBody extends StatefulWidget {
  const AddMemoryViewBody({super.key});

  @override
  State<AddMemoryViewBody> createState() =>
      _AddMemoryViewBodyState();
}

class _AddMemoryViewBodyState
    extends State<AddMemoryViewBody> {
  DateTime selectedDate = DateTime.now();
  String selectedMood = "Happy";

  final TextEditingController description =
      TextEditingController();

  String? imagePath;
  bool isLoading = false;

  void onImagePicked(String path) {
    setState(() {
      imagePath = path;
    });
  }


  Future<void> saveMemory() async {
    if (description.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Write something first"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      String? savedImage;

      if (imagePath != null) {
        final dir =
            await getApplicationDocumentsDirectory();

        final fileName =
            "${DateTime.now().millisecondsSinceEpoch}.jpg";

        final file = await File(imagePath!).copy(
          "${dir.path}/$fileName",
        );

        savedImage = file.path;
      }

      await context.read<AddMemoryCubit>().addMemory(
            feelingName: selectedMood,
            description: description.text.trim(),
            time: selectedDate,
            imagePath: savedImage,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Memory saved"),
          backgroundColor: Colors.green,
        ),
      );

    context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    const accentPurple = Color(0xFF9F7BF6);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          DateSelector(
            date: selectedDate,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (picked != null) {
                setState(() => selectedDate = picked);
              }
            },
          ),

          const SizedBox(height: 20),

          const Text(
            "How are you feeling?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: moods.length,
              itemBuilder: (context, i) {
                final mood = moods[i];
                final isSelected =
                    mood['label'] == selectedMood;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMood = mood['label']!;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 80,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accentPurple.withOpacity(0.15)
                          : Colors.white,
                      borderRadius:
                          BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? accentPurple
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(mood['emoji']!,
                            style: const TextStyle(
                                fontSize: 26)),
                        const SizedBox(height: 4),
                        Text(
                          mood['label']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? accentPurple
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Your memory",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          TextFormField(
            controller: description,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Write your memory here...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Image (optional)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ImageSection(
            onImagePicked: onImagePicked,
          ),

          const SizedBox(height: 20),

          const Text(
            "Tags",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          TagsSection(accentColor: accentPurple),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: isLoading ? null : saveMemory,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentPurple,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Save Memory"),
            ),
          ),
        ],
      ),
    );
  }
}