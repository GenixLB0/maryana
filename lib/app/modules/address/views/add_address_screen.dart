import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maryana/app/modules/address/controllers/address_controller.dart';
import 'package:maryana/app/modules/address/model/address_model.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:maryana/app/modules/global/config/map_view.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
 

class AddAddressScreen extends GetView<AddressController> {
  Position? location;
  final bool? viewsOnly;
  AddAddressScreen({super.key, this.viewsOnly}) {
    controller.fetchCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: viewsOnly == null || viewsOnly == false
          ? const CustomAppBar(
              title: "Add Delivery address",
            )
          : null,
      backgroundColor: viewsOnly == null || viewsOnly == false
          ? null
          : const Color(0xffFDFDFD),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (viewsOnly != null && viewsOnly != false)
                  SizedBox(
                    width: 375.10.w,
                    child: Text(
                      'Delivery Address',
                      style: secondaryTextStyle(
                        color: Colors.black,
                        size: 16.sp.round(),
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 15.h,
                ),
                Obx(() => SizedBox(
                    width: 310.w,
                    child: InputDecorator(
                      decoration: InputDecoration(),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          underline: Container(
                            width: 310.w,
                            height: 1,
                            color: const Color(0xFFA6AAC3),
                          ),
                          isDense: true,
                          value: controller.label.value.isEmpty
                              ? 'Home'
                              : controller.label.value,
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            controller.label.value = newValue!;
                          },
                          items: <String>['Work', 'Home']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: primaryTextStyle(
                                  color: const Color(0xFFA6AAC3),
                                  size: 14.sp.round(),
                                  weight: FontWeight.w400,
                                  height: 1,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ))),
                SizedBox(
                  height: 15.h,
                ),
                SizedBox(
                    width: 310.w,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              flex: 1,
                              child: Obx(() => CustomTextField(
                                    labelText: 'Apartment',
                                    onChanged: (value) {
                                      controller.apartment.value = value;
                                      controller.validateField(
                                          value, controller.apartmentError);
                                    },
                                    errorText:
                                        controller.apartmentError.value.isEmpty
                                            ? null
                                            : controller.apartmentError.value,
                                  ))),
                          SizedBox(
                            width: 10.h,
                          ),
                          Flexible(
                              flex: 1,
                              child: Obx(() => CustomTextField(
                                    labelText: 'Floor',
                                    keyboardType: TextInputType
                                        .number, // For numeric input
                                    onChanged: (value) {
                                      controller.floor.value = value;
                                      controller.validateField(
                                          value, controller.floorError);
                                    },
                                    errorText:
                                        controller.floorError.value.isEmpty
                                            ? null
                                            : controller.floorError.value,
                                  ))),
                          SizedBox(
                            width: 10.w,
                          ),
                          Flexible(
                              flex: 1,
                              child: Obx(() => CustomTextField(
                                    labelText: 'Building',
                                    onChanged: (value) {
                                      controller.building.value = value;

                                      controller.validateField(
                                          value, controller.buildingError);
                                    },
                                    errorText:
                                        controller.buildingError.value.isEmpty
                                            ? null
                                            : controller.buildingError.value,
                                  )))
                        ])),
                SizedBox(
                  height: 15.h,
                ),
                Obx(() => CustomTextField(
                      labelText: 'Address *',
                      onChanged: (value) {
                        controller.address.value = value;
                        controller.validateField(
                            value, controller.addressError);
                      },
                      errorText: controller.addressError.value.isEmpty
                          ? null
                          : controller.addressError.value,
                    )),
                SizedBox(
                  height: 15.h,
                ),
                Obx(() => CustomTextField(
                      labelText: 'Phone *',
                      keyboardType: TextInputType.phone, // For numeric input

                      onChanged: (value) {
                        controller.phone.value = value;
                        controller.validateField(value, controller.phoneError);
                      },
                      errorText: controller.phoneError.value.isEmpty
                          ? null
                          : controller.phoneError.value,
                    )),
                SizedBox(
                  height: 15.h,
                ),
                SizedBox(
                    width: 310.w,
                    child: Obx(() => InputDecorator(
                          decoration: InputDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              underline: Container(
                                height: 1,
                                color: const Color(0xFFA6AAC3),
                              ),
                              isDense: true,
                              value: controller.selectedCountry.value,
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                controller.selectedCountry.value = newValue!;
                              },
                              items: controller.countriesList
                                  .map<DropdownMenuItem<String>>(
                                      (Country country) {
                                return DropdownMenuItem<String>(
                                  value: country.name,
                                  child: Text(
                                    country.name,
                                    style: primaryTextStyle(
                                      color: const Color(0xFFA6AAC3),
                                      size: 14.sp.round(),
                                      weight: FontWeight.w400,
                                      height: 1,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ))),
                SizedBox(
                  height: 15.h,
                ),
                SizedBox(
                    width: 310.w,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              flex: 2,
                              child: Obx(() => CustomTextField(
                                    labelText: 'State *',
                                    onChanged: (value) {
                                      controller.state.value = value;
                                      controller.validateField(
                                          value, controller.stateError);
                                    },
                                    errorText:
                                        controller.stateError.value.isEmpty
                                            ? null
                                            : controller.stateError.value,
                                  ))),
                          SizedBox(
                            width: 10.w,
                          ),
                          Flexible(
                              flex: 2,
                              child: CustomTextField(
                                labelText: 'City',
                                onChanged: (value) {
                                  controller.city.value = value;
                                  //   controller.validateField(value, controller.cityError);
                                },
                              )),
                        ])),
                SizedBox(
                  height: 15.h,
                ),
                Obx(() => controller.kGooglePlex.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        child: InkWell(
                            onTap: () {
                              controller.getCurrentLocation(context);
                            },
                            child: Container(
                                width: 326.w,
                                height: 243.h,
                                child: Stack(children: [
                                  Obx(() => GoogleMap(
                                        onMapCreated: controller.onMapCreated,
                                        initialCameraPosition:
                                            controller.kGooglePlex.value,
                                        markers:
                                            controller.markers.values.toSet(),
                                      )),
                                  Align(
                                      alignment:
                                          AlignmentDirectional.bottomStart,
                                      child: Container(
                                          width: 327.w,
                                          height: 50.h,
                                          color: const Color(0xFFFFFFff)
                                              .withOpacity(0.5),
                                          child: Center(
                                            child: Text(
                                              'Select on the map',
                                              style: primaryTextStyle(
                                                size: 10.sp.round(),
                                                color: const Color(0xff252b5c),
                                                letterSpacing: 0.3,
                                                height: 1.7,
                                              ),
                                              textAlign: TextAlign.center,
                                              softWrap: false,
                                            ),
                                          ))),
                                ]))))
                    : SizedBox()),
                SizedBox(height: 20.h),
                Obx(() => MySecondDefaultButton(
                      isloading: controller.isLoading.value,
                      onPressed: () {
                        controller.actionSaveAddress(context);
                      },
                      btnText: 'Save Address',
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
