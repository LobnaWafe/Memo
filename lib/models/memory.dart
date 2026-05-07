class Memory {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String emoji;
  final bool isFavorite;

  const Memory({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.emoji,
    this.isFavorite = false,
  });
}
