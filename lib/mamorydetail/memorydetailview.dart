import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:memo/shared/data/memory_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

const List<Map<String, String>> kMoods = [
  {'emoji': '😊', 'label': 'Happy'},
  {'emoji': '😢', 'label': 'Sad'},
  {'emoji': '😌', 'label': 'Calm'},
  {'emoji': '🥳', 'label': 'Excited'},
  {'emoji': '😠', 'label': 'Angry'},
  {'emoji': '😰', 'label': 'Anxious'},
  {'emoji': '🙏', 'label': 'Grateful'},
  {'emoji': '💪', 'label': 'Productive'},
  {'emoji': '😴', 'label': 'Tired'},
  {'emoji': '🥰', 'label': 'Loved'},
];

String feelingEmoji(String feeling) {
  final match = kMoods.firstWhere(
    (m) => m['label'] == feeling,
    orElse: () => {'emoji': '📝', 'label': ''},
  );
  return match['emoji']!;
}

class MemoryDetailView extends StatelessWidget {
  final MemoryModel memory;

  const MemoryDetailView({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _DetailAppBar(memory: memory, homeCubit: homeCubit),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FeelingChip(feelingName: memory.feelingName),
                  const SizedBox(height: 20),
                  _DateTimeRow(time: memory.time),
                  const SizedBox(height: 28),
                  Divider(
                    color: AppColors.accentPurple.withOpacity(0.12),
                    height: 1,
                  ),
                  const SizedBox(height: 28),
                  const _SectionLabel(label: 'Memory'),
                  const SizedBox(height: 12),
                  Text(
                    memory.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.75,
                      fontSize: 16,
                    ),
                  ),
                  if (memory.imagePath != null) ...[
                    const SizedBox(height: 28),
                    const _SectionLabel(label: 'Photo'),
                    const SizedBox(height: 12),
                    _MemoryImage(imagePath: memory.imagePath!),
                  ],
                  if (memory.tags != null && memory.tags!.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    const _SectionLabel(label: 'Tags'),
                    const SizedBox(height: 12),
                    _TagsRow(tags: memory.tags!),
                  ],
                  if (memory.isFav) ...[
                    const SizedBox(height: 32),
                    const _FavBadge(),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailAppBar extends StatelessWidget {
  final MemoryModel memory;
  final HomeCubit homeCubit;
  const _DetailAppBar({required this.memory, required this.homeCubit});
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Memory',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this memory? This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              homeCubit.deleteMemory(memory.id);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditMemorySheet(memory: memory, homeCubit: homeCubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage =
        memory.imagePath != null && File(memory.imagePath!).existsSync();
    return SliverAppBar(
      expandedHeight: hasImage ? 300 : 200,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.creamWhite,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
            ],
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
      ),
      actions: [
        _AppBarActionButton(
          icon: Icons.edit_rounded,
          hasImage: hasImage,
          onTap: () => _showEditSheet(context),
        ),
        const SizedBox(width: 4),
        _AppBarActionButton(
          icon: Icons.delete_outline_rounded,
          hasImage: hasImage,
          iconColor: Colors.redAccent.withOpacity(0.85),
          onTap: () => _showDeleteDialog(context),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Text(
          memory.feelingName,
          style: TextStyle(
            color: hasImage ? Colors.white : AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            shadows: hasImage
                ? [const Shadow(color: Colors.black38, blurRadius: 8)]
                : [],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        background: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(memory.imagePath!), fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.55),
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              )
            : const _GradientHeader(),
      ),
    );
  }
}

class _AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final bool hasImage;
  final Color? iconColor;
  final VoidCallback onTap;

  const _AppBarActionButton({
    required this.icon,
    required this.hasImage,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color resolvedIconColor =
        iconColor ?? (hasImage ? Colors.white : AppColors.textPrimary);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
          ],
        ),
        child: Icon(icon, color: resolvedIconColor, size: 18),
      ),
    );
  }
}

class _EditMemorySheet extends StatefulWidget {
  final MemoryModel memory;
  final HomeCubit homeCubit;
  const _EditMemorySheet({required this.memory, required this.homeCubit});
  @override
  State<_EditMemorySheet> createState() => _EditMemorySheetState();
}

class _EditMemorySheetState extends State<_EditMemorySheet> {
  late TextEditingController _descController;
  late TextEditingController _tagsController;
  String? _imagePath;
  bool _isSaving = false;
  late String _selectedMood;
  late String _selectedEmoji;
  @override
  void initState() {
    super.initState();
    _selectedMood = widget.memory.feelingName;
    _selectedEmoji = feelingEmoji(_selectedMood);
    _descController = TextEditingController(text: widget.memory.description);
    _tagsController = TextEditingController(
      text: widget.memory.tags?.join(', ') ?? '',
    );
    _imagePath = widget.memory.imagePath;
  }

  @override
  void dispose() {
    _descController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName =
        'memory_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}';
    final savedFile = await File(picked.path).copy('${appDir.path}/$fileName');

    setState(() => _imagePath = savedFile.path);
  }

  void _removeImage() => setState(() => _imagePath = null);

  Future<void> _save() async {
    if (_selectedMood.isEmpty || _descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feeling and description are required.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final rawTags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    await widget.homeCubit.editMemory(
      id: widget.memory.id,
      feelingName: _selectedMood,
      description: _descController.text.trim(),
      imagePath: _imagePath,
      tags: rawTags.isEmpty ? null : rawTags,
    );
    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.of(context).pop(); // close sheet
      Navigator.of(context).pop(); // go back — detail page has stale data
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.97,
      expand: false,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Edit Memory',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close_rounded, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const Divider(color: Colors.black12),
            // Form
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                children: [
                  // ── Mood Picker ──
                  const _SheetLabel(label: 'Feeling'),
                  const SizedBox(height: 12),
                  _MoodPicker(
                    selectedMood: _selectedMood,
                    onMoodSelected: (mood, emoji) {
                      setState(() {
                        _selectedMood = mood;
                        _selectedEmoji = emoji;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // ── Description ──
                  const _SheetLabel(label: 'Description'),
                  const SizedBox(height: 8),
                  _SheetTextField(
                    controller: _descController,
                    hint: 'Write about your memory…',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  // ── Tags ──
                  const _SheetLabel(label: 'Tags (comma separated)'),
                  const SizedBox(height: 8),
                  _SheetTextField(
                    controller: _tagsController,
                    hint: 'e.g. family, summer, trip',
                  ),
                  const SizedBox(height: 24),
                  // ── Image ──
                  const _SheetLabel(label: 'Photo'),
                  const SizedBox(height: 10),
                  if (_imagePath != null && File(_imagePath!).existsSync()) ...[
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            File(_imagePath!),
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: _removeImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _ChangePhotoButton(onTap: _pickImage),
                  ] else ...[
                    _AddPhotoButton(onTap: _pickImage),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodPicker extends StatelessWidget {
  final String selectedMood;
  final void Function(String mood, String emoji) onMoodSelected;
  const _MoodPicker({required this.selectedMood, required this.onMoodSelected});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: kMoods.map((mood) {
        final isSelected = mood['label'] == selectedMood;
        return GestureDetector(
          onTap: () => onMoodSelected(mood['label']!, mood['emoji']!),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accentPurple
                  : AppColors.accentPurple.withOpacity(0.07),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected
                    ? AppColors.accentPurple
                    : AppColors.accentPurple.withOpacity(0.2),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(mood['emoji']!, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  mood['label']!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SheetLabel extends StatelessWidget {
  final String label;
  const _SheetLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: AppColors.textHint,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _SheetTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _SheetTextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textHint, fontSize: 15),
        filled: true,
        fillColor: AppColors.creamWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.textHint.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.textHint.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.accentPurple, width: 1.5),
        ),
      ),
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddPhotoButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.creamWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.textHint.withOpacity(0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_rounded,
              color: AppColors.accentPurple,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              'Add Photo',
              style: TextStyle(
                color: AppColors.accentPurple,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangePhotoButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ChangePhotoButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.accentPurple.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.accentPurple.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_rounded,
              color: AppColors.accentPurple,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'Change Photo',
              style: TextStyle(
                color: AppColors.accentPurple,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientHeader extends StatelessWidget {
  const _GradientHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.lavender, AppColors.softPurple.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(child: Text('📝', style: TextStyle(fontSize: 64))),
    );
  }
}

class _FeelingChip extends StatelessWidget {
  final String feelingName;
  const _FeelingChip({required this.feelingName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.accentPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.accentPurple.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(feelingEmoji(feelingName), style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            feelingName,
            style: TextStyle(
              color: AppColors.accentPurple,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateTimeRow extends StatelessWidget {
  final DateTime time;
  const _DateTimeRow({required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _InfoPill(
          icon: Icons.calendar_today_rounded,
          label: DateFormat('EEE, MMM d yyyy').format(time),
        ),
        const SizedBox(width: 10),
        _InfoPill(
          icon: Icons.access_time_rounded,
          label: DateFormat('h:mm a').format(time),
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.textHint.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: AppColors.textHint,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _MemoryImage extends StatelessWidget {
  final String imagePath;
  const _MemoryImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        File(imagePath),
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.lavender,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Icon(
              Icons.broken_image_rounded,
              size: 40,
              color: Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}

class _TagsRow extends StatelessWidget {
  final List<String> tags;
  const _TagsRow({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.amberGlow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.amber.withOpacity(0.25)),
              ),
              child: Text(
                '#$tag',
                style: TextStyle(
                  color: AppColors.inkLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _FavBadge extends StatelessWidget {
  const _FavBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade50, Colors.red.shade50],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.pink.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_rounded,
            color: Colors.pinkAccent.shade100,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Saved as a favourite memory',
            style: TextStyle(
              color: Colors.pink.shade400,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
