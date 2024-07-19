import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maryana/app/modules/address/controllers/address_controller.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:maryana/app/modules/global/config/map_view.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddAddressScreen extends GetView<AddressController> {
  Position? location;
  AddAddressScreen() {
    controller.fetchCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Add Delivery address",
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => CustomTextField(
                      labelText: 'Label *',
                      onChanged: (value) {
                        controller.label.value = value;
                        controller.validateField(value, controller.labelError);
                      },
                      errorText: controller.labelError.value.isEmpty
                          ? null
                          : controller.labelError.value,
                    )),
                SizedBox(
                  height: 15.h,
                ),
                Obx(() => CustomTextField(
                      labelText: 'Apartment *',
                      onChanged: (value) {
                        controller.apartment.value = value;
                        controller.validateField(
                            value, controller.apartmentError);
                      },
                      errorText: controller.apartmentError.value.isEmpty
                          ? null
                          : controller.apartmentError.value,
                    )),
                SizedBox(
                  height: 15.h,
                ),
                Obx(() => CustomTextField(
                      labelText: 'Floor *',
                      keyboardType: TextInputType.number, // For numeric input
                      onChanged: (value) {
                        controller.floor.value = value;
                        controller.validateField(value, controller.floorError);
                      },
                      errorText: controller.floorError.value.isEmpty
                          ? null
                          : controller.floorError.value,
                    )),
                SizedBox(
                  height: 15.h,
                ),
                Obx(() => CustomTextField(
                      labelText: 'Building *',
                      onChanged: (value) {
                        controller.building.value = value;

                        controller.validateField(
                            value, controller.buildingError);
                      },
                      errorText: controller.buildingError.value.isEmpty
                          ? null
                          : controller.buildingError.value,
                    )),
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
                Obx(() => CustomTextField(
                      labelText: 'City *',
                      onChanged: (value) {
                        controller.city.value = value;
                        controller.validateField(value, controller.cityError);
                      },
                      errorText: controller.cityError.value.isEmpty
                          ? null
                          : controller.cityError.value,
                    )),
                SizedBox(
                  height: 15.h,
                ),
                Obx(() => CustomTextField(
                      labelText: 'State *',
                      onChanged: (value) {
                        controller.state.value = value;
                        controller.validateField(value, controller.stateError);
                      },
                      errorText: controller.stateError.value.isEmpty
                          ? null
                          : controller.stateError.value,
                    )),
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