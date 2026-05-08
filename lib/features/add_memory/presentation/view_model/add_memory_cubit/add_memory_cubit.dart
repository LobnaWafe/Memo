import 'package:bloc/bloc.dart';
import 'package:memo/shared/data/memory_model.dart';
import 'package:memo/shared/repo/memory_repo.dart';
import 'package:uuid/uuid.dart';

part 'add_memory_state.dart';

class AddMemoryCubit extends Cubit<AddMemoryState> {
  AddMemoryCubit(this.memoryRepo)
      : super(AddMemoryInitial());

  final MemoryRepo memoryRepo;

  final List<String> tags = [];

  final Uuid _uuid = const Uuid();

  Future<void> addMemory({
    required String feelingName,
    required String description,
    required DateTime time,
    String? imagePath,
  }) async {
    emit(AddMemoryLoading());

    try {
      final memory = MemoryModel(
        id: _uuid.v4(), 
        feelingName: feelingName,
        description: description,
        time: time,
        imagePath: imagePath,
        tags: List.from(tags),
        isFav: false,
      );

      await memoryRepo.addMemory(memory);

      clearTags();

      emit(AddMemorySuccess());

    } catch (e) {
      emit(AddMemoryFailure(
        errorMessage: e.toString(),
      ));
    }
  }

  void addTag(String tag) {
    final trimmed = tag.trim();

    if (trimmed.isNotEmpty && !tags.contains(trimmed)) {
      tags.add(trimmed);
      emit(AddMemoryTagsUpdated());
    }
  }

  void removeTag(String tag) {
    tags.remove(tag);
    emit(AddMemoryTagsUpdated());
  }

  void clearTags() {
    tags.clear();
    emit(AddMemoryTagsUpdated());
  }
}