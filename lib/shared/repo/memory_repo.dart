import 'package:memo/shared/data/memory_model.dart';

abstract class MemoryRepo {

  Future<void> addMemory(MemoryModel memory);

  Future<void> deleteMemory(String id);


  Future<void> editMemory({
    required String id,
    String? feelingName,
    String? description,
    DateTime? time,
    String? imagePath,
    List<String>? tags,
    bool? isFav,
  });


  Future<void> addFavMemory(String id);

  Future<void> removeFavMemory(String id);

  List<MemoryModel> getMemories();
}