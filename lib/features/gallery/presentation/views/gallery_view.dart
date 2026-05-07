import 'package:flutter/material.dart';
import 'package:memory_journal/features/gallery/gallery_view_body.dart';

class GalleryScreen extends StatelessWidget {
  GalleryScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //: const Color(0xffFAF7F2),

      // AppBar فوق
      appBar: AppBar(
        title: const Text('Gallery'),
        centerTitle: true,
      ),

      // الجاليري
      body: GalleryViewBody()
    );
  }
}