import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditableAvatar extends StatelessWidget {
  final String? photoURL;
  final double radius;
  final VoidCallback? onPressed;
  final Function(File)? onEdit;

  const EditableAvatar({
    Key? key,
    this.photoURL,
    this.radius = 50,
    this.onPressed,
    this.onEdit,
  }) : super(key: key);

  Future<void> _handleImageSelection() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source:ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      onEdit?.call(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundImage: photoURL != null
                ? NetworkImage(photoURL!)
                : AssetImage('assets/default_profile.png') as ImageProvider,
          ),
          if (photoURL == null)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: radius * 0.4,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
