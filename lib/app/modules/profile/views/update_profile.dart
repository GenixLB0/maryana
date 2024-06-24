import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import '../controllers/profile_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For formatting date

class ProfileUpdate extends StatefulWidget {
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate>
    with SingleTickerProviderStateMixin {
  final ProfileController controller = Get.put(ProfileController());
  late TabController _tabController;
  TextEditingController dobController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Initialize dobController and selectedDate from userModel
    if (controller.userModel.value.dob != null &&
        controller.userModel.value.dob!.isNotEmpty) {
      selectedDate = DateTime.parse(controller.userModel.value.dob!);
      dobController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
    } else {
      selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Profile Setting",
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              SizedBox(height: 20.h),
              _buildProfileHeader(),
              SizedBox(height: 20.h),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    text: 'Update Info',
                  ),
                  Tab(text: 'Change Password'),
                ],
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildUpdateInfoForm(),
                    _buildChangePasswordForm(),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  final ImagePicker _picker = ImagePicker();

  onPickImage() async {
    imagesSourcesShowModel(
      context: context,
      onCameraPressed: () => _onCameraTapped(),
      onGalleryPressed: () => _onGalleryTapped(),
    );
  }

  _onCameraTapped() async {
    Navigator.pop(context);
    final XFile? xImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 88,
    );
    if (!mounted) return;
    if (xImage != null) {
      avatarImageFile = File(xImage.path);
      controller.updatePhoto(avatarImageFile!.path);
    }
  }

  File? avatarImageFile;
  _onGalleryTapped() async {
    Navigator.pop(context);
    final XFile? xImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
    );
    if (!mounted) return;
    if (xImage != null) {
      avatarImageFile = File(xImage.path);
      controller.updatePhoto(avatarImageFile!.path);
    }
  }

  Widget _buildProfileHeader() {
    return SizedBox(
        width: 103.11.w,
        height: 108.97.h,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 48.r,
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
                        radius: 48.r,
                        backgroundImage: const AssetImage(
                            'assets/images/profile/profile_placeholder.png'),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 22.r,
                          ),
                        ),
                      ),
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 46.r,
                        backgroundImage: imageProvider,
                      ),
                    ),
            ),
            ShowUp(
                delay: 400,
                child: Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: InkWell(
                        onTap: () => onPickImage(),
                        child: SvgPicture.asset(
                          'assets/images/profile/camera.svg',
                          width: 42.20.w,
                          height: 42.20.h,
                        ))))
          ],
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        controller.userModel.value.dob = dobController.text;
      });
    }
  }

  Widget _buildUpdateInfoForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              ShowUp(
                delay: 400,
                child: CustomTextField(
                  initialValue: controller.userModel.value.firstName,
                  labelText: 'First Name',
                  onChanged: (value) =>
                      controller.userModel.value.firstName = value,
                  errorText: controller.firstNameError.value.isEmpty
                      ? null
                      : controller.firstNameError.value,
                ),
              ),
              SizedBox(height: 20.h),
              ShowUp(
                delay: 400,
                child: CustomTextField(
                  initialValue: controller.userModel.value.lastName,
                  labelText: 'Last Name',
                  onChanged: (value) =>
                      controller.userModel.value.lastName = value,
                  errorText: controller.lastNameError.value.isEmpty
                      ? null
                      : controller.lastNameError.value,
                ),
              ),
              SizedBox(height: 20.h),
              ShowUp(
                  delay: 400,
                  child: SizedBox(
                      width: 310.w,
                      child: Row(
                        children: [
                          Flexible(
                              flex: 2,
                              child: CustomTextField(
                                initialValue:
                                    controller.userModel.value.phone ??
                                        '(+961) 123321',
                                labelText: 'Phone',
                                onChanged: (value) =>
                                    controller.userModel.value.phone = value,
                                errorText: controller.phoneError.value.isEmpty
                                    ? null
                                    : controller.phoneError.value,
                              )),
                          SizedBox(
                            width: 10.w,
                          ),
                          // Date of Birth Picker
                          Flexible(
                              flex: 2,
                              child: TextFormField(
                                controller: dobController,
                                readOnly: true,
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
                                  labelText: 'Date of Birth',
                                  suffixIcon: Icon(
                                    Icons.calendar_today,
                                    size: 20.sp,
                                  ),
                                ),
                                onTap: () => _selectDate(context),
                              ))
                        ],
                      ))),
              SizedBox(height: 121.h),
              MySecondDefaultButton(
                onPressed: () {
                  bool isFirstNameValid = controller
                      .validateFirstName(controller.userModel.value.firstName!);
                  bool isLastNameValid = controller
                      .validateLastName(controller.userModel.value.lastName!);
                  bool isPhoneValid = controller
                      .validatePhone(controller.userModel.value.phone!);
                  bool isDobValid = controller.validateDob(dobController.text);

                  if (isFirstNameValid &&
                      isLastNameValid &&
                      isPhoneValid &&
                      isDobValid) {
                    var data = controller.userModel.value.toJson();
                    controller.updateUserProfile(data);
                  } else {
                    // Trigger UI updates to show error messages
                    setState(() {});
                  }
                },
                btnText: 'Save Change',
                isloading: controller.isLoading.value,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              CustomTextField(
                labelText: 'Old Password',
                onChanged: (value) {
                  controller.oldPassword.value = value;
                  controller.validatePassword(value);
                },
                errorText: controller.passwordError.value.isEmpty
                    ? null
                    : controller.passwordError.value,
                obscureText: true,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                labelText: 'New Password',
                onChanged: (value) {
                  controller.newPassword.value = value;
                  controller.validateNewPassword(value);
                },
                errorText: controller.newPasswordError.value.isEmpty
                    ? null
                    : controller.newPasswordError.value,
                obscureText: true,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                labelText: 'Confirm Password',
                onChanged: (value) {
                  controller.confirmPassword.value = value;
                  controller.validateConfirmPassword(
                      value, controller.newPassword.value);
                },
                errorText: controller.confirmPasswordError.value.isEmpty
                    ? null
                    : controller.confirmPasswordError.value,
                obscureText: true,
              ),
              SizedBox(height: 121.h),
              MySecondDefaultButton(
                onPressed: () {
                  bool isOldPasswordValid =
                      controller.validatePassword(controller.oldPassword.value);
                  bool isNewPasswordValid = controller
                      .validateNewPassword(controller.newPassword.value);
                  bool isConfirmPasswordValid =
                      controller.validateConfirmPassword(
                          controller.confirmPassword.value,
                          controller.newPassword.value);

                  if (isOldPasswordValid &&
                      isNewPasswordValid &&
                      isConfirmPasswordValid) {
                    var data = {
                      'old_password': controller.oldPassword.value,
                      'password': controller.newPassword.value,
                      'password_confirmation': controller.confirmPassword.value,
                    };

                    controller.updatePassword(data);
                    controller.oldPassword.value = '';
                    controller.newPassword.value = '';
                    controller.confirmPassword.value = '';
                  } else {
                    // Trigger UI updates to show error messages
                    setState(() {});
                  }
                },
                isloading: controller.isLoading.value,
                btnText: 'Change Password',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
