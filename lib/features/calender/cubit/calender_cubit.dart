import 'package:bloc/bloc.dart';
import 'package:memo/features/calender/cubit/calender_state.dart';
import 'package:memo/shared/repo/memory_repo_imp.dart';
import 'package:meta/meta.dart';
import 'package:memo/shared/data/memory_model.dart';

class CalenderCubit extends Cubit<CalenderState> {
  final MemoryRepoImpl _repo;

  CalenderCubit({MemoryRepoImpl? repo})
    : _repo = repo ?? MemoryRepoImpl(),
      super(CalenderInitial());

  /// استدعيها عند فتح الشاشة لتحميل الذكريات من Hive
  void loadMemories() {
    final memories = _repo.getMemories();
    final grouped = _buildGrouped(memories);
    emit(CalenderLoaded(grouped: grouped));
  }

  /// بعد أي عملية إضافة / حذف / تعديل خارجية، أعد التحميل
  void refresh() => loadMemories();

  Map<DateTime, List<MemoryModel>> _buildGrouped(List<MemoryModel> memories) {
    final map = <DateTime, List<MemoryModel>>{};
    for (final m in memories) {
      final key = DateTime(m.time.year, m.time.month, m.time.day);
      map.putIfAbsent(key, () => []).add(m);
    }
    return map;
  }
}
