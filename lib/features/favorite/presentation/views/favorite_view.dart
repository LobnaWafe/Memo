import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:memo/core/app_colors.dart';
import 'package:memo/features/favorite/presentation/view_model/cubit/favorite_cubit.dart';
import 'package:memo/features/favorite/presentation/view_model/cubit/favorite_state.dart';
import 'package:memo/features/favorite/presentation/widgets/favorite_card.dart';
import 'package:memo/features/home/presentation/widgets/memory_card.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoritesCubit()..loadFavorites(),
      child: const _FavoritesBody(),
    );
  }
}

class _FavoritesBody extends StatelessWidget {
  const _FavoritesBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      appBar: AppBar(
        backgroundColor: AppColors.creamWhite,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Favorites',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.accentPurple, // ✅ اللون هنا
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.accentPurple),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentPurple),
            );
          }

          if (state is FavoritesError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: AppColors.accentPurple),
              ),
            );
          }

          if (state is FavoritesSuccess) {
            if (state.memories.isEmpty) {
              return const Center(
                child: Text(
                  "No favorites yet 💔",
                  style: TextStyle(color: AppColors.accentPurple),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.memories.length,
              itemBuilder: (context, i) {
                final memory = state.memories[i];
                return FavCard(memory: memory);
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
