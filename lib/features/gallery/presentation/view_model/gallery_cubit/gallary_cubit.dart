import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo/features/gallery/presentation/view_model/gallery_cubit/gallary_state.dart';
import 'package:memo/shared/repo/memory_repo_imp.dart';

class GalleryCubit extends Cubit<GalleryState> {

  GalleryCubit() : super(GalleryInitial());

  final MemoryRepoImpl repo = MemoryRepoImpl();

  void getGalleryImages() {

    try {

      emit(GalleryLoading());

      final memories = repo
          .getMemories()
          .where((e) => e.imagePath != null)
          .toList();

      emit(GallerySuccess(memories));

    } catch (e) {

      emit(
        GalleryError(e.toString()),
      );
    }
  }
}