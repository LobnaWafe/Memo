import 'package:hive/hive.dart';

part 'memory_model.g.dart';

@HiveType(typeId: 1)
class MemoryModel extends HiveObject {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String feelingName;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime time;

  @HiveField(4)
  final String? imagePath;

  @HiveField(5)
  final bool isFav;

  @HiveField(6)
  final List<String>? tags;

  MemoryModel({
    required this.id,
    required this.feelingName,
    required this.description,
    required this.time,
    this.imagePath,
    this.tags, 
    required this.isFav,
  });
  MemoryModel copyWith({
  String? id,
  String? feelingName,
  String? description,
  DateTime? time,
  String? imagePath,
  List<String>? tags,
  bool? isFav,
}) {
  return MemoryModel(
    id: id ?? this.id,
    feelingName: feelingName ?? this.feelingName,
    description: description ?? this.description,
    time: time ?? this.time,
    imagePath: imagePath ?? this.imagePath,
    tags: tags ?? this.tags,
    isFav: isFav ?? this.isFav,
  );
}

}