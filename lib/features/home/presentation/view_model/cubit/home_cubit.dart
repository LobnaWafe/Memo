import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo/shared/data/memory_model.dart';
import 'package:memo/shared/repo/memory_repo_imp.dart';

part 'home_state.dart';

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
}
