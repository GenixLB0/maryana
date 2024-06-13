import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:nb_utils/nb_utils.dart';

Widget gridSocialIcon() {
  return   Row(
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
  final bool obscureText;
  final String? icon;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.onChanged,
    this.errorText,
    this.obscureText = false,
    this.icon,
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
      width: 310.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: widget.onChanged,
            obscureText: _obscureText,
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
                color: Colors.black,
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
                        width: 24.w,
                        height: 24.h,
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
      leading: function != null && !Navigator.canPop(context)
          ? IconButton(
              icon: SvgPicture.asset(
                'assets/icons/back.svg',
                width: 36.w,
                height: 36.h,
              ),
              onPressed: () {
                if (function != null) {
                  function!();
                } else {
                  Get.back();
                }
              },
            )
          : SizedBox(),
      title: Center(
        child: Text(
          title ?? '',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      actions: actions ?? [Container()],
      centerTitle: true,
      backgroundColor: const Color(0xffFDFDFD),
    );
  }
}
