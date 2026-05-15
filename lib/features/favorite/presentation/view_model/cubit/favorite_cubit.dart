// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:memo/shared/data/memory_model.dart';
// import 'package:memo/shared/repo/memory_repo_imp.dart';

// part 'favorite_state.dart';

// class FavoritesCubit extends Cubit<FavoritesState> {
//   FavoritesCubit() : super(FavoritesInitial());

//   final MemoryRepoImpl repo = MemoryRepoImpl();

//   void loadFavorites() {
//     try {
//       emit(FavoritesLoading());

//       final all = repo.getMemories();

//       final favs =
//           all.where((e) => e.isFav == true).toList();

//       emit(FavoritesSuccess(favs));
//     } catch (e) {
//       emit(FavoritesError(e.toString()));
//     }
//   }

//   Future<void> toggleFavorite(MemoryModel memory) async {
//     try {
//       final updated = MemoryModel(
//         id: memory.id,
//         feelingName: memory.feelingName,
//         description: memory.description,
//         time: memory.time,
//         imagePath: memory.imagePath,
//         tags: memory.tags,
//         isFav: !memory.isFav,
//       );

//       final index =
//           repo.box.values.toList().indexWhere(
//                 (e) => e.id == memory.id,
//               );

//       await repo.box.putAt(index, updated);

//       loadFavorites();
//     } catch (e) {
//       emit(FavoritesError(e.toString()));
//     }
//   }
// }




import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo/features/favorite/presentation/view_model/cubit/favorite_state.dart';
import 'package:memo/shared/data/memory_model.dart';
import 'package:memo/shared/repo/memory_repo_imp.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial());

  final MemoryRepoImpl repo = MemoryRepoImpl();

  void loadFavorites() {
    try {
      emit(FavoritesLoading());
      final all = repo.getMemories();
      
      // عمل نسخة جديدة من القائمة باستخدام toList() 
      final favs = all.where((e) => e.isFav == true).toList();

      emit(FavoritesSuccess(favs));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> toggleFavorite(MemoryModel memory) async {
    try {
      // تعديل الحالة في الداتابيز
      final updated = memory.copyWith(isFav: !memory.isFav); 
      // ملحوظة: يفضل استخدام copyWith لو الموديل بيدعمها لتقليل الكود

      final index = repo.box.values.toList().indexWhere(
            (e) => e.id == memory.id,
          );

      if (index != -1) {
        await repo.box.putAt(index, updated);
        loadFavorites(); // دي هتعمل emit لـ Success جديد
      }
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}