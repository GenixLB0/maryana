import 'package:flutter/material.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: PhotoView(
        imageProvider: NetworkImage(
          imageUrl,
        ),
        initialScale: PhotoViewComputedScale.contained * 1,
        heroAttributes:
            PhotoViewHeroAttributes(tag: imageUrl![imageUrl!.length - 1]),
        loadingBuilder: (_, event) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(
              Color(0xFFD4B0FF),
            ),
          ),
        ),
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
  }
}

class AppColors {}
