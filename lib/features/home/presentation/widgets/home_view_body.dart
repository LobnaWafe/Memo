import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/core/utlis/app_router.dart';
import 'package:memo/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:memo/features/home/presentation/widgets/empty_state.dart';
import 'package:memo/features/home/presentation/widgets/memory_card.dart';
import 'package:memo/features/home/presentation/widgets/memory_card_shimmer.dart';
import 'package:memo/shared/data/memory_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..getMemories(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.creamWhite,
      body: CustomScrollView(
        slivers: [
          _HomeAppBar(isDark: isDark),
          const _OnThisDayBanner(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeInitial || state is HomeLoading) {
                  return const SliverToBoxAdapter(child: MemoryCardShimmer());
                }

                if (state is HomeError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Text('Something went wrong: ${state.message}'),
                      ),
                    ),
                  );
                }

                if (state is HomeSuccess) {
                  final memories = state.memories;

                  if (memories.isEmpty) {
                    return SliverToBoxAdapter(
                      child: EmptyState(
                        emoji: '📓',
                        title: 'Your journal awaits',
                        subtitle:
                            'Start capturing your memories, thoughts, and moments.',
                        actionLabel: 'Add First Memory',
                        onAction: () => context.push('/add-memory'),
                      ),
                    );
                  }

                  final grouped = <String, List<MemoryModel>>{};
                  for (final m in memories) {
                    final key = DateFormat('MMMM yyyy').format(m.time);
                    grouped.putIfAbsent(key, () => []).add(m);
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final entries = grouped.entries.toList();
                      if (index >= entries.length) return null;
                      final entry = entries[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16, top: 8),
                            child: Text(
                              entry.key,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          ...entry.value.map(
                            (m) => GestureDetector(
                              onTap: () => context.push(
                                AppRouter.kMemoryDetail,
                                extra: m,
                              ),
                              child: MemoryCard(memory: m),
                            ),
                          ),
                        ],
                      );
                    }, childCount: grouped.length),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox());
              },
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// App Bar
// ─────────────────────────────────────────────────────
class _HomeAppBar extends StatelessWidget {
  final bool isDark;
  const _HomeAppBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = _getGreeting();

    return SliverAppBar(
      expandedHeight: 140,
      floating: true,
      pinned: true,
      backgroundColor: isDark ? AppColors.darkBg : AppColors.creamWhite,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          // ✅ SafeArea + bottom: false يضمن إن الـ Column مش تتجاوز المساحة المتاحة
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment
                  .center, // ✅ توسيط عمودي بدل إنه يبدأ من فوق ويتجاوز
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  greeting,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Your Journal',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                Text(
                  DateFormat('EEEE, MMMM d').format(now),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textHint),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Builder(
          builder: (ctx) => IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.search_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: () => context.push(AppRouter.kSearchView),
        ),
        IconButton(
          icon: Icon(
            Icons.favorite_border_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: () => context.push(AppRouter.kFavoriteView),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning ☀️';
    if (hour < 17) return 'Good afternoon 🌤️';
    return 'Good evening 🌙';
  }
}

// ─────────────────────────────────────────────────────
// On This Day Banner
// ─────────────────────────────────────────────────────
class _OnThisDayBanner extends StatelessWidget {
  const _OnThisDayBanner();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeSuccess) {
          return const SliverToBoxAdapter(child: SizedBox());
        }

        final today = DateTime.now();
        final onThisDay = state.memories.where((m) {
          return m.time.day == today.day &&
              m.time.month == today.month &&
              m.time.year != today.year;
        }).toList();

        if (onThisDay.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox());
        }

        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.lavender, AppColors.softPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text('✨', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'On This Day',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        Text(
                          '${onThisDay.length} memor${onThisDay.length == 1 ? 'y' : 'ies'} from the past',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
