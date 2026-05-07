import 'package:memo/models/memory.dart';

Map<DateTime, List<Memory>> buildGrouped() {
  final allMemories = [
    Memory(
      id: '1',
      title: 'Morning walk in the park',
      content: 'The air was fresh and birds were singing beautifully...',
      date: DateTime(2025, 5, 7),
      emoji: '🌿',
      isFavorite: true,
    ),
    Memory(
      id: '2',
      title: 'Coffee with an old friend',
      content: 'We talked for hours about old times and laughed a lot...',
      date: DateTime(2025, 5, 5),
      emoji: '☕',
    ),
    Memory(
      id: '3',
      title: 'Sunset at the rooftop',
      content: 'Golden hour never looked so perfect from up there...',
      date: DateTime(2025, 5, 5),
      emoji: '🌅',
      isFavorite: true,
    ),
    Memory(
      id: '4',
      title: 'Finished my book',
      content: 'What an ending! Totally unexpected twist at the last page...',
      date: DateTime(2025, 5, 2),
      emoji: '📚',
      isFavorite: true,
    ),
    Memory(
      id: '5',
      title: 'Rainy afternoon',
      content: 'Stayed home, watched movies all day long with hot cocoa...',
      date: DateTime(2025, 4, 20),
      emoji: '🌧️',
    ),
    Memory(
      id: '6',
      title: 'Family dinner',
      content: 'Mom cooked her famous recipe. The whole family was there...',
      date: DateTime(2025, 4, 15),
      emoji: '🍽️',
    ),
  ];

  final map = <DateTime, List<Memory>>{};
  for (final m in allMemories) {
    final key = DateTime(m.date.year, m.date.month, m.date.day);
    map.putIfAbsent(key, () => []).add(m);
  }
  return map;
}
