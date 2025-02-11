import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

class FullScreenImageWithLoading extends StatefulWidget {
  final File? image;

  const FullScreenImageWithLoading({Key? key, required this.image})
      : super(key: key);

  @override
  _FullScreenImageWithLoadingState createState() =>
      _FullScreenImageWithLoadingState();
}

class _FullScreenImageWithLoadingState extends State<FullScreenImageWithLoading>
    with TickerProviderStateMixin {
  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;

  late AnimationController _bumpAnimationController;
  late Animation<double> _bumpAnimation;

  late AnimationController _scanController;
  late Animation<Alignment> _scanAnimation;

  late AnimationController _lightningController;
  late Animation<double> _lightningAnimation;

  @override
  void initState() {
    super.initState();

    // Zoom animation for breathing effect
    _zoomController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _zoomAnimation =
        Tween<double>(begin: 1.0, end: 1.1).animate(_zoomController);

    // Bump animation for the AI Powered button
    _bumpAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _bumpAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
        CurvedAnimation(
            parent: _bumpAnimationController, curve: Curves.elasticInOut));

    // Scanning light animation
    _scanController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _scanAnimation = Tween<Alignment>(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).animate(
        CurvedAnimation(parent: _scanController, curve: Curves.easeInOut));

    // Lightning effect for Scanning Image text
    _lightningController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _lightningAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _lightningController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _bumpAnimationController.dispose();
    _scanController.dispose();
    _lightningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full screen image with zoom effect (breathing effect)
        Positioned.fill(
          child: widget.image != null
              ? AnimatedBuilder(
                  animation: _zoomAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _zoomAnimation.value,
                      child: Image.file(
                        widget.image!,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                )
              : Container(color: Colors.grey),
        ),

        // Image fragmenting effect (this simulates the "torn apart" effect)
        // Positioned.fill(
        //   child: ShaderMask(
        //     shaderCallback: (bounds) {
        //       return RadialGradient(
        //         colors: [
        //           Colors.transparent,
        //           Colors.blue.withOpacity(0.6),
        //           Colors.transparent,
        //         ],
        //         stops: [0.0, 0.5, 1.0],
        //         center: Alignment.center,
        //         radius: 1.0,
        //       ).createShader(bounds);
        //     },
        //     blendMode: BlendMode.dstOut,
        //     child: widget.image != null
        //         ? Image.file(
        //             widget.image!,
        //             fit: BoxFit.cover,
        //           )
        //         : Container(color: Colors.grey),
        //   ),
        // ),

        // Scanning light effect (blue scanning line moving up and down)
        AnimatedBuilder(
          animation: _scanAnimation,
          builder: (context, child) {
            return Align(
              alignment: _scanAnimation.value,
              child: Container(
                height: 4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(0.0),
                      Colors.blueAccent.withOpacity(0.6),
                      Colors.blueAccent.withOpacity(0.0),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            );
          },
        ),

        // AI Powered button with bump and shimmer effect
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: 50.h, right: 10.w),
            child: ScaleTransition(
              scale: _bumpAnimation,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20.h),
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.blue,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Add a robot icon
                        Icon(
                          Icons.android,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        SizedBox(
                            width: 10.w), // Space between the icon and the text
                        Text(
                          'AI Powered',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Scanning Image text with lightning effect
        // Scanning Image text with lightning effect inside Material widget
        Align(
          alignment: Alignment.center,
          child: AnimatedBuilder(
            animation: _lightningAnimation,
            builder: (context, child) {
              return Material(
                // Ensure it's part of Material design
                color:
                    Colors.transparent, // Transparent background for Material
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.white, width: 2),
                  //   borderRadius: BorderRadius.circular(10),
                  //   color: Colors.black.withOpacity(
                  //       0.05), // Set a darker background to avoid yellow tint
                  // ),
                  child: Shimmer.fromColors(
                    baseColor: Colors.white, // Base color for the text
                    highlightColor: primaryColor.withOpacity(
                        _lightningAnimation.value), // Lightning effect
                    child: Text(
                      'SCANNING IMAGE...',
                      style: secondaryTextStyle(
                        color:
                            Colors.white, // Ensure the text color remains white
                        size: 24.sp.round(),
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Centered circular loading indicator
        // Center(
        //   child: CircularProgressIndicator(color: Colors.blueAccent),
        // ),
      ],
    );
  }
}
