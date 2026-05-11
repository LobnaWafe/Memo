import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/features/insights/presentation/view_model/cubit/insights_cubit.dart';
import 'package:memo/features/insights/presentation/widgets/on_this_day_card.dart';
import 'package:memo/shared/data/memory_model.dart';

class InsightsViewBody extends StatefulWidget {
  const InsightsViewBody({super.key});

  @override
  State<InsightsViewBody> createState() => _InsightsViewBodyState();
}

class _InsightsViewBodyState extends State<InsightsViewBody> {
  @override
  void initState() {
    super.initState();
    context.read<InsightsCubit>().getMemories();
  }

  Map<String, int> getMoodDistribution(List<MemoryModel> memories) {
    final Map<String, int> dist = {};
    for (var memory in memories) {
      final mood = memory.feelingName;
      dist[mood] = (dist[mood] ?? 0) + 1;
    }
    return dist;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsightsCubit, InsightsState>(
      builder: (context, state) {
        if (state is InsightsLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accentPurple),
          );
        }

        if (state is InsightsFailure) {
          return Center(
            child: Text(
              state.errMsg,
              style: const TextStyle(color: AppColors.accentPurple),
            ),
          );
        }

        if (state is InsightsSuccess) {
          final memories = state.memoryModel;
          final totalCount = memories.length;
          final favoritesCount = memories.where((m) => m.isFav).length;
          final withImagesCount = memories
              .where((m) => m.imagePath != null)
              .length;
          final moodDistribution = getMoodDistribution(memories);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Your Journey',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.accentPurple,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'A look into your memories',
                style: TextStyle(color: AppColors.accentPurple),
              ),
              const SizedBox(height: 24),
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
              _MoodDistributionCard(distribution: moodDistribution),
              const SizedBox(height: 20),
              OnThisDayCard(memories: memories),
              const SizedBox(height: 40),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildExpandedStat(
    String value,
    String label,
    String emoji,
    Color bgColor,
  ) {
    return Expanded(
      child: StatCard(value: value, label: label, emoji: emoji, color: bgColor),
    );
  }
}

class StatCard extends StatelessWidget {
  final String value, label, emoji;
  final Color color;

  const StatCard({
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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.accentPurple, // ✅ اللون هنا
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.accentPurple, // ✅ اللون هنا
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MoodDistributionCard extends StatefulWidget {
  final Map<String, int> distribution;

  const _MoodDistributionCard({required this.distribution});

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
        color: Colors.white,
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
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              response == null ||
                              response.touchedSection == null) {
                            _touchedIndex = -1;
                            return;
                          }

                          _touchedIndex =
                              response.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
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
