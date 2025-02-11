import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/home/controllers/home_controller.dart';

 

import '../../global/theme/app_theme.dart';
import '../controllers/gift_card_controller.dart';
import 'history.dart';

class GiftCardView extends GetView<GiftCardController> {
  const GiftCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GiftCardController giftCardController = Get.put(GiftCardController());

    TextEditingController emailEditigController =
        TextEditingController(text: "fg");
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
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
                            fontFamily: GoogleFonts.cormorant().fontFamily,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Spacer(),
                    InkResponse(
                      onTap: () {
                        Get.to(TransactionHistoryScreen());
                      },
                      child: Text(
                        "history",
                        style: TextStyle(
                            fontFamily: GoogleFonts.cormorant().fontFamily,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: primaryColor),
                      ),
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: GetBuilder<HomeController>(builder: (logic) {
                            return CustomTextField(
                                labelText: "Email",
                                onChanged: (v) {
                                  logic.changeSelectedEmail(v);
                                  print("the v is ${v}");
                                });
                          }),
                        ),
                        SizedBox(
                          height: 55.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.w),
                          child: Text(
                            "Choose Gift Amount",
                            style: primaryTextStyle(),
                          ),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        GetBuilder<HomeController>(
                            id: 'gift-cards',
                            builder: (logic) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Container(
                                  child: PopupMenuButton<String>(
                                    constraints: BoxConstraints(
                                      minWidth: MediaQuery.of(context)
                                          .size
                                          .width, // Minimum width
                                      maxWidth: MediaQuery.of(context)
                                          .size
                                          .width, // Maximum width
                                    ),
                                    color: Colors.white,
                                    elevation: 5,
                                    initialValue: logic.selectedGiftCard.amount
                                        .toString(),
                                    itemBuilder: (context) {
                                      return logic.giftCards.map((giftCard) {
                                        return PopupMenuItem(
                                          value: giftCard.amount!.toString(),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.card_giftcard,
                                                      color: primaryColor,
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      giftCard.amount
                                                          .toString(),
                                                      style: primaryTextStyle(),
                                                    ),
                                                    Spacer(),
                                                  ],
                                                ),
                                                const Divider(
                                                    color: Colors.grey),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList();
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          width: 50.w,
                                          child: Text(
                                            logic.selectedGiftCard.amount
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: primaryTextStyle(
                                                size: 12.sp.round()),
                                          ),
                                        ),
                                        Spacer(),
                                        const Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                    onSelected: (v) {
                                      logic.changeSelectedGiftCardId(v);
                                      print(v);
                                      // controller.changeDropDownValue(
                                      //     controller.selectedCatId, v);
                                    },
                                  ),
                                ),
                              );
                            }),
                        SizedBox(
                          height: 45.h,
                        ),
                        GetBuilder<HomeController>(builder: (logic) {
                          return Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                  onTap: () {
                                    logic.sendGiftCard();
                                  },
                                  child: SvgPicture.asset(
                                      "assets/images/home/pay.svg")));
                        })
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
