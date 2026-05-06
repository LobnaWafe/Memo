import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memo/constants.dart';

class AddMemoryViewBody extends StatefulWidget {
  const AddMemoryViewBody({super.key});

  @override
  State<AddMemoryViewBody> createState() => _AddMemoryViewBodyState();
}

class _AddMemoryViewBodyState extends State<AddMemoryViewBody> {
  DateTime selectedDate = DateTime.now();
  String selectedMood = "Happy";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const creamWhite = Color(0xFFFFFBFA); // لون الخلفية الكريمي من الصورة
    const accentPurple = Color(0xFF9F7BF6); // البنفسجي الأساسي

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ الـ Date Selector (على شكل Button)
          _DateSelector(
            date: selectedDate,

            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) => Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(primary: accentPurple),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) setState(() => selectedDate = picked);
            },
          ),

          const SizedBox(height: 28),

          // ✅Mood (إيموجي زاهية وحدود ملونة عند الاختيار)
          const _SectionLabel(label: 'How are you feeling?'),
          const SizedBox(height: 16),
          _MoodSelector(
            moods: moods,
            selectedMood: selectedMood,
            accentColor: accentPurple,
            onMoodSelected: (label) => setState(() => selectedMood = label),
          ),

          const SizedBox(height: 32),

          // ✅ Photo (Camera/Gallery بأيقونات كبيرة)
          const _SectionLabel(label: 'Add a photo'),
          const SizedBox(height: 16),
          const _ImageSection(),

          const SizedBox(height: 32),

          // ✅ Text Field (Filled white مع hint text)
          const _SectionLabel(label: 'Your memory'),
          const SizedBox(height: 16),
          TextFormField(
            maxLines: 5,
            style: const TextStyle(fontSize: 15),
            decoration: _inputDecoration(
              hint:
                  'Write about this moment... What did you feel? What made it special?',
              isDark: isDark,
            ),
          ),

          const SizedBox(height: 32),

          // ✅ Tags Section (Optional مع زر الزائد)
          const _SectionLabel(label: 'Tags (optional)'),
          const SizedBox(height: 16),
          _TagSection(isDark: isDark, accentColor: accentPurple),

          const SizedBox(height: 48),

          // ✅ Save/Cancel Buttons
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: accentPurple,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Save Memory',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

        

          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ✅ ستايل حقول الإدخال المشترك
  InputDecoration _inputDecoration({
    required String hint,
    required bool isDark,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      fillColor: isDark ? Colors.grey[900] : Colors.white, // أبيض من الصورة
      filled: true,
      contentPadding: const EdgeInsets.all(20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFF9F7BF6), width: 1.5),
      ),
    );
  }
}

// --- Widgets المساعدة مطابقة للتصميم ---

class _DateSelector extends StatelessWidget {
  final DateTime date;

  final VoidCallback onTap;

  const _DateSelector({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              color: Color(0xFF9F7BF6),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              DateFormat('EEEE, MMM d, yyyy').format(date),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodSelector extends StatelessWidget {
  final List<Map<String, String>> moods;
  final String selectedMood;
  final Color accentColor;
  final Function(String) onMoodSelected;

  const _MoodSelector({
    required this.moods,
    required this.selectedMood,
    required this.accentColor,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: moods.length,
        itemBuilder: (context, index) {
          final mood = moods[index];
          final isSelected = mood['label'] == selectedMood;

          return GestureDetector(
            onTap: () => onMoodSelected(mood['label']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 12),
              width: 75,
              decoration: BoxDecoration(
                color: isSelected
                    ? accentColor.withOpacity(0.1)
                    : Colors.white, // خلفية خفيفة عند الاختيار
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? accentColor
                      : Colors.grey.withOpacity(0.2), // حدود ملونة
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(mood['emoji']!, style: const TextStyle(fontSize: 30)),
                  const SizedBox(height: 6),
                  Text(
                    mood['label']!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected ? accentColor : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection();

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFF9F7BF6);
    return Row(
      children: [
        _ImageButton(
          icon: Icons.camera_alt_rounded,
          label: 'Camera',
          iconColor: iconColor,
        ),
        const SizedBox(width: 16),
        _ImageButton(
          icon: Icons.photo_library_rounded,
          label: 'Gallery',
          iconColor: iconColor,
        ),
      ],
    );
  }
}

class _ImageButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _ImageButton({
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagSection extends StatelessWidget {
  final bool isDark;
  final Color accentColor;
  const _TagSection({required this.isDark, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // حقل التاجز
        Expanded(
          child: TextFormField(
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Add a tag (e.g., travel, family)',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              fillColor: isDark ? Colors.grey[900] : Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: accentColor, width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // زر الإضافة البنفسجي
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFF6E717F),
        letterSpacing: 0.3,
      ),
    );
  }
}
