import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ImageSection extends StatefulWidget {
  final Function(String path) onImagePicked;

  const ImageSection({
    super.key,
    required this.onImagePicked,
  });

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
 
  String? _selectedImagePath;

  Future<void> _pickImage(
    ImageSource source,
    BuildContext context,
  ) async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() {
        _selectedImagePath = picked.path;
      });
      widget.onImagePicked(picked.path); 
    }
  }

 
  void _removeImage() {
    setState(() {
      _selectedImagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFF9F7BF6);

  
    if (_selectedImagePath == null) {
      return Row(
        children: [
          Expanded(
            child: ImageButton(
              icon: Icons.camera_alt_rounded,
              label: 'Camera',
              iconColor: iconColor,
              onTap: () => _pickImage(ImageSource.camera, context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ImageButton(
              icon: Icons.photo_library_rounded,
              label: 'Gallery',
              iconColor: iconColor,
              onTap: () => _pickImage(ImageSource.gallery, context),
            ),
          ),
        ],
      );
    } else {
      // لو فيه صورة، اعرض الصورة مكان الـ Row
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            height: 160, // تقدري تتحكمي في الطول زي ما تحبي
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: FileImage(File(_selectedImagePath!)),
                fit: BoxFit.cover,
              ),
            ),
          ),
         
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: _removeImage,
              child: const CircleAvatar(
                backgroundColor: Colors.redAccent,
                radius: 15,
                child: Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      );
    }
  }
}
class ImageButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  const ImageButton({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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