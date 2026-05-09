import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/shared/data/memory_model.dart';

class MemoryDetailView extends StatelessWidget {
  final MemoryModel memory;

  const MemoryDetailView({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.creamWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _DetailAppBar(memory: memory, isDark: isDark),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Feeling chip ──
                  _FeelingChip(feelingName: memory.feelingName),

                  const SizedBox(height: 20),

                  // ── Date & Time ──
                  _DateTimeRow(time: memory.time),

                  const SizedBox(height: 28),

                  // ── Divider ──
                  Divider(
                    color: isDark
                        ? Colors.white12
                        : AppColors.accentPurple.withOpacity(0.12),
                    height: 1,
                  ),

                  const SizedBox(height: 28),

                  // ── Description ──
                  _SectionLabel(label: 'Memory', isDark: isDark),
                  const SizedBox(height: 12),
                  Text(
                    memory.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary.withOpacity(0.85)
                          : AppColors.textPrimary,
                      height: 1.75,
                      fontSize: 16,
                    ),
                  ),

                  // ── Image ──
                  if (memory.imagePath != null) ...[
                    const SizedBox(height: 28),
                    _SectionLabel(label: 'Photo', isDark: isDark),
                    const SizedBox(height: 12),
                    _MemoryImage(imagePath: memory.imagePath!),
                  ],

                  // ── Tags ──
                  if (memory.tags != null && memory.tags!.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    _SectionLabel(label: 'Tags', isDark: isDark),
                    const SizedBox(height: 12),
                    _TagsRow(tags: memory.tags!),
                  ],

                  // ── Favourite badge ──
                  if (memory.isFav) ...[
                    const SizedBox(height: 32),
                    _FavBadge(),
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

// ─────────────────────────────────────────────────────
// Sliver App Bar with Hero image or gradient header
// ─────────────────────────────────────────────────────
class _DetailAppBar extends StatelessWidget {
  final MemoryModel memory;
  final bool isDark;

  const _DetailAppBar({required this.memory, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final hasImage =
        memory.imagePath != null && File(memory.imagePath!).existsSync();

    return SliverAppBar(
      expandedHeight: hasImage ? 300 : 200,
      pinned: true,
      stretch: true,
      backgroundColor: isDark ? AppColors.darkBg : AppColors.creamWhite,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.12)
                : Colors.white.withOpacity(0.85),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
            ],
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? Colors.white : AppColors.textPrimary,
            size: 20,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Text(
          memory.feelingName,
          style: TextStyle(
            color: hasImage
                ? Colors.white
                : (isDark ? Colors.white : AppColors.textPrimary),
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
                  // gradient overlay so title is readable
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
            : _GradientHeader(isDark: isDark),
      ),
    );
  }
}

class _GradientHeader extends StatelessWidget {
  final bool isDark;
  const _GradientHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.accentPurple.withOpacity(0.35), AppColors.darkBg]
              : [AppColors.lavender, AppColors.softPurple.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(child: Text('📝', style: TextStyle(fontSize: 64))),
    );
  }
}

// ─────────────────────────────────────────────────────
// Feeling chip
// ─────────────────────────────────────────────────────
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
          Icon(
            Icons.auto_awesome_rounded,
            size: 14,
            color: AppColors.accentPurple,
          ),
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

// ─────────────────────────────────────────────────────
// Date & Time
// ─────────────────────────────────────────────────────
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.06) : AppColors.creamWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.textHint.withOpacity(0.2),
        ),
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

// ─────────────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: isDark
            ? AppColors.darkTextPrimary.withOpacity(0.4)
            : AppColors.textHint,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Memory image
// ─────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────
// Tags
// ─────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────
// Favourite badge
// ─────────────────────────────────────────────────────
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
