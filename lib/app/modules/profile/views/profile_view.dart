import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:maryana/app/modules/address/views/address_view.dart';
import 'package:maryana/app/modules/auth/views/login_view.dart';
import 'package:maryana/app/modules/gift_card/views/history.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/profile/views/update_profile.dart';
import 'package:maryana/app/routes/app_pages.dart';
import '../../auth/views/register_view.dart';
import '../controllers/profile_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  final ProfileController controller = Get.put(ProfileController());

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return controller.isAuth.value
            ? SizedBox(
                width: 375.w,
                height: 812.h,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 61.h),
                      controller.isLoading.value
                          ? LoadingWidget(_buildProfileHeader(context))
                          : _buildProfileHeader(context),
                      SizedBox(height: 45.h),
                      Container(
                        width: 327.w,
                        height: 575.h,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFF2F2F2)),
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
                            // _buildMenuItem(
                            //     'payment.svg', 'Payment method', () {}, 21, 2),
                            _buildMenuItem('coupon.svg', 'Coupons', () {
                              Get.toNamed(Routes.COUPON);
                            }, 24, 2),
                            _buildMenuItem('gift.svg', 'Gift Card', () {
                              Get.to(() => TransactionHistoryScreen());
                            }, 24, 4),
                            _buildMenuItem('order.svg', 'Orders', () {
                              Get.toNamed(Routes.ORDERS);
                            }, 24, 3),
                            _buildMenuItem('rate.svg', 'Rate this app', () {
                              if (GetPlatform.isAndroid) {
                                // Handle Google Play Store rating
                                // You can use a URL launcher to direct to Google Play Store
                                _launchURL(
                                    'https://play.google.com/store/apps/details?id=maryana.genixs.com.maryana');
                              } else if (GetPlatform.isIOS) {
                                // Handle Apple App Store rating
                                // You can use a URL launcher to direct to the Apple App Store
                                _launchURL(
                                    'https://apps.apple.com/hk/app/mariannella/id6608972125?l=en-GB');
                              }
                            }, 24, 4),
                            _buildMenuItem('terms.svg', 'Terms of Use', () {
                              _launchURL(
                                  'https://mariannella.genixarea.pro/terms.html');
                            }, 24, 5),
                            _buildMenuItem('privacy.svg', 'Privacy Policy', () {
                              _launchURL(
                                  'https://mariannella.genixarea.pro/privacy.html');
                            }, 24, 6),
                            _buildMenuItem('logout.svg', 'Log out', () {
                              _showLogoutConfirmation(context, controller);
                            }, 24, 7)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      )
                    ],
                  ),
                ))
            : Center(
                child: socialMediaPlaceHolder(),
              );
      }),
    );
  }

  void _showLogoutConfirmation(
      BuildContext context, ProfileController controller) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 230.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              Container(
                  padding: EdgeInsetsDirectional.all(12),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(color: Colors.black12),
                      shape: BoxShape.circle),
                  child: Icon(Icons.logout_outlined,
                      color: Colors.white, size: 24.sp)),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 300.w,
                      child: Text('Are you sure you want to log out?',
                          style: primaryTextStyle(
                              size: 18.sp.round(), weight: FontWeight.w600))),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        controller.Logout();
                        Get.back(); // Use Get.back() instead of Navigator.pop(context)
                      },
                      child: Container(
                        width: 150.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(color: Colors.black12),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text('Yes',
                                style: primaryTextStyle(
                                    size: 16.sp.round(),
                                    color: Colors.white,
                                    weight: FontWeight.bold))),
                      )),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: 150.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text('No',
                                style: primaryTextStyle(
                                    size: 16.sp.round(),
                                    color: Colors.white,
                                    weight: FontWeight.bold))),
                      )),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
            parent: _animationController,
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
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: 34.r,
                            backgroundImage: imageProvider,
                          ),
                        ),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => SizedBox(
                        width: 150.w,
                        child: Text(
                          GetMaxChar(
                              '${controller.userModel.value.firstName} ${controller.userModel.value.lastName}',
                              13),
                          style: primaryTextStyle(
                              color: Colors.black,
                              size: 16.sp.round(),
                              weight: FontWeight.bold),
                        ))),
                    SizedBox(height: 15.h),
                    Obx(() {
                      return controller.userModel.value.email.isNotEmpty
                          ? Text(
                              GetMaxChar(controller.userModel.value.email, 20),
                              style: primaryTextStyle(
                                  weight: FontWeight.w400,
                                  color: Colors.black,
                                  size: 12.sp.round()),
                            )
                          : SizedBox(); // التعامل مع الحالة التي يكون فيها العرض صفرًا
                    }),
                  ],
                ),
                Spacer(),
                Column(children: [
                  Container(
                    height: 40.h,
                    width: 60.w,
                    padding: const EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(-0.53, -0.85),
                        end: Alignment(0.53, 0.85),
                        colors: [
                          Color(0xFF7A59A5),
                          Color(0xFFA962FF),
                          Color(0xFFBA80FF)
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.85),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            controller.userModel.value.total_points!.toString(),
                            textAlign: TextAlign.center,
                            style: primaryTextStyle(
                              color: Colors.white,
                              size: 13.sp.round(),
                              height: 0.08,
                              weight: FontWeight.w700,
                            )),
                        const SizedBox(width: 4),
                        SvgPicture.asset(
                          "assets/images/home/medal.svg",
                          height: 23.h,
                          width: 23.w,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
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
                ]),
              ],
            ),
          ),
        ));
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
