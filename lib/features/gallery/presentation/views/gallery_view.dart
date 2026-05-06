import 'package:flutter/material.dart';
import 'package:memo/features/gallery/presentation/widgets/gallery_view_body.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: GalleryViewBody()),
    );
  }
}