import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo/features/home/presentation/view_model/cubit/home_state.dart';
import 'package:memo/shared/data/memory_model.dart';
import 'package:memo/shared/repo/memory_repo_imp.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final MemoryRepoImpl repo = MemoryRepoImpl();

  void getMemories() {
    try {
      emit(HomeLoading());
      final memories = repo.getMemories();
      memories.sort((a, b) => b.time.compareTo(a.time));
      emit(HomeSuccess(memories));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void toggleFav(String id, bool currentIsFav) async {
    try {
      if (currentIsFav) {
        await repo.removeFavMemory(id);
      } else {
        await repo.addFavMemory(id);
      }
      getMemories(); // refresh
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void deleteMemory(String id) async {
    try {
      await repo.deleteMemory(id);
      getMemories(); // refresh
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> editMemory({
    required String id,
    String? feelingName,
    String? description,
    DateTime? time,
    String? imagePath,
    List<String>? tags,
    bool? isFav,
  }) async {
    try {
      await repo.editMemory(
        id: id,
        feelingName: feelingName,
        description: description,
        time: time,
        imagePath: imagePath,
        tags: tags,
        isFav: isFav,
      );
      getMemories(); // refresh
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
