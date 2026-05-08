import 'package:memo/shared/data/memory_model.dart';

abstract class GalleryState {}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GallerySuccess extends GalleryState {

  final List<MemoryModel> memories;

  GallerySuccess(this.memories);
}

class GalleryError extends GalleryState {

  final String message;

  GalleryError(this.message);
}