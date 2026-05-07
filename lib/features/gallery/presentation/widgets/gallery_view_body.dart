import 'package:flutter/material.dart';

class GalleryViewBody extends StatelessWidget {
  const GalleryViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column();
  }
}


// class GalleryViewBody extends StatelessWidget {
//   GalleryViewBody({super.key});

//   // بيانات وهمية للتجربة فقط
//   final List<String> images = [
//     'assets/images/image1.jpg',
//     'assets/images/image1.jpg',
//     'assets/images/image1.jpg',
//     'assets/images/image1.jpg',
//     'assets/images/image1.jpg',
//   ];

//   final List<String> moods = [
//     '😊',
//     '🥰',
//     '😌',
//     '😢',
//     '🥳',
//     '😴',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(6),
//       child: MasonryGridView.count(
//         crossAxisCount: 3, // عدد الأعمدة
//         mainAxisSpacing: 4,
//         crossAxisSpacing: 4,

//         itemCount: images.length,

//         itemBuilder: (context, index) {
//           return GalleryItem(
//             imagePath: images[index],
//             mood: moods[index],
//             index: index,
//           );
//         },
//       ),
//     );
//   }
// }

// class GalleryItem extends StatelessWidget {
//   final String imagePath;
//   final String mood;
//   final int index;

//   const GalleryItem({
//     super.key,
//     required this.imagePath,
//     required this.mood,
//     required this.index,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // علشان بعض الصور تبقى أطول من غيرها
//     bool isLarge = index % 2 == 0;

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: AspectRatio(
//         aspectRatio: isLarge ? 0.7 : 1,
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             // الصورة
//             Image.asset(
//               imagePath,
//               fit: BoxFit.cover,
//             ),

//             // الإيموجي تحت
//             Positioned(
//               bottom: 5,
//               right: 5,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 6,
//                   vertical: 3,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.black45,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   mood,
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
