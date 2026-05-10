import 'package:bloc/bloc.dart';
import 'package:memo/shared/data/memory_model.dart';
import 'package:memo/shared/repo/memory_repo_imp.dart';
import 'package:meta/meta.dart';

part 'insights_state.dart';

class InsightsCubit extends Cubit<InsightsState> {
  InsightsCubit() : super(InsightsInitial());
  
  final MemoryRepoImpl repo = MemoryRepoImpl();

  void getMemories() {
    try {
      emit(InsightsLoading());
      final memories = repo.getMemories();
      //memories.sort((a, b) => b.time.compareTo(a.time));
      emit(InsightsSuccess(memoryModel:memories));
    } catch (e) {
      emit(InsightsFailure(errMsg:e.toString()));
    }
  }
}
