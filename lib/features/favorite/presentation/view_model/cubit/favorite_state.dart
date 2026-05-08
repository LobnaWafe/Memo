part of 'favorite_cubit.dart';


abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesSuccess extends FavoritesState {
  final List<MemoryModel> memories;

  FavoritesSuccess(this.memories);
}

class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError(this.message);
}