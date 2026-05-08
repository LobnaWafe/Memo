import 'package:memo/shared/data/memory_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchSuccess extends SearchState {
  final List<MemoryModel> results;
  final String query;
  SearchSuccess({required this.results, required this.query});
}
