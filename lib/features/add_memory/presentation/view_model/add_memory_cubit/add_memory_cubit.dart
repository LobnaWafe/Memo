import 'package:bloc/bloc.dart';
import 'package:memo/shared/data/memory_model.dart';
import 'package:memo/shared/repo/memory_repo.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'add_memory_state.dart';

class AddMemoryCubit extends Cubit<AddMemoryState> {
  AddMemoryCubit(this.memoryRepo) : super(AddMemoryInitial());

  final MemoryRepo memoryRepo;

  Future<void> addMemory({
    required String feelingName,
    required String description,
    required DateTime time,
    String? imagePath,
    List<String>? tags,
  }) async {

    emit(AddMemoryLoading());

    try {

      final memory = MemoryModel(
        id: const Uuid().v4(),
        feelingName: feelingName,
        description: description,
        time: time,
        imagePath: imagePath,
        tags: tags,
        isFav: false,
      );

      await memoryRepo.addMemory(memory);

      emit(AddMemorySuccess());

    } catch (e) {

      emit(
        AddMemoryFailure(
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

