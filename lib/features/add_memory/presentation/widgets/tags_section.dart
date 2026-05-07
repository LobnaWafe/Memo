import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:memo/features/add_memory/presentation/view_model/add_memory_cubit/add_memory_cubit.dart';

class TagsSection extends StatefulWidget {
  final Color accentColor;

  const TagsSection({
    super.key,
    required this.accentColor,
  });

  @override
  State<TagsSection> createState() => _TagsSectionState();
}

class _TagsSectionState extends State<TagsSection> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddMemoryCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // INPUT + BUTTON
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Add a tag (e.g., travel)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            GestureDetector(
              onTap: () {
                if(!cubit.tags.contains(controller.text)){
                cubit.addTag(controller.text);
                controller.clear();
                }
              },
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: widget.accentColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // TAGS WRAP
        BlocBuilder<AddMemoryCubit, AddMemoryState>(
          buildWhen: (prev, curr) =>
              curr is AddMemoryTagsUpdated,
          builder: (context, state) {
            final tags = cubit.tags;

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '#$tag',
                        style: TextStyle(
                          color: widget.accentColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),

                      GestureDetector(
                        onTap: () {
                          cubit.removeTag(tag);
                        },
                        child: const Icon(
                          Icons.close,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}