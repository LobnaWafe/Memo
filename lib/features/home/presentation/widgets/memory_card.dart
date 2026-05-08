import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:memo/constants.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:memo/shared/data/memory_model.dart';

class MemoryCard extends StatelessWidget {
  final MemoryModel memory;
  final bool showFullText;

  const MemoryCard({
    super.key,
    required this.memory,
    this.showFullText = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final moodColor = _getMoodColor(memory.feelingName);

    return GestureDetector(
      onTap: () => context.push('/memory/${memory.id}', extra: memory),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: moodColor.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: (isDark ? Colors.black : AppColors.warmBeige)
                  .withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image (لو موجودة) ──
              if (memory.imagePath != null) _ImageSection(memory: memory),

              // ── Content ──
              _ContentSection(
                memory: memory,
                showFullText: showFullText,
                moodColor: moodColor,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Image Section
// ─────────────────────────────────────────────────────

class _ImageSection extends StatelessWidget {
  final MemoryModel memory;
  const _ImageSection({required this.memory});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'memory-image-${memory.id}',
      child: Container(
        height: 180,
        width: double.infinity,
        color: AppColors.softBeige,
        child: Image.file(
          File(memory.imagePath!),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.softBeige,
            child: const Icon(
              Icons.image_not_supported_rounded,
              color: AppColors.textHint,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Content Section
// ─────────────────────────────────────────────────────

class _ContentSection extends StatelessWidget {
  final MemoryModel memory;
  final bool showFullText;
  final Color moodColor;
  final bool isDark;

  const _ContentSection({
    required this.memory,
    required this.showFullText,
    required this.moodColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Date + Mood Chip ──
          Row(
            children: [
              // Date
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textHint,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM d, yyyy').format(memory.time),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textHint,
                          ),
                    ),
                  ],
                ),
              ),

              // Mood chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: moodColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      feelingEmoji(memory.feelingName),
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      memory.feelingName,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Description ──
          Text(
            memory.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                  height: 1.6,
                ),
            maxLines: showFullText ? null : 3,
            overflow: showFullText ? null : TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          // ── Tags + Favorite ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tags
              if (memory.tags != null && memory.tags!.isNotEmpty)
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    children: memory.tags!
                        .take(2)
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lilac.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '#$tag',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppColors.accentPurple,
                                  ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              else
                const Spacer(),

              // Favorite button
              GestureDetector(
                onTap: () {
                  context.read<HomeCubit>().toggleFav(
                        memory.id,
                        memory.isFav,
                      );
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    memory.isFav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    key: ValueKey(memory.isFav),
                    color: memory.isFav
                        ? AppColors.accentRose
                        : AppColors.textHint,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────

Color _getMoodColor(String feeling) {
  switch (feeling.toLowerCase()) {
    case 'happy':
    case 'excited':
      return const Color(0xFFFFC107); // sunflower
    case 'calm':
    case 'peaceful':
      return const Color(0xFF8BC34A); // sage
    case 'sad':
    case 'lonely':
      return const Color(0xFF64B5F6); // sky
    case 'anxious':
    case 'stressed':
      return const Color(0xFFE57373); // dusty rose
    case 'grateful':
    case 'love':
      return const Color(0xFFFFAB91); // peach
    default:
      return const Color(0xFFB0BEC5); // fog
  }
}
