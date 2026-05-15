import 'package:flutter/material.dart';
import 'package:memo/core/app_colors.dart'; // ✅ علشان نجيب accentPurple من هنا
import 'package:memo/features/gallery/presentation/widgets/gallery_view_body.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      // AppBar فوق
      appBar: AppBar(

        title: Text(
          'Gallery',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.accentPurple, // ✅ اللون هنا
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.creamWhite, 
        elevation: 0,
      ),

      // الجاليري
      body: const GalleryViewBody(),
    );
  }
}
