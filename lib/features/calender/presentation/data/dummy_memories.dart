import 'package:memo/shared/data/memory_model.dart';

Map<DateTime, List<MemoryModel>> buildGrouped() {
  final allMemories = [
    MemoryModel(
      id: '1',
      feelingName: 'Morning walk in the park',
      description: 'The air was fresh and birds were singing beautifully...',
      time: DateTime(2025, 5, 7),
      isFav: true,
    ),
    MemoryModel(
      id: '2',
      feelingName: 'Coffee with an old friend',
      description: 'We talked for hours about old times and laughed a lot...',
      time: DateTime(2025, 5, 5),
      isFav: false,
    ),
    MemoryModel(
      id: '3',
      feelingName: 'Sunset at the rooftop',
      description: 'Golden hour never looked so perfect from up there...',
      time: DateTime(2025, 5, 5),
      isFav: true,
    ),
    MemoryModel(
      id: '4',
      feelingName: 'Finished my book',
      description:
          'What an ending! Totally unexpected twist at the last page...',
      time: DateTime(2025, 5, 2),
      isFav: true,
    ),
    MemoryModel(
      id: '5',
      feelingName: 'Rainy afternoon',
      description: 'Stayed home, watched movies all day long with hot cocoa...',
      time: DateTime(2025, 4, 20),
      isFav: false,
    ),
    MemoryModel(
      id: '6',
      feelingName: 'Family dinner',
      description:
          'Mom cooked her famous recipe. The whole family was there...',
      time: DateTime(2025, 4, 15),
      isFav: false,
    ),
  ];

  final map = <DateTime, List<MemoryModel>>{};
  for (final m in allMemories) {
    final key = DateTime(m.time.year, m.time.month, m.time.day);
    map.putIfAbsent(key, () => []).add(m);
  }
  return map;
}
