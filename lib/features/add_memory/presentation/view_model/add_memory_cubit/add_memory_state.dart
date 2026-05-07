part of 'add_memory_cubit.dart';

abstract class AddMemoryState {}

class AddMemoryInitial extends AddMemoryState {}

class AddMemoryLoading extends AddMemoryState {}

class AddMemorySuccess extends AddMemoryState {}

class AddMemoryFailure extends AddMemoryState {
  final String errorMessage;

  AddMemoryFailure({
    required this.errorMessage,
  });
}

class AddMemoryTagsUpdated extends AddMemoryState {}