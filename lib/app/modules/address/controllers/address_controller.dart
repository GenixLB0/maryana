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
import 'package:maryana/main.dart';

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
  void getCurrentLocation(context) async {
    AppConstants.showLoading(context);
    Position location = await Geolocator.getCurrentPosition();
    nextScreen(location, context);
  }

  Future<void> getPermission() async {
    // var permission = await Permission.location.status;

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    await Geolocator.requestPermission();
    debugPrint('isLocationEnabled $isLocationEnabled');
    if (isLocationEnabled == false) {}
  }

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();

    fetchCurrentLocation();

    getPermission();
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
    try {
      isLoading(true);
      final response = await apiConsumer.get('profile/address-list');
      addressList.value = (response['data']["addresses"] as List)
          .map((address) => Address.fromJson(address))
          .toList();
    } catch (e, stackTrace) {
      print(e.toString() + " stackTrace" + stackTrace.toString());
      Get.snackbar('Error', 'Failed to fetch addresses');
    } finally {
      isLoading(false);
    }
  }

  void addAddress() async {
    final newAddress = Address(
      id: 0,
      label: label.value,
      apartment: apartment.value,
      floor: floor.value,
      building: building.value,
      address: address.value,
      phone: phone.value,
      city: city.value,
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
      fetchAddresses();
      clearFieldsAndErrors();

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
        !validateField(apartment.value, apartmentError) ||
        !validateField(floor.value, floorError) ||
        !validateField(building.value, buildingError) ||
        !validateField(address.value, addressError) ||
        !validateField(phone.value, phoneError) ||
        !validateField(city.value, cityError) ||
        !validateField(state.value, stateError)) {
      // for map view marker
      if (!validateField(latitude.value, latitudeError) ||
          !validateField(longitude.value, longitudeError)) {
        showLocationPrompt(context);
      }
      return;
    }
    if (isEdit) {
      updateAddress(addresses!);
    } else {
      addAddress();
    }

    Get.back();
    clearFieldsAndErrors();
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
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (_) => MyMapView(
          location:
              latLng.value ?? LatLng(location.latitude, location.longitude),
        ),
      ),
    )
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
        !validateField(floor.value, floorError) ||
        !validateField(building.value, buildingError) ||
        !validateField(address.value, addressError) ||
        !validateField(phone.value, phoneError) ||
        !validateField(city.value, cityError) ||
        !validateField(state.value, stateError) ||
        !validateField(latitude.value, latitudeError) ||
        !validateField(longitude.value, longitudeError)) {
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
      state: state.value,
      latitude: latitude.value,
      longitude: longitude.value,
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

  void deleteAddress(int id) async {
    try {
      isLoading(true);
      await apiConsumer.delete('profile/address-delete/$id');
      addressList.removeWhere((address) => address.id == id);
      Get.snackbar('Success', 'Address deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete address');
    } finally {
      isLoading(false);
    }
  }

  void clearFieldsAndErrors() {
    label.value = '';
    apartment.value = '';
    floor.value = '';
    building.value = '';
    address.value = '';
    phone.value = '';
    city.value = '';
    state.value = '';
    latitude.value = '';
    longitude.value = '';

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
}
