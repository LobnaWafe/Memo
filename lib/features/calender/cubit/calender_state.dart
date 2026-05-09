import 'package:memo/shared/data/memory_model.dart';

sealed class CalenderState {
  const CalenderState();
}

final class CalenderInitial extends CalenderState {
  const CalenderInitial();
}

final class CalenderLoaded extends CalenderState {
  final Map<DateTime, List<MemoryModel>> grouped;

  const CalenderLoaded({required this.grouped});
}
