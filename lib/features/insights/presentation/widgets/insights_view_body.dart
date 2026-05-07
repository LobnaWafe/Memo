import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class InsightsViewBody extends StatefulWidget {
  const InsightsViewBody({super.key});

  @override
  State<InsightsViewBody> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsViewBody> {
  // ✅ بيانات تجريبية
  final List<Map<String, dynamic>> memories = [
    {
      "date": DateTime.now(),
      "isFavorite": true,
      "hasImage": true,
      "mood": "Happy",
      "text": "Great day!",
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "isFavorite": false,
      "hasImage": false,
      "mood": "Sad",
      "text": "Stressful",
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "isFavorite": true,
      "hasImage": true,
      "mood": "Calm",
      "text": "Relaxing",
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "isFavorite": true,
      "hasImage": true,
      "mood": "Calm",
      "text": "Relaxing",
    },
  ];

  Map<String, int> get moodDistribution {
    final Map<String, int> dist = {};
    for (var m in memories) {
      String mood = m["mood"];
      dist[mood] = (dist[mood] ?? 0) + 1;
    }
    return dist;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalCount = memories.length;
    final favoritesCount = memories
        .where((m) => m["isFavorite"] == true)
        .length;
    final withImagesCount = memories.where((m) => m["hasImage"] == true).length;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Your Journey', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        const Text(
          'A look into your memories',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),

        // ✅ بطاقات الإحصائيات بشكل مبسط
        Row(
          children: [
            _buildExpandedStat(
              '$totalCount',
              'Memories',
              '📝',
              Colors.purple.shade50,
            ),
            const SizedBox(width: 10),
            _buildExpandedStat(
              '$favoritesCount',
              'Favorites',
              '❤️',
              Colors.pink.shade50,
            ),
            const SizedBox(width: 10),
            _buildExpandedStat(
              '$withImagesCount',
              'Photos',
              '📸',
              Colors.teal.shade50,
            ),
          ],
        ),

        const SizedBox(height: 28),

        // ✅ توزيع الحالة المزاجية
        _MoodDistributionCard(distribution: moodDistribution, isDark: isDark),

        const SizedBox(height: 20),

        const SizedBox(height: 20),

        _OnThisDayCard(memories: memories),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildExpandedStat(
    String value,
    String label,
    String emoji,
    Color bgColor,
  ) {
    return Expanded(
      child: _StatCard(
        value: value,
        label: label,
        emoji: emoji,
        color: bgColor,
      ),
    );
  }
}

// --- الـ Widgets الفرعية ---

class _StatCard extends StatelessWidget {
  final String value, label, emoji;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MoodDistributionCard extends StatefulWidget {
  final Map<String, int> distribution;
  final bool isDark;

  const _MoodDistributionCard({
    required this.distribution,
    required this.isDark,
  });

  @override
  State<_MoodDistributionCard> createState() => _MoodDistributionCardState();
}

class _MoodDistributionCardState extends State<_MoodDistributionCard> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.distribution.values.fold(0, (sum, v) => sum + v);
    final sortedEntries = widget.distribution.entries.toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🧠 Mood Distribution',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                    sections: sortedEntries.asMap().entries.map((e) {
                      final isTouched = e.key == _touchedIndex;
                      return PieChartSectionData(
                        color: _getColor(e.value.key),
                        value: e.value.value.toDouble(),
                        radius: isTouched ? 50 : 40,
                        title: isTouched
                            ? '${(e.value.value / total * 100).round()}%'
                            : '',
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: sortedEntries
                      .map((e) => _buildLegend(e.key, e.value, total))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String mood, int count, int total) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: _getColor(mood)),
          const SizedBox(width: 8),
          Text(mood, style: const TextStyle(fontSize: 12)),
          const Spacer(),
          Text(
            '${(count / total * 100).round()}%',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Color _getColor(String mood) {
    switch (mood) {
      case 'Happy':
        return const Color(0xFFFFD93D); // أصفر
      case 'Sad':
        return const Color(0xFF6495ED); // أزرق هادي
      case 'Calm':
        return const Color(0xFF98FB98); // أخضر نعناعي
      case 'Excited':
        return const Color(0xFFFF6B6B); // أحمر مرجاني
      case 'Angry':
        return const Color(0xFFC0392B); // أحمر داكن
      case 'Anxious':
        return const Color(0xFF95A5A6); // رمادي
      case 'Grateful':
        return const Color(0xFFF3A683); // برتقالي خوخي
      case 'Productive':
        return const Color(0xFF4BC0C0); // تركواز
      case 'Tired':
        return const Color(0xFF574B90); // بنفسجي غامق
      case 'Loved':
        return const Color(0xFFFF85A1); // وردي
      default:
        return const Color(0xFFA29BFE); // بنفسجي فاتح افتراضي
    }
  }
}

class _OnThisDayCard extends StatelessWidget {
  final List memories;
  const _OnThisDayCard({required this.memories});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade300, Colors.purple.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "✨ On this day: ${memories.length} memories captured.",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
