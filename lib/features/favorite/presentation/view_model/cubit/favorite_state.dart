// part of 'favorite_cubit.dart';


// abstract class FavoritesState {}

// class FavoritesInitial extends FavoritesState {}

// class FavoritesLoading extends FavoritesState {}

// class FavoritesSuccess extends FavoritesState {
//   final List<MemoryModel> memories;

//   FavoritesSuccess(this.memories);
// }

// class FavoritesError extends FavoritesState {
//   final String message;

//   FavoritesError(this.message);
// }


import 'package:equatable/equatable.dart';
import 'package:memo/shared/data/memory_model.dart'; 

abstract class FavoritesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesSuccess extends FavoritesState {
  final List<MemoryModel> memories;

  FavoritesSuccess(this.memories);

 @override
  List<Object?> get props => [memories, memories.length, DateTime.now()];
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}