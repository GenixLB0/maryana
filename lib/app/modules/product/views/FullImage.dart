import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:widget_zoom/widget_zoom.dart';


import '../../global/theme/app_theme.dart';

class FullScreenImage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  FullScreenImage({required this.imageUrls, this.initialIndex = 0});

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  late int _currentIndex;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index, _) {
              return
                WidgetZoom(

                  heroAnimationTag: widget.imageUrls[index],

                  zoomWidget: CachedNetworkImage(
                    imageUrl: widget.imageUrls[index],
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height ,
                    width: MediaQuery.of(context).size.width,
                    errorWidget: (context, url, error) => placeHolderWidget(),
                    placeholder: (context, url) => loadingIndicatorWidget(),

                  ),
                );



              //   PhotoView(
              //
              //   imageProvider:
              //       CachedNetworkImageProvider(widget.imageUrls[index]),
              //   initialScale: PhotoViewComputedScale.contained * 1,
              //   heroAttributes:
              //       PhotoViewHeroAttributes(tag: widget.imageUrls[index]),
              //   loadingBuilder: (_, event) => const Center(
              //     child: CircularProgressIndicator(
              //       valueColor: AlwaysStoppedAnimation(
              //         Color(0xFFD4B0FF),
              //       ),
              //     ),
              //   ),
              //   backgroundDecoration: const BoxDecoration(
              //     color: Colors.white,
              //   ),
              // );
            },
            options: CarouselOptions(
              initialPage: _currentIndex,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              height: MediaQuery.of(context).size.height,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
               Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Tap For Free Zoom",style: secondaryTextStyle(color: Colors.black,
                  size: 12.sp.round()

                  ),),
                  Icon(Icons.touch_app)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.imageUrls.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _carouselController.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                            .withOpacity(_currentIndex == entry.key ? 0.9 : 0.4),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
