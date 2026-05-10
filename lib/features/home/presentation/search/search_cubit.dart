import 'package:bloc/bloc.dart';
import 'package:memo/features/home/presentation/search/search_state.dart';
import 'package:memo/shared/data/memory_model.dart';
import 'package:memo/shared/repo/memory_repo_imp.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  final MemoryRepoImpl _repo = MemoryRepoImpl();
  List<MemoryModel> _allMemories = [];

  void init() {
    _allMemories = _repo.getMemories()
      ..sort((a, b) => b.time.compareTo(a.time));
  }

  void search(String query) {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    final q = query.toLowerCase().trim();
    final results = _allMemories.where((m) {
      return m.feelingName.toLowerCase().contains(q) ||
          m.description.toLowerCase().contains(q) ||
          (m.tags?.any((t) => t.toLowerCase().contains(q)) ?? false);
    }).toList();

    emit(SearchSuccess(results: results, query: query));
  }

  void clear() => emit(SearchInitial());
}
