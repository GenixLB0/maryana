import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';

class FullScreenImageWithLoading extends StatefulWidget {
  final File? image;

  const FullScreenImageWithLoading({Key? key, required this.image})
      : super(key: key);

  @override
  _FullScreenImageWithLoadingState createState() =>
      _FullScreenImageWithLoadingState();
}

class _FullScreenImageWithLoadingState extends State<FullScreenImageWithLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full screen image
        Positioned.fill(
          child: widget.image != null
              ? AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
                      child: Image.file(
                        widget.image!,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                )
              : Container(color: Colors.grey),
        ),
        // Semi-transparent overlay
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        // Centered loading indicator
        Center(child: loadingIndicatorWidget()),
        // Floating action button to pick image
      ],
    );
  }
}
