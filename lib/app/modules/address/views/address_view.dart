import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maryana/app/modules/address/controllers/address_controller.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'edit_address_screen.dart';
import 'add_address_screen.dart';

class AddressListScreen extends StatelessWidget {
  final bool? viewOnly;
  final AddressController addressController = Get.put(AddressController());

  AddressListScreen({super.key, this.viewOnly});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: viewOnly == null || viewOnly == false
          ? const CustomAppBar(
              title: "Delivery address",
            )
          : null,
      backgroundColor: viewOnly == null || viewOnly == false
          ? null
          : const Color(0xffFDFDFD),
      body: Obx(() {
        if (addressController.isLoading.value) {
          return MainLoading();
        } else if (addressController.addressList.isEmpty) {
          return Center(
            child: Padding(
                padding: EdgeInsets.all(20.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowUp(
                          delay: 200,
                          child: Image.asset(
                            'assets/images/profile/emptyAddress.jpg', // Replace with your own illustration asset
                            height: 150.h,
                          )),
                      SizedBox(height: 20.h),
                      Text(
                        'No addresses found.',
                        style: primaryTextStyle(
                          size: 20.sp.round(),
                          weight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Please add a new address to proceed.',
                        style: primaryTextStyle(
                          size: 16.sp.round(),
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30.h),
                      ElevatedButton(
                        onPressed: () {
                          if (viewOnly == null || viewOnly == false) {
                            Get.to(() => AddAddressScreen());
                          } else {
                            Get.dialog(
                              Scaffold(
                                backgroundColor: Colors.transparent,
                                body: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: 375.w,
                                    height: 0.6.sh,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 40.h),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x3FABABAB),
                                          blurRadius: 11,
                                          offset: Offset(0, -4),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child:
                                        AddAddressScreen(viewsOnly: viewOnly),
                                  ),
                                ),
                              ),
                              barrierDismissible: true,
                              useSafeArea: true,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.w, vertical: 15.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Add New Address',
                          style: primaryTextStyle(
                            size: 16.sp.round(),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          );
        } else {
          return Center(
              child: Padding(
                  padding: EdgeInsetsDirectional.only(
                      top: viewOnly != null && viewOnly != false
                          ? 0
                          : 53.h - 28.h,
                      bottom: 20.h),
                  child: SizedBox(
                      width: 315.w,
                      child: ListView.builder(
                        itemCount: addressController.addressList.length,
                        itemBuilder: (context, index) {
                          final address = addressController.addressList[index];
                          return ShowUp(
                            delay: 200 * index,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                  top: viewOnly != null && viewOnly != false
                                      ? 5
                                      : 28.h),
                              child: Container(
                                  width: 315.w,
                                  height: 110.h,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Color(0xFFF4F4F4)),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x330E0E0E),
                                        blurRadius: 13,
                                        offset: Offset(0, 4),
                                        spreadRadius: -8,
                                      )
                                    ],
                                  ),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 8.w),
                                        Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                top: 10.h),
                                            child: Transform.scale(
                                              scale: (16 / 16)
                                                  .sp, // Adjusted scale
                                              child: Radio<bool>(
                                                value: address.isDefault == 1,
                                                groupValue: true,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith<Color?>(
                                                  (Set<MaterialState> states) {
                                                    if (states.contains(
                                                        MaterialState
                                                            .selected)) {
                                                      return Colors.black;
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                onChanged: (value) {
                                                  addressController
                                                      .setDefaultAddress(
                                                          address.id);
                                                },
                                              ),
                                            )),
                                        SizedBox(
                                            width: 0
                                                .w), // Space between radio and icon
                                        Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                top: 22.h),
                                            child: SvgPicture.asset(
                                              'assets/images/profile/home.svg',
                                              width: 30.w,
                                              height: 30.h,
                                            )), // Example icon, replace with your own
                                        SizedBox(
                                            width: 14
                                                .w), // Space between icon and text
                                        Expanded(
                                            child: Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              top: 18.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('SEND TO',
                                                  style: primaryTextStyle(
                                                    color: Color(0xFF22262E),
                                                    size: 12.sp.round(),
                                                    weight: FontWeight.w400,
                                                  )),
                                              Text('${address.label}',
                                                  style: primaryTextStyle(
                                                    color: Colors.black,
                                                    size: 14.sp.round(),
                                                    weight: FontWeight.w400,
                                                  )),
                                            ],
                                          ),
                                        )),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.to(() => EditAddressScreen(
                                                    address: address));
                                              },
                                              child: Text(
                                                'Edit',
                                                style: primaryTextStyle(
                                                  color:
                                                      const Color(0xFFF70000),
                                                  size: 12.sp.round(),
                                                  weight: FontWeight.w400,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),

                                            SizedBox(
                                                width: 8
                                                    .w), // Space between text and delete icon
                                            IconButton(
                                              icon: Icon(Icons.delete,
                                                  size: 20.sp),
                                              onPressed: () {
                                                Get.dialog(
                                                  AlertDialog(
                                                    title: Text(
                                                      'Delete Address',
                                                      style: primaryTextStyle(
                                                          size: 16.sp.round()),
                                                    ),
                                                    content: Text(
                                                      'Are you sure you want to delete this address?',
                                                      style: primaryTextStyle(
                                                          size: 14.sp.round()),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                          bool isClosed =
                                                              Get.isDialogOpen ??
                                                                  false;
                                                          if (isClosed) {
                                                            Get.back();
                                                            print(
                                                                "Dialog closed without deletion");
                                                          } else {
                                                            print(
                                                                "Failed to close dialog");
                                                          }
                                                        },
                                                        child: Text(
                                                          'No',
                                                          style: TextStyle(
                                                              fontSize: 14.sp),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          addressController
                                                              .deleteAddress(
                                                                  address.id);
                                                          bool isClosed =
                                                              Get.isDialogOpen ??
                                                                  false;
                                                          if (isClosed) {
                                                            Get.back();
                                                            print(
                                                                "Dialog closed without deletion");
                                                          } else {
                                                            print(
                                                                "Failed to close dialog");
                                                          }
                                                          print(
                                                              "Address deleted");
                                                        },
                                                        child: Text(
                                                          'Yes',
                                                          style:
                                                              primaryTextStyle(
                                                                  size: 14
                                                                      .sp
                                                                      .round()),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  barrierDismissible:
                                                      false, // Prevents dialog from being dismissed by tapping outside
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 17.h,
                                    ),
                                    Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            start: 55.h),
                                        child: ShowUp(
                                            delay: 600,
                                            child: SizedBox(
                                              width: 305,
                                              child: Text(
                                                address.address,
                                                style: primaryTextStyle(
                                                  color: Color(0xFF777E90),
                                                  size: 12.round(),
                                                  weight: FontWeight.w400,
                                                ),
                                              ),
                                            )))
                                  ])),
                            ),
                          );
                        },
                      ))));
        }
        ;
      }),
      floatingActionButton: Obx(() {
        if (addressController.addressList.isNotEmpty) {
          return FloatingActionButton(
            onPressed: () {
              Get.to(() => AddAddressScreen());
            },
            child: Icon(Icons.add),
          );
        } else {
          return const SizedBox
              .shrink(); // Returns an empty widget when the list is empty
        }
      }),
    );
  }
}
