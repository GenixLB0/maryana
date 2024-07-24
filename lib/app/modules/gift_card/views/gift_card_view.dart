import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';

import 'package:nb_utils/nb_utils.dart' hide boldTextStyle;

import '../../global/theme/app_theme.dart';
import '../controllers/gift_card_controller.dart';

class GiftCardView extends GetView<GiftCardController> {
  const GiftCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                        "assets/images/forgot_password/BackBTN.svg"),
                  ),
                ),
                Spacer(),
                Center(
                  child: Text(
                    "Buy A Gift Card",
                    style: TextStyle(
                        fontFamily: fontCormoantFont,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Spacer(),
                Text(
                  "history",
                  style: TextStyle(
                      fontFamily: fontCormoantFont,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryColor),
                ),
              ],
            ),
          ),
          Container(
            height: 2,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black12,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
          ),
          SizedBox(
            height: 35.h,
          ),
          SvgPicture.asset(
            "assets/images/home/gift_card.svg",
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      "Choose recipient",
                      style: boldTextStyle(),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                      height: 2,
                      color: Colors.grey[200],
                    ),
                    SizedBox(
                      height: 55.h,
                    ),
                    Center(
                      child: Text("Soon.."),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
