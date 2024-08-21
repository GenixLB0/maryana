import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maryana/app/modules/address/model/address_model.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:maryana/app/modules/global/config/map_view.dart';
import 'package:maryana/app/modules/product/views/product_view.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/main.dart';
import 'package:public_ip_address/public_ip_address.dart';

class AddressController extends GetxController {
  var addressList = <Address>[].obs;
  var isLoading = true.obs;

  var label = ''.obs;
  var kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  ).obs;
  var apartment = ''.obs;
  var floor = ''.obs;
  var building = ''.obs;
  var address = ''.obs;
  var phone = ''.obs;
  var city = ''.obs;
  var state = ''.obs;
  var latitude = ''.obs;
  var markers = <String, Marker>{}.obs;

  var longitude = ''.obs;
  var latLng = const LatLng(37.42796133580664, -122.085749655962).obs;
  var labelError = ''.obs;
  var apartmentError = ''.obs;
  var floorError = ''.obs;
  var buildingError = ''.obs;
  var addressError = ''.obs;
  RxString phoneError = ''.obs;
  var cityError = ''.obs;
  var stateError = ''.obs;
  var latitudeError = ''.obs;
  var longitudeError = ''.obs;
  GoogleMapController? mapController;
  var countriesList = <Country>[].obs;
  var selectedCountry = ''.obs;
  var selectedAddress = ''.obs;

  void fetchCountries() async {
    try {
      isLoading(true);
      final response = await apiConsumer.post('countries');
      countriesList.value = (response['data']['countries'] as List)
          .map((country) => Country.fromJson(country))
          .toList();
      selectedCountry.value =
          countriesList.isNotEmpty ? countriesList[0].name : '';
    } catch (e) {
      print('Failed to fetch countries: $e');
      Get.snackbar('Error', 'Failed to fetch countries');
    } finally {
      isLoading(false);
    }
  }

  void getCurrentLocation(context) async {
    AppConstants.showLoading(context);
    Position location = await Geolocator.getCurrentPosition();
    nextScreen(location, context);
  }

  Future<void> getPermission() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      _showLocationServicesDialog();
      _stopSpinner();
      return;
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      _showPermissionDeniedSnackbar();
      _stopSpinner();
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionDeniedForeverDialog();
      _stopSpinner();
      return;
    }

    _onPermissionGranted();
  }

  void _stopSpinner() {
    isLoading.value = false; // تغيير حالة التحميل إلى false لإيقاف المؤشر
  }

  void _showPermissionDeniedSnackbar() {
    Get.snackbar(
      "Permission Denied",
      "Location permission is required to access certain features.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showLocationServicesDialog() {
    Get.defaultDialog(
      title: "Location Services Disabled",
      middleText: "Please enable location services to use this feature.",
      textConfirm: "OK",
      onConfirm: () {
        Get.back();
      },
    );
  }

  void _showPermissionDeniedForeverDialog() {
    Get.defaultDialog(
      title: "Location Permission Denied Permanently",
      middleText:
          "You have permanently denied location permission. Please enable it from the app settings.",
      textConfirm: "OK",
      onConfirm: () {
        Get.back();
      },
    );
  }

  void _onPermissionGranted() {
    isLoading.value = false; // إيقاف التحميل عند الحصول على الإذن
    // تنفيذ الوظائف التي تعتمد على الموقع هنا
    debugPrint(
        'Location permission granted, proceeding with location features.');
  }

  @override
  void onReady() {
    super.onReady();
    // getPermission();
  }

  @override
  void onInit() {
    super.onInit();

    fetchAddresses();
    fetchCountries();
    label.value = 'Home';
    selectedCountry.value = "Lebanon";
    fetchCurrentLocation();
  }

  bool validateField(String field, RxString error) {
    if (field.isEmpty) {
      error.value = 'Field is required';
      return false;
    } else {
      error.value = '';
      return true;
    }
  }

  void fetchAddresses() async {
    if (userToken != null) {
      try {
        isLoading(true);
        final response = await apiConsumer.get('profile/address-list');
        addressList.value = (response['data']["addresses"] as List)
            .map((address) => Address.fromJson(address))
            .toList();
        try {
          // Attempt to find the address with the given condition
          Address address =
              addressList.firstWhere((address) => address.isDefault == 1);
          cartController.shippingID.value = address.id.toString();
          // Handle the found address
        } catch (e) {
          if (e is StateError) {
            // Handle the case where no address is found
            print('No address found matching the condition. ${e.toString()}');
          } else {
            // Handle any other errors
            print('An unexpected error occurred: $e');
          }
        }
      } catch (e, stackTrace) {
        print(e.toString() + " stackTrace" + stackTrace.toString());
        Get.snackbar('Error', 'Failed to fetch addresses');
      } finally {
        clearFieldsAndErrors();

        isLoading(false);
      }
    }
  }

  void addAddress() async {
    print('tsadsad');
    final newAddress = Address(
      id: 0,
      label: label.value,
      apartment: apartment.value,
      floor: floor.value,
      building: building.value,
      address: address.value,
      phone: phone.value,
      city: city.value,
      country: selectedCountry.value,
      state: state.value,
      latitude: latitude.value,
      longitude: longitude.value,
      isDefault: 0,
    );

    try {
      isLoading(true);
      final response = await apiConsumer.post(
        'profile/address-store',
        body: newAddress.toJson(),
      );
      print('tsadsad2');

      fetchAddresses();

      //addressList.add(Address.fromJson(response.data));
      Get.snackbar('Success', 'Address added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add address');
    } finally {
      isLoading(false);
    }
  }

  void actionSaveAddress(context, {Address? addresses}) {
    bool isEdit = addresses == null ? false : true;
    if (!validateField(label.value, labelError) ||
        !validateField(address.value, addressError) ||
        !validateField(phone.value, phoneError) ||
        !validateField(state.value, stateError)) {
      print('testasda');
      // for map view marker
      // if (!validateField(latitude.value, latitudeError) ||
      //     !validateField(longitude.value, longitudeError)) {
      //   showLocationPrompt(context);
      // }
      return;
    }

    if (isEdit) {
      print('testasda');

      updateAddress(addresses!);
    } else {
      print('testasdawww');

      addAddress();
    }

    Get.back();
    //clearFieldsAndErrors();
  }

  void showLocationPrompt(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select your current location',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Please select your current location on the map to proceed.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  getCurrentLocation(context);
                },
                child: Text('Select Location'),
              ),
            ],
          ),
        );
      },
    );
  }

  void fetchCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      latLng.value = LatLng(position.latitude, position.longitude);
      kGooglePlex.value = CameraPosition(target: latLng.value, zoom: 14.4746);
      setCustomMarker();
    } catch (e) {
      print("Error fetching location: $e");
    } finally {}
  }

  nextScreen(Position location, context) async {
    Get.to(MyMapView(
      location: latLng.value ?? LatLng(location.latitude, location.longitude),
    ))!
        .then((value) {
      AppConstants.hideLoading(context);
      if (value != null) {
        latLng.value = value;
        latitude.value = value.latitude.toString();
        longitude.value = value.longitude.toString();
        kGooglePlex.value = CameraPosition(
          target: latLng.value,
          zoom: 14.4746,
        );

        placemarkFromCoordinates(
                latLng.value!.latitude, latLng.value!.longitude)
            .then((valueAddress) {
          kGooglePlex.value = CameraPosition(
            target: latLng.value!,
            zoom: 14.4746,
          );
          mapController
              ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: latLng.value, // Your new LatLng
            zoom: 11.0,
          )));
          setCustomMarker();
          print(latLng.value!.latitude.toString() + ' kGooglePlex updated');
        });

        debugPrint(value.toString());
      }
    });
  }

  void onMapCreated(GoogleMapController controllers) async {
    mapController = controllers;
    setCustomMarker();
    mapController!.setMapStyle(AppConstants.mapStyle); // Set the map style
  }

  void setCustomMarker() async {
    final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 0.5, size: Size(5, 5)),
      'assets/images/location.png', // Replace with the location of your marker image in the assets folder.
    );

    // Define a marker with the custom icon
    final Marker marker = Marker(
      markerId: MarkerId('custom_marker'),
      position: latLng.value!,
      infoWindow: InfoWindow(title: 'Your location'),
      icon: markerIcon, // Custom marker icon
    );

    // Adding the marker to the map
    markers['custom_marker'] = marker;
  }

  void updateAddress(Address addressToUpdate) async {
    if (!validateField(label.value, labelError) ||
        !validateField(apartment.value, apartmentError) ||
        !validateField(phone.value, phoneError) ||
        !validateField(state.value, stateError)) {
      return;
    }

    final updatedAddress = Address(
      id: addressToUpdate.id,
      label: label.value,
      apartment: apartment.value,
      floor: floor.value,
      building: building.value,
      address: address.value,
      phone: phone.value,
      city: city.value,
      country: selectedCountry.value,
      state: state.value,
      latitude: latitude.value.isEmpty || latitude.value == null
          ? '33.888630'
          : latitude.value,
      longitude: longitude.value.isEmpty || longitude.value == null
          ? '35.495480'
          : longitude.value,
      isDefault: addressToUpdate.isDefault,
    );

    try {
      isLoading(true);
      await apiConsumer.post(
        'profile/address-update/${addressToUpdate.id}',
        body: updatedAddress.toJson(),
      );
      fetchAddresses();
      clearFieldsAndErrors();
      Get.snackbar('Success', 'Address updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update address');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      isLoading(true);
      await apiConsumer.delete('profile/address-delete/$id');
      bool isDefualt = addressList.any(
        (element) => element.isDefault == 1 && element.id == id,
      );
      if (isDefualt) cartController.shippingID.value = '';
      addressList.removeWhere((address) => address.id == id);
      Get.snackbar('Success', 'Address deleted successfully');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete address');
      Get.back();
    } finally {
      isLoading(false);
    }
  }

  void clearFieldsAndErrors() {
    label.value = 'Home';
    apartment.value = '';
    floor.value = '';
    building.value = '';
    address.value = '';
    phone.value = '';
    city.value = '';
    state.value = '';

    labelError.value = '';
    apartmentError.value = '';
    floorError.value = '';
    buildingError.value = '';
    addressError.value = '';
    phoneError.value = '';
    cityError.value = '';
    stateError.value = '';
    latitudeError.value = '';
    longitudeError.value = '';
  }

  void setDefaultAddress(int id) async {
    try {
      isLoading(true);
      await apiConsumer.post('profile/default-address', body: {'id': id});
      fetchAddresses();
      // Get.snackbar('Success', 'Default address set successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to set default address');
    } finally {
      isLoading(false);
    }
  }

  bool isFirstOpen = true;
}
