import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:maryana/app/modules/address/views/address_view.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/profile/views/update_profile.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  final ProfileController controller = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return SizedBox(
          width: 375.w,
          height: 812.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 61.h),
              controller.isLoading.value
                  ? LoadingWidget(_buildProfileHeader(context))
                  : _buildProfileHeader(context),
              SizedBox(height: 58.h),
              Container(
                width: 327.w,
                height: 502.h,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFF2F2F2)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x330E0E0E),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                      spreadRadius: -8,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuItem('address.svg', 'Address', () {
                      Get.to(() => AddressListScreen());
                    }, 21, 1),
                    _buildMenuItem(
                        'payment.svg', 'Payment method', () {}, 21, 2),
                    _buildMenuItem('coupon.svg', 'Coupons', () {}, 24, 3),
                    _buildMenuItem('gift.svg', 'Gift Card', () {}, 24, 4),
                    _buildMenuItem('order.svg', 'Orders', () {}, 24, 5),
                    _buildMenuItem('rate.svg', 'Rate this app', () {}, 24, 6),
                    _buildMenuItem('logout.svg', 'Log out', () {
                      // Implement logout functionality
                    }, 24, 7)
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: controller.isLoading.value ? 0 : 1,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, -1),
          end: Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: AnimationController(
            duration: Duration(milliseconds: 500),
            vsync: this,
          )..forward(),
          curve: Curves.easeOut,
        )),
        child: SizedBox(
          width: 297.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 34.r,
                backgroundImage: controller.userModel.value.photo == null ||
                        controller.userModel.value.photo!.isEmpty
                    ? const AssetImage(
                        'assets/images/profile/profile_placeholder.png')
                    : null,
                child: controller.userModel.value.photo == null ||
                        controller.userModel.value.photo!.isEmpty
                    ? null
                    : CachedNetworkImage(
                        imageUrl: controller.userModel.value.photo!,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 34.r,
                          backgroundImage: const AssetImage(
                              'assets/images/profile/profile_placeholder.png'),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 16.r,
                            ),
                          ),
                        ),
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 34.r,
                          backgroundImage: imageProvider,
                        ),
                      ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                        '${controller.userModel.value.firstName} ${controller.userModel.value.lastName}',
                        style: primaryTextStyle(
                            color: Colors.black,
                            size: 16.sp.round(),
                            weight: FontWeight.bold),
                      )),
                  SizedBox(height: 6.h),
                  Obx(() => Text(
                        controller.userModel.value.email,
                        style: primaryTextStyle(
                            weight: FontWeight.w400,
                            color: Colors.black,
                            size: 12.sp.round()),
                      )),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () => {
                  // add there action
                  Get.to(() => ProfileUpdate())
                },
                child: SvgPicture.asset(
                  'assets/images/profile/setting.svg',
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      String icon, String title, VoidCallback onTap, double size, int index) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: ShowUp(
            delay: 50 * index,
            child: SizedBox(
              width: 327.w,
              height: 70.h,
              child: Stack(
                children: [
                  PositionedDirectional(
                    start: 13.w,
                    top: 22.5.h,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/profile/$icon',
                          width: size.w,
                          height: size.h,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: primaryTextStyle(
                            color: Color(0xFF33302E),
                            size: 14.sp.round(),
                            weight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PositionedDirectional(
                    end: 20.w,
                    top: 22.5.h,
                    child: SvgPicture.asset(
                      'assets/images/profile/arrow.svg',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (title != 'Log out')
          Container(
            width: 313.w,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFE6E8EC),
                ),
              ),
            ),
          )
      ],
    );
  }
}
