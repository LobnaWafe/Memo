import 'package:memo/shared/data/memory_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<MemoryModel> memories;
  HomeSuccess(this.memories);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
