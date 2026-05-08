import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:memo/features/gallery/presentation/view_model/gallery_cubit/gallary_cubit.dart';
import 'package:memo/features/gallery/presentation/view_model/gallery_cubit/gallary_state.dart';


import 'gallery_item.dart';

class GalleryViewBody extends StatelessWidget {

  const GalleryViewBody({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(

      create: (context) =>
          GalleryCubit()..getGalleryImages(),

      child: BlocBuilder<GalleryCubit, GalleryState>(

        builder: (context, state) {

          if (state is GalleryLoading) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GalleryError) {

            return Center(
              child: Text(state.message),
            );
          }

          if (state is GallerySuccess) {

            if (state.memories.isEmpty) {

              return const Center(
                child: Text(
                  'No memories with images yet 📸',
                ),
              );
            }

            return Padding(

              padding: const EdgeInsets.all(8),

              child: MasonryGridView.count(

                crossAxisCount: 3,

                mainAxisSpacing: 6,
                crossAxisSpacing: 6,

                itemCount: state.memories.length,

                itemBuilder: (context, index) {

                  return GalleryItem(
                    memory: state.memories[index],
                    index: index,
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}