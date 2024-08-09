import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maryana/app/modules/gift_card/controllers/gift_card_controller.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
 
class TransactionHistoryScreen extends StatelessWidget {
  final GiftCardController controller = Get.put(GiftCardController());

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: const CustomAppBar(
              title: 'History',
            ),
            body: Column(children: [
              TabBar(
                indicator: ShapeDecoration(
                  color: const Color(0xFFE7D3FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                indicatorPadding: EdgeInsetsDirectional.symmetric(
                    horizontal: (-screenWidth * 0.05), vertical: 10.h),
                labelStyle: primaryTextStyle(
                  size: 14.sp.round(),
                  color: const Color(0xFF53178C),
                  weight: FontWeight.w400,
                ),
                unselectedLabelColor: Colors.black,
                unselectedLabelStyle: primaryTextStyle(
                  size: 14.sp.round(),
                  color: Colors.black,
                  weight: FontWeight.w400,
                ),
                padding: EdgeInsetsDirectional.only(
                  top: screenHeight * 0.001,
                  bottom: screenHeight * 0.001,
                  end: screenWidth * 0.03,
                ),
                onTap: (index) {
                  if (index == 0) {
                    controller.sent.value = true;
                  } else {
                    controller.sent.value = false;
                  }
                },
                tabs: [
                  Tab(text: 'Payment sent'),
                  Tab(text: 'Received'),
                ],
              ),
              Obx(() {
                if (controller.loading.value) {
                  return Center(
                      child: LoadingAnimationWidget.flickr(
                    leftDotColor: primaryColor,
                    rightDotColor: const Color(0xFFFF0084),
                    size: 50,
                  ));
                } else if (controller.sent.value &&
                        controller.sentTransactions.isEmpty ||
                    !controller.sent.value &&
                        controller.receivedTransactions.isEmpty) {
                  return SizedBox(
                    height: 620.h,
                    child: Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                            tag: 'gift',
                            child: SvgPicture.asset(
                              "assets/images/profile/gift.svg",
                              width: MediaQuery.of(context).size.width / 3,
                              height: MediaQuery.of(context).size.height / 4,
                              fit: BoxFit.fitWidth,
                              color: primaryColor,
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: 15.w),
                          child: Text(
                            'No gift cards available',
                            style: primaryTextStyle(size: 20.sp.round()),
                          ),
                        ),
                      ],
                    )),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        TabBarViewWidget(controller: controller),
                      ],
                    ),
                  );
                }
              }),
            ])));
  }
}

class TabBarViewWidget extends StatelessWidget {
  const TabBarViewWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final GiftCardController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 32.h,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height -
              kToolbarHeight -
              kBottomNavigationBarHeight -
              50.h,
          child: TabBarView(
            children: [
              TransactionList(
                  transactions: controller.sentTransactions, sent: true),
              TransactionList(
                  transactions: controller.receivedTransactions, sent: false),
            ],
          ),
        ),
      ],
    );
  }
}

class TransactionList extends StatelessWidget {
  final RxList<Transaction> transactions;
  final bool sent;

  TransactionList({required this.transactions, required this.sent});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return ShowUp(
                delay: index * 100,
                child: Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 16.w,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.only(
                            top: 16.h, start: 16.w, end: 24.w, bottom: 16.h),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9F5FF),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: const BoxDecoration(
                                  color: Color(0xff21034F),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  transaction.from!.firstName[0].toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontFamily: GoogleFonts.roboto().fontFamily,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.15,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.0.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 204.w,
                                    child: Text(
                                      "${transaction.from!.firstName} ${transaction.from!.lastName}",
                                      style:  primaryTextStyle(
                                        color: const Color(0xFF21034F),
                                        size: 14.round(),
                                        weight: FontWeight.w700,
                                        letterSpacing: 0.10,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  SizedBox(
                                    width: 204.w,
                                    child: Text(
                                      transaction.date,
                                      style:  primaryTextStyle(
                                        color: const Color(0xFF49454F),
                                        size: 14.round(),
                                        weight: FontWeight.w400,
                                        letterSpacing: 0.25,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Text(
                              !sent
                                  ? '+${transaction.amount}'
                                  : '${transaction.amount}',
                              style:  primaryTextStyle(
                                color: const Color(0xFF49454F),
                                size: 14.round(),
                                weight: FontWeight.w500,
                                letterSpacing: 0.10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PositionedDirectional(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width -
                              32.w, // Adjust the width as needed
                          height: 1.h,
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFFCAC4D0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          },
        ));
  }
}
