import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/core/utlis/app_router.dart';
import 'package:memo/features/home/presentation/search/search_cubit.dart';
import 'package:memo/features/home/presentation/search/search_state.dart';
import 'package:memo/shared/data/memory_model.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit()..init(),
      child: const _SearchBody(),
    );
  }
}

class _SearchBody extends StatefulWidget {
  const _SearchBody();

  @override
  State<_SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<_SearchBody> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.creamWhite,
      body: SafeArea(
        child: Column(
          children: [
            // ── Search Bar ──
            _SearchBar(
              controller: _controller,
              focusNode: _focusNode,
              isDark: isDark,
              onChanged: (q) => context.read<SearchCubit>().search(q),
              onClear: () {
                _controller.clear();
                context.read<SearchCubit>().clear();
              },
            ),

            // ── Results ──
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return _EmptyPrompt(isDark: isDark);
                  }

                  if (state is SearchSuccess) {
                    if (state.results.isEmpty) {
                      return _NoResults(query: state.query, isDark: isDark);
                    }
                    return _ResultsList(
                      memories: state.results,
                      isDark: isDark,
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Search bar
// ─────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDark;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.isDark,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : AppColors.lavender.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: isDark ? Colors.white70 : AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Field
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.07) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark
                      ? Colors.white12
                      : AppColors.accentPurple.withOpacity(0.15),
                ),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: AppColors.accentPurple.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textPrimary,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: 'Search memories, tags...',
                  hintStyle: TextStyle(color: AppColors.textHint, fontSize: 15),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                  suffixIcon: ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (_, value, __) => value.text.isNotEmpty
                        ? GestureDetector(
                            onTap: onClear,
                            child: Icon(
                              Icons.close_rounded,
                              color: AppColors.textHint,
                              size: 18,
                            ),
                          )
                        : const SizedBox(),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Empty state (before typing)
// ─────────────────────────────────────────────────────
class _EmptyPrompt extends StatelessWidget {
  final bool isDark;
  const _EmptyPrompt({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🔍', style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 16),
          Text(
            'Search your memories',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isDark ? Colors.white54 : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'by title, description or tag',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// No results
// ─────────────────────────────────────────────────────
class _NoResults extends StatelessWidget {
  final String query;
  final bool isDark;
  const _NoResults({required this.query, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('😶‍🌫️', style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 16),
          Text(
            'No results for "$query"',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isDark ? Colors.white54 : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try different keywords or tags',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Results list
// ─────────────────────────────────────────────────────
class _ResultsList extends StatelessWidget {
  final List<MemoryModel> memories;
  final bool isDark;
  const _ResultsList({required this.memories, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
      itemCount: memories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final m = memories[index];
        return GestureDetector(
          onTap: () => context.push(AppRouter.kMemoryDetail, extra: m),
          child: _SearchResultCard(memory: m, isDark: isDark),
        );
      },
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final MemoryModel memory;
  final bool isDark;
  const _SearchResultCard({required this.memory, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : AppColors.accentPurple.withOpacity(0.1),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leading emoji / icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.lavender.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('📝', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memory.feelingName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  memory.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 11,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM d, yyyy').format(memory.time),
                      style: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (memory.isFav) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.favorite_rounded,
                        size: 11,
                        color: Colors.pinkAccent.shade100,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
