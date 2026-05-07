part of 'add_memory_cubit.dart';

@immutable
sealed class AddMemoryState {}

final class AddMemoryInitial extends AddMemoryState {}

final class AddMemoryLoading extends AddMemoryState {}

final class AddMemorySuccess extends AddMemoryState {}

final class AddMemoryFailure extends AddMemoryState {

  final String errorMessage;

  AddMemoryFailure({
    required this.errorMessage,
  });
}