import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/order/controllers/orders_controller.dart';

class RateProductScreen extends StatefulWidget {
  const RateProductScreen({Key? key}) : super(key: key);

  @override
  _RateProductScreenState createState() => _RateProductScreenState();
}

class _RateProductScreenState extends State<RateProductScreen>
    with SingleTickerProviderStateMixin {
  double rating = 4.0;
  String comment = "";
  final OrdersController controller = Get.find<OrdersController>();

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showAnimatedDialog() {
    _controller.forward();
    Get.defaultDialog(
      title: "",
      titlePadding: EdgeInsets.symmetric(vertical: 0),
      content: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            width: 327.w,
            height: 300.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/profile/right.svg',
                  width: 81.w,
                  height: 81.h,
                ),
                SizedBox(height: 26.h),
                Text(
                  'Thank you for your feedback!',
                  textAlign: TextAlign.center,
                  style: primaryTextStyle(
                    color: const Color(0xFF42474A),
                    size: 16.sp.round(),
                    weight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'We appreciated your feedback.\nWe’ll use your feedback to improve your experience.',
                    textAlign: TextAlign.center,
                    style: primaryTextStyle(
                      color: const Color(0xFF6D758A),
                      size: 14.sp.round(),
                      fontFamily: 'Lato',
                      weight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                InkWell(
                  onTap: () {
                    Get.back(); // Close the dialog
                    Get.back(); // Go back to the previous screen
                    _controller.reset();
                  },
                  child: Container(
                    width: 101.w,
                    height: 30.h,
                    decoration: ShapeDecoration(
                      color: Color(0xFF370269),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Done',
                        textAlign: TextAlign.center,
                        style: secondaryTextStyle(
                          color: Colors.white,
                          size: 14.sp.round(),
                          fontFamily: 'Product Sans',
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Rate Product',
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 47.h),
              Container(
                width: 309.w,
                height: 56.h,
                decoration: ShapeDecoration(
                  color: const Color(0xFFE7D3FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: 20.w, end: 25.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/profile/rateWin.svg',
                                  width: 22.w,
                                  height: 22.h,
                                ),
                                SizedBox(width: 13.w),
                                Text(
                                  'Submit your review to get 5 points',
                                  style: primaryTextStyle(
                                    color: Color(0xFF53178C),
                                    size: 12.sp.round(),
                                    weight: FontWeight.w400,
                                    height: 0,
                                    letterSpacing: -0.12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/images/profile/down.svg',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 36.h),
              Center(
                child: RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Color(0xFF508A7B),
                  ),
                  onRatingUpdate: (newRating) {
                    setState(() {
                      rating = newRating;
                    });
                  },
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: 308.w,
                height: 267.h,
                child: TextField(
                  style: primaryTextStyle(
                    color: Color(0xFF5A5A5A),
                    size: 12.sp.round(),
                    weight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 29.h,
                    ),
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    hintText:
                        "Would you like to write anything about this product?",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  maxLength: 50,
                  maxLines: 9,
                  onChanged: (value) {
                    setState(() {
                      comment = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 30.h),
              Obx(
                () => Center(
                  child: SecondMyDefaultButton(
                    isloading: controller.isloadingAddReview.value,
                    onPressed: () async {
                      await controller.submitRating(
                          controller.productId, rating, comment);
                      _showAnimatedDialog();
                    },
                    btnText: "Submit Review",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
