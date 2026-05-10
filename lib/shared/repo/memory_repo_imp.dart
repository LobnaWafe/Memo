import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:memo/shared/data/memory_model.dart';

import 'memory_repo.dart';

class MemoryRepoImpl implements MemoryRepo {

  final Box<MemoryModel> box =
      Hive.box<MemoryModel>('memories');

  @override
  Future<void> addMemory(MemoryModel memory) async {
    try {

      await box.add(memory);

    } catch (e) {

      throw Exception(
        'Failed to add memory: $e',
      );
    }
  }

  @override
  Future<void> deleteMemory(String id) async {

    try {

      final index = box.values.toList()
          .indexWhere((e) => e.id == id);

      if (index == -1) {
        throw Exception('Memory not found');
      }

      final memory = box.getAt(index);

      // delete image if exists
      if (memory?.imagePath != null) {

        final file =
            File(memory!.imagePath!);

        if (await file.exists()) {
          await file.delete();
        }
      }

      await box.deleteAt(index);

    } catch (e) {

      throw Exception(
        'Failed to delete memory: $e',
      );
    }
  }

  @override
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

      final index = box.values.toList()
          .indexWhere((e) => e.id == id);

      if (index == -1) {
        throw Exception('Memory not found');
      }

      final oldMemory = box.getAt(index)!;

      if (imagePath != null &&
          oldMemory.imagePath != null &&
          imagePath != oldMemory.imagePath) {

        final oldImage =
            File(oldMemory.imagePath!);

        if (await oldImage.exists()) {
          await oldImage.delete();
        }
      }

      final updatedMemory = MemoryModel(

        id: oldMemory.id,

        feelingName:
            feelingName ??
            oldMemory.feelingName,

        description:
            description ??
            oldMemory.description,

        time:
            time ??
            oldMemory.time,

        imagePath:
            imagePath ??
            oldMemory.imagePath,

        tags:
            tags ??
            oldMemory.tags,

        isFav:
            isFav ??
            oldMemory.isFav,
      );

      await box.putAt(
        index,
        updatedMemory,
      );

    } catch (e) {

      throw Exception(
        'Failed to edit memory: $e',
      );
    }
  }

  @override
  Future<void> addFavMemory(String id) async {

    try {

      await editMemory(
        id: id,
        isFav: true,
      );

    } catch (e) {

      throw Exception(
        'Failed to add memory to favorites: $e',
      );
    }
  }

  @override
  Future<void> removeFavMemory(String id) async {

    try {

      await editMemory(
        id: id,
        isFav: false,
      );

    } catch (e) {

      throw Exception(
        'Failed to remove memory from favorites: $e',
      );
    }
  }

  @override
  List<MemoryModel> getMemories() {

    try {

      return box.values.toList();

    } catch (e) {

      throw Exception(
        'Failed to get memories: $e',
      );
    }
  }
}