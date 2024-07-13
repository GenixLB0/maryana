import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/app/modules/global/model/test_model_response.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/home/controllers/home_controller.dart';
import 'package:maryana/app/modules/main/controllers/tab_controller.dart';
import 'package:maryana/app/modules/product/views/product_view.dart';
import 'package:maryana/app/modules/search/controllers/search_controller.dart';
import 'package:maryana/app/modules/search/views/result_view.dart';
import 'package:maryana/app/modules/search/views/search_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../main.dart';
import '../../../routes/app_pages.dart';
import '../../services/api_consumer.dart';
import '../../services/api_service.dart';

Widget gridSocialIcon() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ShowUp(
          delay: 400,
          child: SocialMediaIcon(
            assetPath: 'assets/icons/small_apple.svg',
            onTap: () {
              // Handle Apple login
            },
          )),
      SizedBox(width: 16.w),
      ShowUp(
          delay: 200,
          child: SocialMediaIcon(
            assetPath: 'assets/icons/small_google.svg',
            onTap: () {
              // Handle Google login
            },
          )),
      SizedBox(width: 16.w),
      ShowUp(
          delay: 400,
          child: SocialMediaIcon(
            assetPath: 'assets/icons/small_facebook.svg',
            onTap: () {
              // Handle Facebook login
            },
          )),
    ],
  );
}

class SocialMediaIcon extends StatefulWidget {
  final String assetPath;
  final int? index;
  final VoidCallback onTap;

  const SocialMediaIcon({
    required this.assetPath,
    required this.onTap,
    this.index,
  });

  @override
  _SocialMediaIconState createState() => _SocialMediaIconState();
}

class _SocialMediaIconState extends State<SocialMediaIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SvgPicture.asset(
          widget.assetPath,
          width: 42.w,
          height: 42.h,
        ),
      ),
    );
  }
}

class MySecondDefaultButton extends StatefulWidget {
  final String? btnText;
  final bool localeText;
  final Function() onPressed;
  final Color? color;
  final Color? textColor;
  final bool isSelected;
  final String? Icon;
  final double? height;
  final bool isloading;
  final double? width;

  const MySecondDefaultButton({
    Key? key,
    this.btnText,
    required this.onPressed,
    this.color,
    this.isSelected = true,
    this.localeText = false,
    required this.isloading,
    this.textColor,
    this.height,
    this.width,
    this.Icon,
  }) : super(key: key);

  @override
  MySecondDefaultButtonState createState() => MySecondDefaultButtonState();
}

class MySecondDefaultButtonState extends State<MySecondDefaultButton> {
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isloading = widget.isloading!;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return widget.isloading!
        ? Center(
            child: LoadingAnimationWidget.flickr(
            leftDotColor: primaryColor,
            rightDotColor: const Color(0xFFFF0084),
            size: 50,
          ))
        : InkWell(
            onTap: () => {
              widget.onPressed(),
            },
            child: Container(
              width: 315.w,
              height: 48.h,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                  color: widget.color ?? Color(0xFF21034F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      widget.localeText
                          ? widget.btnText!.toUpperCase()
                          : widget.btnText!,
                      textAlign: TextAlign.center,
                      style: primaryTextStyle(
                        color: Colors.white,
                        size: 16.sp.round(),
                        weight: FontWeight.w700,
                      )),
                ],
              ),
            ),
          );
  }
}

Widget MainLoading({double? width, double? height}) {
  return SizedBox(
      width: width ?? 375.w,
      height: height ?? 812.h,
      child: Center(
          child: LoadingAnimationWidget.flickr(
        leftDotColor: primaryColor,
        rightDotColor: const Color(0xFFFF0084),
        size: 50,
      )));
}

class MyDefaultButton extends StatefulWidget {
  final String? btnText;
  final bool localeText;
  final Function() onPressed;
  final Color? color;
  final Color? textColor;
  final bool isSelected;
  final String? Icon;
  final double? height;
  final bool isloading;
  final double? width;

  const MyDefaultButton({
    Key? key,
    this.btnText,
    required this.onPressed,
    this.color,
    this.isSelected = true,
    this.localeText = false,
    required this.isloading,
    this.textColor,
    this.height,
    this.width,
    this.Icon,
  }) : super(key: key);

  @override
  MyDefaultButtonState createState() => MyDefaultButtonState();
}

class MyDefaultButtonState extends State<MyDefaultButton> {
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isloading = widget.isloading!;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return widget.isloading!
        ? Center(
            child: LoadingAnimationWidget.flickr(
            leftDotColor: primaryColor,
            rightDotColor: const Color(0xFFFF0084),
            size: 50,
          ))
        : InkWell(
            onTap: () => {
              widget.onPressed(),
            },
            child: Container(
              width: 315.w,
              height: widget.height ?? 48.h,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    widget.Icon ?? 'assets/icons/cart_in_button.svg',
                    width: 20.w,
                    height: 20.h,
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Text(
                      widget.localeText
                          ? widget.btnText!.toUpperCase()
                          : widget.btnText!,
                      textAlign: TextAlign.center,
                      style: primaryTextStyle(
                        color: widget.textColor ?? Color(0xFF21034F),
                        size: 16.sp.round(),
                        weight: FontWeight.w700,
                      )),
                ],
              ),
            ),
          );
  }
}

class CustomTextField extends StatefulWidget {
  final String labelText;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final String? initialValue;
  final bool obscureText;
  final double? width;
  final String? icon;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? customTextEditingController;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.onChanged,
    this.errorText,
    this.obscureText = false,
    this.icon,
    this.initialValue,
    this.onSubmitted,
    this.customTextEditingController,
    this.width,
    this.keyboardType = TextInputType.text, // Default to TextInputType.text
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 310.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.customTextEditingController,
            onChanged: widget.onChanged,
            initialValue: widget.initialValue ?? '',
            obscureText: _obscureText,
            onFieldSubmitted: widget.onSubmitted,
            keyboardType: widget.keyboardType,
            style: primaryTextStyle(
              color: Colors.black,
              size: 14.sp.round(),
              weight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintStyle: primaryTextStyle(
                color: Colors.black,
                size: 14.sp.round(),
                weight: FontWeight.w400,
                height: 1,
              ),
              errorStyle: primaryTextStyle(
                color: Colors.red,
                size: 14.sp.round(),
                weight: FontWeight.w400,
                height: 1,
              ),
              labelStyle: primaryTextStyle(
                color: Color(0xFFA6AAC3),
                size: 14.sp.round(),
                weight: FontWeight.w400,
                height: 1,
              ),
              errorText: widget.errorText,
              labelText: widget.labelText,
              prefixIcon: widget.icon != null
                  ? Padding(
                      padding: EdgeInsets.all(12.w),
                      child: SvgPicture.asset(
                        widget.icon!,
                        width: 13.w,
                        height: 13.h,
                      ),
                    )
                  : null,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: SvgPicture.asset(
                        _obscureText
                            ? 'assets/icons/eye_closed.svg'
                            : 'assets/icons/eye_open.svg',
                        width: _obscureText ? 20.w : 18.w,
                        height: _obscureText ? 20.h : 18.h,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

Widget DividerSocial() {
  return SizedBox(
    width: 327.w + 16.w,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 148.w,
          height: 1.h,
          decoration: const BoxDecoration(color: Color(0xFFE3E4E5)),
        ),
        SizedBox(
          width: 8.w,
        ),
        Text('or',
            textAlign: TextAlign.center,
            style: primaryTextStyle(
              color: const Color(0xFF090A0A),
              size: 16.sp.round(),
              weight: FontWeight.w400,
            )),
        SizedBox(
          width: 8.w,
        ),
        Container(
          width: 148.w,
          height: 1.h,
          decoration: const BoxDecoration(color: Color(0xFFE3E4E5)),
        ),
      ],
    ),
  );
}

Widget buttonSocialMedia(
    {txtColor,
    bool? axis,
    required index,
    required text,
    required icon,
    required color,
    required borderColor}) {
  return ShowUp(
      delay: index * 100,
      child: Container(
          width: 327.w,
          height: 48.h,
          decoration: ShapeDecoration(
            color: Color(color),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(borderColor)),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: axis == null || axis == false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(icon),
                    Text(
                      text,
                      style: primaryTextStyle(
                        size: 16.sp.round(),
                        color: Color(txtColor),
                        weight: FontWeight.w500,
                        height: 0.06,
                      ),
                    ),
                    const SizedBox()
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      const SizedBox(),
                      SvgPicture.asset(icon),
                      Text(
                        text,
                        style: primaryTextStyle(
                          size: 16.sp.round(),
                          color: Color(txtColor),
                          weight: FontWeight.w500,
                          height: 0.06,
                        ),
                      ),
                    ])));
}

void buildCustomShowModel(
    {required BuildContext context,
    required Widget child,
    double? height,
    EdgeInsets? padding}) async {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (builder) {
      return Container(
        width: 375.w,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          color: Colors.white,
        ),
        height: height,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16.0),
        child: child,
      );
    },
  );
}

void imagesSourcesShowModel({
  required BuildContext context,
  Function? onCameraPressed,
  Function? onGalleryPressed,
  bool allowMultiple = false,
}) async {
  buildCustomShowModel(
    context: context,
    height: 140.0.h,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Camera //
        Expanded(
          child: TextButton(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Take a Photo",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
            onPressed: onCameraPressed != null
                ? () {
                    onCameraPressed();
                  }
                : null,
          ),
        ),
        Divider(height: 1, color: Colors.grey),
        // Gallery //
        Expanded(
          child: TextButton(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select from Gallery",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
            onPressed: onGalleryPressed != null
                ? () {
                    onGalleryPressed();
                  }
                : null,
          ),
        ),
      ],
    ),
  );
}

class ShowUp extends StatefulWidget {
  final Widget? child;
  final int? delay;

  ShowUp({@required this.child, this.delay});

  @override
  _ShowUpState createState() => _ShowUpState();
}

class _ShowUpState extends State<ShowUp> with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
            .animate(curve);

    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay!), () {
        if (mounted) _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
      opacity: _animController,
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Function()? function;

  const CustomAppBar({
    this.title,
    this.actions,
    this.function,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Container(
          height: 40.h,
          width: 40.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 0,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child:
              SvgPicture.asset("assets/images/forgot_password/Frame 361.svg"),
        ),
        onPressed: () {
          if (function != null) {
            function!();
          } else {
            Get.back();
          }
        },
      ),
      title: Text(title ?? '',
          style: TextStyle(
            color: Color(0xFF1D1F22),
            fontSize: 22.sp,
            fontFamily: GoogleFonts.cormorant().fontFamily,
            fontWeight: FontWeight.w700,
            height: 0,
          )),
      actions: actions ?? [Container()],
      centerTitle: true,
      backgroundColor: const Color(0xffFDFDFD),
    );
  }
}

Widget LoadingWidget(Widget child) {
  return Shimmer.fromColors(
    child: child,
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    direction: ShimmerDirection.ttb,
  );
}

class CustomNavBar extends StatelessWidget {
  final NavigationsBarController _tabController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95.h,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        shadows: [
          BoxShadow(color: Colors.black38, spreadRadius: -5, blurRadius: 15),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            unselectedItemColor: const Color(0xFFB9B9B9),
            selectedItemColor: const Color(0xFF53178C),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (index) {
              _tabController.changeIndex(index);
            },
            currentIndex: _tabController.selectedIndex.value,
            items: [
              // Home
              _buildBottomNavigationBarItem(0, "Home", "home"),
              // Shop
              _buildBottomNavigationBarItem(1, "Shop", "shop"),
              // Bag
              _buildBottomNavigationBarItem(2, "Bag", "bag"),
              // Wishlist
              _buildBottomNavigationBarItem(3, "Wishlist", "wishlist"),
              // Profile
              _buildBottomNavigationBarItem(4, "Profile", "profile"),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      int tabIndex, String label, String iconName) {
    final isSelected = _tabController.selectedIndex.value == tabIndex;
    return BottomNavigationBarItem(
      icon: isSelected
          ? _buildSelectedIcon(iconName, label)
          : _buildUnselectedIcon(iconName, label),
      label: label,
    );
  }

  Widget _buildSelectedIcon(String iconName, String label) {
    return Container(
        height: 60.h,
        width: 60.w,
        decoration: BoxDecoration(
          color: const Color(0xffE8DEF8),
          borderRadius: BorderRadius.circular(30.sp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/${iconName}_active.svg",
              height: 30.h,
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: primaryTextStyle(
                weight: FontWeight.w700,
                size: 8.sp.round(),
              ),
            ),
          ],
        ));
  }

  Widget _buildUnselectedIcon(String iconName, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/icons/$iconName.svg",
          height: 30.h,
        ),
        SizedBox(height: 3.h),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 8.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

Widget loadingIndicatorWidget() {
  return Center(
      child: LoadingAnimationWidget.flickr(
    leftDotColor: primaryColor,
    rightDotColor: const Color(0xFFFF0084),
    size: 50,
  ));
}

Widget placeHolderWidget() {
  return Lottie.asset("assets/images/placeholder.json");
}

buildSearchAndFilter(
    {required BuildContext context,
    List<ViewProductData>? products,
    List<Categories>? categories,
    required bool isSearch,
    final Function(String)? onSubmitted // Add this parameter
    }) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 75.h,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 20.w,
        ),
        Flexible(
          flex: 12,
          child: SizedBox(
            child: TextField(
              readOnly: isSearch ? false : true,
              onSubmitted: (v) {
                if (isSearch) {
                  onSubmitted!(v);
                }
              },
              maxLines: 1,
              onTap: () {
                if (isSearch) {
                  if (products == null) {
                    HomeController controller = HomeController().initialized
                        ? Get.find<HomeController>()
                        : Get.put<HomeController>(HomeController());
                    products = controller.homeModel.value.product;
                  }

                  if (categories == null) {
                    HomeController controller = HomeController().initialized
                        ? Get.find<HomeController>()
                        : Get.put<HomeController>(HomeController());
                    categories = controller.homeModel.value.categories;
                  }

                  Get.to(SearchView(),
                      arguments: [products, categories],
                      transition: Transition.fadeIn,
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 800));
                } else {
                  if (products == null) {
                    HomeController controller = HomeController().initialized
                        ? Get.find<HomeController>()
                        : Get.put<HomeController>(HomeController());
                    products = controller.homeModel.value.product;
                  }

                  if (categories == null) {
                    HomeController controller = HomeController().initialized
                        ? Get.find<HomeController>()
                        : Get.put<HomeController>(HomeController());
                    categories = controller.homeModel.value.categories;
                  }

                  Get.to(SearchView(),
                      arguments: [products, categories],
                      transition: Transition.fadeIn,
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 800));
                }

                // Get.toNamed(
                //   Routes.SEARCH,
                //   arguments: [products, categories],
                // );
                // Get.toNamed(()=> Pages., arguments: controller.homeModel.value.product);
              },
              style: primaryTextStyle(
                color: Colors.black,
                size: 14.sp.round(),
                weight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 17.h),
                //Imp Line

                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 2)),

                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 2)),
                hintStyle: primaryTextStyle(
                  color: Colors.black,
                  size: 14.sp.round(),
                  weight: FontWeight.w400,
                  height: 1,
                ),
                errorStyle: primaryTextStyle(
                  color: Colors.red,
                  size: 14.sp.round(),
                  weight: FontWeight.w400,
                  height: 1,
                ),
                labelStyle: primaryTextStyle(
                  color: Colors.grey[400],
                  size: 14.sp.round(),
                  weight: FontWeight.w400,
                  height: 1,
                ),
                labelText: "Search Clothes...",
                prefixIcon: IconButton(
                  icon: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: SvgPicture.asset(
                      'assets/icons/search.svg',
                      width: 23.w,
                      height: 23.h,
                    ),
                  ),
                  onPressed: () {},
                ),
                suffixIcon: IconButton(
                  icon: Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: SvgPicture.asset(
                      'assets/icons/camera.svg',
                      width: 23.w,
                      height: 23.h,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        InkWell(
          onTap: () {
            showMaterialModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              expand: false,
              builder: (context) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: buildFilterBottomSheet(
                      context: context, comingProducts: products)),
            );
          },
          child: Container(
            child: SvgPicture.asset(
              "assets/images/home/Filter.svg",
              height: 50.h,
              width: 50.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 15.w,
        )
      ],
    ),
  );
}

class buildProductCard extends StatefulWidget {
  buildProductCard(
      {super.key, required this.product, this.isInWishlist = false});

  final ViewProductData product;
  bool isInWishlist;

  @override
  State<buildProductCard> createState() => _buildCardProductState();
}

class _buildCardProductState extends State<buildProductCard> {
  HomeController homeController = Get.put<HomeController>(HomeController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 5),
          ],
        ),
        child: widget.product.image != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            Routes.PRODUCT,
                            arguments: widget.product,
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: widget.product.image!,
                          width: 175.w,
                          height: 210.h,
                          fit: BoxFit.cover,
                          placeholder: (ctx, v) {
                            return placeHolderWidget();
                          },
                        ),
                      ),
                      Obx(() {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                homeController.wishlistProductIds
                                        .contains(widget.product.id!)
                                    ? homeController
                                        .removeFromWishlist(widget.product.id!)
                                    : homeController
                                        .addToWishlist(widget.product.id!);
                              },
                              child: homeController.wishlistProductIds
                                      .contains(widget.product.id!)
                                  ? ShowUp(
                                      delay: 500,
                                      child: SvgPicture.asset(
                                        "assets/images/home/wishlisted.svg",
                                        width: 33.w,
                                        height: 33.h,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ShowUp(
                                      delay: 500,
                                      child: SvgPicture.asset(
                                        "assets/images/home/add_to_wishlist.svg",
                                        width: 33.w,
                                        height: 33.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ));
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 7.w),
                    child: GestureDetector(
                      onTap: () {
                        print(
                            "the sent product model is ${widget.product.sizes}");
                        Get.toNamed(
                          Routes.PRODUCT,
                          arguments: widget.product,
                        );
                      },
                      child: Container(
                        width: 150.w,
                        child: Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: Text(
                              widget.product.name!,
                              overflow: TextOverflow.ellipsis,
                              style: primaryTextStyle(
                                  weight: FontWeight.w700,
                                  size: 16.sp.round(),
                                  color: Colors.black),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 7.w),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          Routes.PRODUCT,
                          arguments: widget.product,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 5.w),
                        width: 150.w,
                        child: Text(
                          widget.product.description!,
                          overflow: TextOverflow.ellipsis,
                          style: primaryTextStyle(
                              weight: FontWeight.w300,
                              size: 14.sp.round(),
                              color: Color(0xff9B9B9B)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 7.w),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          Routes.PRODUCT,
                          arguments: widget.product,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: Text(
                          "\$ ${widget.product.price} ",
                          style: primaryTextStyle(
                              weight: FontWeight.w600,
                              size: 15.sp.round(),
                              color: const Color(0xff370269)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  widget.isInWishlist
                      ? GestureDetector(
                          onTap: () {
                            //todo
                            // take Product arguments from here
                            ViewProductData product = widget.product;

                            //todo
                            //Nav To Cart Screen
                            //Setted to Main Screen for now
                            Get.toNamed(Routes.MAIN);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10.w),
                            padding: EdgeInsets.only(left: 10.w),
                            height: 30.h,
                            width: 125.w,
                            decoration: BoxDecoration(
                                color: Color(0xff21034F),
                                borderRadius: BorderRadius.circular(35.sp)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: 12.sp,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  "ADD TO CART",
                                  style: primaryTextStyle(
                                      weight: FontWeight.w700,
                                      color: Colors.white,
                                      size: 9.sp.round()),
                                )
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              )
            : placeHolderWidget(),
      ),
    );
  }
}

buildProductShowAll(getProductsInSection) {
  return GestureDetector(
    onTap: () {
      getProductsInSection();
    },
    child: Container(
      margin: EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: -3, blurRadius: 3),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 175.w,
            height: 210.h,
            child: placeHolderWidget(),
          ),
          SizedBox(
            height: 3.h,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 150.w,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Text(
                      "SHOW ALL",
                      overflow: TextOverflow.ellipsis,
                      style: primaryTextStyle(
                          weight: FontWeight.w700,
                          size: 16.sp.round(),
                          color: Colors.grey[500]),
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward, color: Colors.grey[500])
              ],
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Container(
            padding: EdgeInsets.only(left: 5.w),
            width: 150.w,
            child: Text(
              "",
              overflow: TextOverflow.ellipsis,
              style: primaryTextStyle(
                  weight: FontWeight.w300,
                  size: 14.sp.round(),
                  color: Color(0xff9B9B9B)),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Text(
              " ",
              style: primaryTextStyle(
                  weight: FontWeight.w600,
                  size: 15.sp.round(),
                  color: Color(0xff370269)),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    ),
  );
}

enum FilterTypeEnum {
  Colors,
  Brands,
  Style,
  Season,
  Materials,
  Sizes,
  Price,
  Collection

  // Add more animation states as needed
}

List<Widget> buildChildren(FilterTypeEnum filterName,
    CustomSearchController my_search_controller, context) {
  switch (filterName) {
    case FilterTypeEnum.Sizes:
      return [
        Text(
          "Size",
          style: primaryTextStyle(size: 20.sp.round(), color: Colors.black),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Obx(() {
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 15,
                crossAxisSpacing: 10,
                // width / height: fixed for *all* items
                childAspectRatio: (1 / .8),
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    my_search_controller
                        .addOrRemoveSize(my_search_controller.sizes[index]);
                  },
                  child: Obx(() {
                    return Container(
                      padding: EdgeInsets.all(2.w),
                      width: 70.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                          color: my_search_controller.selectedSizes
                                  .contains(my_search_controller.sizes[index])
                              ? Color(0xffE7D3FF)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.sp)),
                      child: Center(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          my_search_controller.sizes[index],
                          style: primaryTextStyle(
                              size: 10.sp.round(), color: Colors.black),
                        ),
                      ),
                    );
                  }),
                );
              },
              itemCount: my_search_controller.sizes.length,
            );
          }),
          // Add more widgets as needed
        ),
      ];

    case FilterTypeEnum.Colors:
      return [
        Text(
          "Color",
          style: primaryTextStyle(
              size: 20.sp.round(),
              color: Colors.black,
              weight: FontWeight.w500),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Obx(() {
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 40,
                crossAxisSpacing: 24,
                // width / height: fixed for *all* items
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final Color colorFromHex =
                    HexColor.fromHex(my_search_controller.colors[index].hex!);

                return index != 4
                    ? GestureDetector(
                        onTap: () {
                          my_search_controller.addOrRemoveColor(
                              my_search_controller.colors[index]);
                        },
                        child: Obx(() {
                          return Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: my_search_controller.selectedColors
                                            .contains(my_search_controller
                                                .colors[index])
                                        ? Colors.black
                                        : Colors.grey[300]!,
                                    width: 4.w),
                                color: Colors.grey[200]),
                            child: Container(
                              height: 25.h,
                              width: 25.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(colorFromHex.value)),
                            ),
                          );
                        }),
                      )
                    : InkWell(
                        onTap: () {
                          my_search_controller.changeLength(
                              my_search_controller.colorFullLength);
                        },
                        child: Icon(my_search_controller.colorFullLength.value
                            ? Icons.keyboard_arrow_up_outlined
                            : Icons.keyboard_arrow_down_outlined),
                      );
              },
              itemCount: my_search_controller.colorFullLength.value
                  ? my_search_controller.colors.length
                  : 5,
            );
          }),
          // Add more widgets as needed
        )
      ];
    case FilterTypeEnum.Brands:
      return [
        Text(
          "Brands :",
          style: primaryTextStyle(size: 20.sp.round(), color: Colors.black),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Obx(() {
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 40,
                crossAxisSpacing: 24,
                // width / height: fixed for *all* items
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    my_search_controller
                        .addOrRemoveBrand(my_search_controller.brands[index]);
                  },
                  child: Obx(() {
                    return Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            border: Border.all(
                                width: 4.w,
                                color: my_search_controller.selectedBrands
                                        .contains(
                                            my_search_controller.brands[index])
                                    ? Colors.black
                                    : Colors.grey[300]!)),
                        child: CachedNetworkImage(
                          imageUrl: my_search_controller.brands[index].image!,
                          fit: BoxFit.cover,
                        ));
                  }),
                );
              },
              itemCount: my_search_controller.brands.length,
            );
          }),
          // Add more widgets as needed
        )
      ];

    case FilterTypeEnum.Style:
      return [
        Text(
          "Styles :",
          style: primaryTextStyle(size: 20.sp.round(), color: Colors.black),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Obx(() {
            return my_search_controller.styles.isEmpty
                ? Center(
                    child: Text(
                      "No Styles Yet..",
                      style: primaryTextStyle(
                          size: 20.sp.round(), color: Colors.black),
                    ),
                  )
                : GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 10,
                      // width / height: fixed for *all* items
                      childAspectRatio: (1 / .8),
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          my_search_controller.addOrRemoveStyle(
                              my_search_controller.styles[index]);
                        },
                        child: Obx(() {
                          return Container(
                            padding: EdgeInsets.all(2.w),
                            width: 70.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                                color: my_search_controller.selectedStyles
                                        .contains(
                                            my_search_controller.styles[index])
                                    ? Color(0xffE7D3FF)
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10.sp)),
                            child: Center(
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                my_search_controller.styles[index].name!,
                                style: primaryTextStyle(
                                    size: 10.sp.round(), color: Colors.black),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                    itemCount: my_search_controller.styles.length,
                  );
          }),
          // Add more widgets as needed
        )
      ];

    case FilterTypeEnum.Season:
      return [
        Text(
          "Season",
          style: primaryTextStyle(size: 20.sp.round(), color: Colors.black),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Obx(() {
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 15,
                crossAxisSpacing: 10,
                // width / height: fixed for *all* items
                childAspectRatio: (1 / .8),
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    my_search_controller
                        .addOrRemoveSeason(my_search_controller.seasons[index]);
                  },
                  child: Obx(() {
                    return Container(
                      padding: EdgeInsets.all(2.w),
                      width: 70.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                          color: my_search_controller.selectedSeasons
                                  .contains(my_search_controller.seasons[index])
                              ? Color(0xffE7D3FF)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.sp)),
                      child: Center(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          my_search_controller.seasons[index],
                          style: primaryTextStyle(
                              size: 10.sp.round(), color: Colors.black),
                        ),
                      ),
                    );
                  }),
                );
              },
              itemCount: my_search_controller.seasons.length,
            );
          }),
          // Add more widgets as needed
        ),
      ];

    case FilterTypeEnum.Materials:
      return [
        Text(
          "Materials :",
          style: primaryTextStyle(size: 20.sp.round(), color: Colors.black),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Obx(() {
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 15,
                crossAxisSpacing: 10,
                // width / height: fixed for *all* items
                childAspectRatio: (1 / .8),
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    my_search_controller.addOrRemoveMaterial(
                        my_search_controller.materials[index]);
                  },
                  child: Obx(() {
                    return Container(
                      padding: EdgeInsets.all(2.w),
                      width: 70.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                          color: my_search_controller.selectedMaterials
                                  .contains(
                                      my_search_controller.materials[index])
                              ? Color(0xffE7D3FF)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.sp)),
                      child: Center(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          my_search_controller.materials[index].name!,
                          style: primaryTextStyle(
                              size: 10.sp.round(), color: Colors.black),
                        ),
                      ),
                    );
                  }),
                );
              },
              itemCount: my_search_controller.materials.length,
            );
          }),
          // Add more widgets as needed
        ),
      ];

    case FilterTypeEnum.Price:
      return [
        Text(
          "Price",
          style: primaryTextStyle(size: 20.sp.round(), color: Colors.black),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Container(
              height: 130.h,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller:
                                  my_search_controller.minPriceController.value,
                              onChanged: (val) {
                                my_search_controller.setNewValue(RangeValues(
                                  double.parse(my_search_controller
                                      .minPriceController.value.text),
                                  my_search_controller
                                      .maxPriceController.value.text
                                      .toDouble(),
                                ));
                              },
                              maxLines: 1,
                              style: primaryTextStyle(
                                color: Colors.black,
                                size: 14.sp.round(),
                                weight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 17.h),
                                //Imp Line

                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.grey[300]!, width: 2)),

                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.grey[300]!, width: 2)),
                                hintStyle: primaryTextStyle(
                                  color: Colors.black,
                                  size: 14.sp.round(),
                                  weight: FontWeight.w400,
                                  height: 1,
                                ),
                                errorStyle: primaryTextStyle(
                                  color: Colors.red,
                                  size: 14.sp.round(),
                                  weight: FontWeight.w400,
                                  height: 1,
                                ),
                                labelStyle: primaryTextStyle(
                                  color: Colors.grey[400],
                                  size: 14.sp.round(),
                                  weight: FontWeight.w400,
                                  height: 1,
                                ),
                                labelText: "Min Price..",

                                prefixIcon: IconButton(
                                  icon: Padding(
                                      padding: EdgeInsets.only(left: 10.w),
                                      child: Icon(Icons.price_change)),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: TextField(
                              controller:
                                  my_search_controller.maxPriceController.value,
                              onChanged: (val) {
                                my_search_controller.setNewValue(RangeValues(
                                    my_search_controller
                                        .minPriceController.value.text
                                        .toDouble(),
                                    double.parse(my_search_controller
                                        .maxPriceController.value.text)));
                              },
                              maxLines: 1,
                              style: primaryTextStyle(
                                color: Colors.black,
                                size: 14.sp.round(),
                                weight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 17.h),
                                //Imp Line

                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.grey[300]!, width: 2)),

                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.grey[300]!, width: 2)),
                                hintStyle: primaryTextStyle(
                                  color: Colors.black,
                                  size: 14.sp.round(),
                                  weight: FontWeight.w400,
                                  height: 1,
                                ),
                                errorStyle: primaryTextStyle(
                                  color: Colors.red,
                                  size: 14.sp.round(),
                                  weight: FontWeight.w400,
                                  height: 1,
                                ),
                                labelStyle: primaryTextStyle(
                                  color: Colors.grey[400],
                                  size: 14.sp.round(),
                                  weight: FontWeight.w400,
                                  height: 1,
                                ),
                                labelText: "Max Price..",
                                prefixIcon: IconButton(
                                  icon: Padding(
                                      padding: EdgeInsets.only(left: 10.w),
                                      child: Icon(Icons.price_change)),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  Expanded(
                    child: Obx(() {
                      return Container(
                        child: RangeSlider(
                            inactiveColor: Colors.grey[300],
                            activeColor: Colors.black,
                            min: 1.0,
                            max: 10000.0,
                            values: my_search_controller.settedValue.value,
                            onChanged: (value) {
                              my_search_controller.setNewValue(value);

                              print("new value is ${value}");
                            }),
                      );
                    }),
                  )
                ],
              ),
            )
            // Add more widgets as needed
            ),
      ];

    case FilterTypeEnum.Collection:
      return [
        Text(
          "Collections :",
          style: primaryTextStyle(size: 20.sp.round(), color: Colors.black),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Obx(() {
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 40,
                crossAxisSpacing: 24,
                // width / height: fixed for *all* items
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    my_search_controller.addOrRemoveCollection(
                        my_search_controller.collections[index]);
                  },
                  child: Obx(() {
                    return Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            border: Border.all(
                                width: 4.w,
                                color: my_search_controller.selectedCollections
                                        .contains(my_search_controller
                                            .collections[index])
                                    ? Colors.black
                                    : Colors.grey[300]!)),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 8,
                              child: CachedNetworkImage(
                                imageUrl: my_search_controller
                                    .collections[index].image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  my_search_controller.collections[index].name!,
                                  style: primaryTextStyle(size: 4.sp.round()),
                                ))
                          ],
                        ));
                  }),
                );
              },
              itemCount: my_search_controller.collections.length,
            );
          }),
          // Add more widgets as needed
        )
      ];
    // Handle other animation states similarly
    default:
      return []; // Return an empty list if no match
  }
}

buildFilterBottomSheet(
    {List<ViewProductData>? comingProducts, required BuildContext context}) {
  List<ViewProductData> filteredProducts = [];
  CustomSearchController my_search_controller =
      CustomSearchController().initialized
          ? Get.find<CustomSearchController>()
          : Get.put(CustomSearchController());

  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  final ScrollController scrollController = ScrollController();

  // print("before setting sized ${comingProduct.sizes}");

  return Container(
      height: MediaQuery.of(context).size.height - 50.h,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 1.0,
          ),
          BoxShadow(color: Colors.white70, offset: Offset(0, -1)),
          BoxShadow(color: Colors.white70, offset: Offset(0, 1)),
          BoxShadow(color: Colors.white70, offset: Offset(-1, -1)),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white12,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                      "assets/images/forgot_password/BackBTN.svg"),
                ),
              ),
              Expanded(
                flex: 8,
                child: Center(
                  child: Text("Filters",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: fontCormoantFont,
                          fontWeight: FontWeight.w700,
                          fontSize: 22.sp)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      my_search_controller.clearSelectedFilters();
                    },
                    child: Text("Reset",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: fontCormoantFont,
                            fontWeight: FontWeight.w700,
                            color: Colors.orange,
                            fontSize: 18.sp)),
                  ),
                ),
              ),
            ]),
          ),
        ),
        body: CustomScrollView(controller: scrollController, slivers: [
          SliverList.list(
            children: [
              Obx(() {
                return Container(
                  height: MediaQuery.of(context).size.height - 200.h,
                  child: my_search_controller.isFilterLoading.value
                      ? loadingIndicatorWidget()
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),

                                  ///////////////////Price//////////////////////////////
                                  buildFilterItem(FilterTypeEnum.Price, context,
                                      my_search_controller),

                                  ///////////////////Color//////////////////////////////
                                  buildFilterItem(FilterTypeEnum.Colors,
                                      context, my_search_controller),
                                  ///////////////////Brand//////////////////////////////

                                  buildFilterItem(FilterTypeEnum.Brands,
                                      context, my_search_controller),
                                  ///////////////////Styles//////////////////////////////

                                  buildFilterItem(FilterTypeEnum.Style, context,
                                      my_search_controller),

                                  ///////////////////Collections//////////////////////////////
                                  buildFilterItem(FilterTypeEnum.Collection,
                                      context, my_search_controller),

                                  ///////////////////Season//////////////////////////////

                                  buildFilterItem(FilterTypeEnum.Season,
                                      context, my_search_controller),
                                  ///////////////////Materials//////////////////////////////
                                  buildFilterItem(FilterTypeEnum.Materials,
                                      context, my_search_controller),

                                  ///////////////////Sizes//////////////////////////////
                                  buildFilterItem(FilterTypeEnum.Sizes, context,
                                      my_search_controller),

                                  // MaterialButton(
                                  //   minWidth: MediaQuery.of(context).size.width,
                                  //
                                  //   height: 100.h,
                                  //   child: Text("Show Moree"),
                                  //   color: Color(0xff21034F),
                                  //   shape: RoundedRectangleBorder(),
                                  //   onPressed: () {},
                                  // )
                                ],
                              ),
                            ],
                          ),
                        ),
                );
              }),
            ],
          ),
        ]),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.all(
                  Size(MediaQuery.of(context).size.width - 200.w, 50.h)),
              backgroundColor: WidgetStateProperty.all(Color(0xff21034F)),
            ),
            onPressed: () {
              // Handle button press
              int _sizeIndex = 0;
              int _materialIndex = 0;
              int _styleIndex = 0;
              int _colorIndex = 0;
              int _seasonIndex = 0;
              int _brandIndex = 0;
              int _collectionIndex = 0;
              var payload = {};

              //handle price
              payload['min_price'] =
                  my_search_controller.minPriceController.value.text.toString();
              payload['max_price'] =
                  my_search_controller.maxPriceController.value.text.toString();

              //handle size
              for (var size in my_search_controller.selectedSizes) {
                payload['sizes[${_sizeIndex}]'] = size.toString();
                _sizeIndex++;
              }

              //handle material
              for (var material in my_search_controller.selectedMaterials) {
                payload['material_ids[${_materialIndex}]'] =
                    material.id.toString();
                _materialIndex++;
              }

              //handle styles
              for (var style in my_search_controller.selectedStyles) {
                payload['style_ids[${_styleIndex}]'] = style.id.toString();
                _materialIndex++;
              }

              //handle colors
              for (var color in my_search_controller.selectedColors) {
                payload['colors[${_colorIndex}]'] = color.name.toString();
                _colorIndex++;
              }

              //handle seasons
              for (var season in my_search_controller.selectedSeasons) {
                payload['seasons[${_seasonIndex}]'] = season.toString();
                _seasonIndex++;
              }

              //handle brands
              for (var brand in my_search_controller.selectedBrands) {
                payload['brand_ids[${_brandIndex}]'] = brand.id.toString();
                _brandIndex++;
              }

              //handle collections
              for (var collection in my_search_controller.selectedCollections) {
                payload['category_ids[${_collectionIndex}]'] =
                    collection.id.toString();
                _collectionIndex++;
              }

              my_search_controller.getProductsInSection(
                  sectionName: "Filter", payload: payload);

              _sizeIndex = 0;
              _materialIndex = 0;
              _styleIndex = 0;
              _colorIndex = 0;
              _seasonIndex = 0;
              _brandIndex = 0;
              _collectionIndex = 0;

              payload = {};
              my_search_controller.clearSelectedFilters();
              Get.to(() => const ResultView(),
                  transition: Transition.fadeIn,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 800));
            },
            child: const Text(
              'Show Items',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ));
}

buildFilterItem(FilterTypeEnum filterName, context,
    CustomSearchController my_search_controller) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15.w),
    child: Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.h,
            ),
            ...buildChildren(filterName, my_search_controller, context),
          ],
        ),
      ),
    ),
  );
}
