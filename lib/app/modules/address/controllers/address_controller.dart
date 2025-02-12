import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleapis/datastore/v1.dart' hide LatLng;
import 'package:maryana/app/modules/address/model/address_model.dart';
import 'package:maryana/app/modules/cart/controllers/cart_controller.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:maryana/app/modules/global/config/map_view.dart';
import 'package:maryana/app/modules/product/views/product_view.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/main.dart';
import 'package:public_ip_address/public_ip_address.dart';

class AddressController extends GetxController {
  RxList<Address> addressList = <Address>[].obs;
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
  List<Country> countriesList = <Country>[].obs;

  var selectedCountry = ''.obs;
  var selectedAddress = ''.obs;

  void fetchCountries() async {
    try {
      print("start fetching countries 1");
      isLoading(true);

      for (var country in worldCountries) {
        print("start fetching countries 4");
        countriesList.add(Country(
            name: country['name'],
            code: country['code'],
            phoneCode: country['phoneCode']));
      }
      print("start fetching countries 2");
      print("countriesList: ${countriesList.first}");
      // final response = await apiConsumer.post('countries');
      // countriesList.value = (response['data']['countries'] as List)
      //     .map((country) => Country.fromJson(country))
      //     .toList();
      // selectedCountry.value =
      //     countriesList.isNotEmpty ? countriesList[0].name : '';
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
    // fetchAddresses();
    // fetchCountries();
    // getPermission();
  }

  @override
  void onInit() {
    super.onInit();

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
          myDefaultAddressId.value = addressList.firstWhere((address) => address.isDefault == 1).id;
          Address address =
          addressList.firstWhere((address) => address.isDefault == 1);
          CartController newCartController = Get.find();
          newCartController.shippingID.value = address.id.toString();
          print("gotten country is : ${addressList.first.country}");
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
      Navigator.pop(Get.context!);
//       Get.snackbar('Success', 'Address added successfully');
// Get.back();
      fetchAddresses();

      //addressList.add(Address.fromJson(response.data));

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
      // Get.back();
      Navigator.pop(Get.context!);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete address');
      Navigator.pop(Get.context!);
      // Get.back();
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


RxInt myDefaultAddressId = 1.obs;
  void setDefaultAddress(int id) async {
    try {
      isLoading(true);
      await apiConsumer.post('profile/default-address', body: {'id': id});
      myDefaultAddressId.value = id;
      print("my custom address is ${myDefaultAddressId.value}");
      fetchAddresses();
      // Get.snackbar('Success', 'Default address set successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to set default address');
    } finally {
      isLoading(false);
    }
  }

  bool isFirstOpen = true;

  List<Map<String, String>> worldCountries = [
    {
      "name": "Afghanistan",
      "name_ar": "أفغانستان",
      "code": "AF",
      "phone_code": "+93"
    },
    {
      "name": "Albania",
      "name_ar": "ألبانيا",
      "code": "AL",
      "phone_code": "+355"
    },
    {
      "name": "Algeria",
      "name_ar": "الجزائر",
      "code": "DZ",
      "phone_code": "+213"
    },
    {
      "name": "Andorra",
      "name_ar": "أندورا",
      "code": "AD",
      "phone_code": "+376"
    },
    {"name": "Angola", "name_ar": "أنغولا", "code": "AO", "phone_code": "+244"},
    {
      "name": "Argentina",
      "name_ar": "الأرجنتين",
      "code": "AR",
      "phone_code": "+54"
    },
    {
      "name": "Armenia",
      "name_ar": "أرمينيا",
      "code": "AM",
      "phone_code": "+374"
    },
    {
      "name": "Australia",
      "name_ar": "أستراليا",
      "code": "AU",
      "phone_code": "+61"
    },
    {"name": "Austria", "name_ar": "النمسا", "code": "AT", "phone_code": "+43"},
    {
      "name": "Azerbaijan",
      "name_ar": "أذربيجان",
      "code": "AZ",
      "phone_code": "+994"
    },
    {
      "name": "Bahrain",
      "name_ar": "البحرين",
      "code": "BH",
      "phone_code": "+973"
    },
    {
      "name": "Bangladesh",
      "name_ar": "بنغلاديش",
      "code": "BD",
      "phone_code": "+880"
    },
    {
      "name": "Belarus",
      "name_ar": "بيلاروسيا",
      "code": "BY",
      "phone_code": "+375"
    },
    {"name": "Belgium", "name_ar": "بلجيكا", "code": "BE", "phone_code": "+32"},
    {"name": "Belize", "name_ar": "بليز", "code": "BZ", "phone_code": "+501"},
    {"name": "Benin", "name_ar": "بنين", "code": "BJ", "phone_code": "+229"},
    {"name": "Bhutan", "name_ar": "بوتان", "code": "BT", "phone_code": "+975"},
    {
      "name": "Bolivia",
      "name_ar": "بوليفيا",
      "code": "BO",
      "phone_code": "+591"
    },
    {
      "name": "Bosnia and Herzegovina",
      "name_ar": "البوسنة والهرسك",
      "code": "BA",
      "phone_code": "+387"
    },
    {
      "name": "Botswana",
      "name_ar": "بوتسوانا",
      "code": "BW",
      "phone_code": "+267"
    },
    {
      "name": "Brazil",
      "name_ar": "البرازيل",
      "code": "BR",
      "phone_code": "+55"
    },
    {"name": "Brunei", "name_ar": "بروناي", "code": "BN", "phone_code": "+673"},
    {
      "name": "Bulgaria",
      "name_ar": "بلغاريا",
      "code": "BG",
      "phone_code": "+359"
    },
    {
      "name": "Burkina Faso",
      "name_ar": "بوركينا فاسو",
      "code": "BF",
      "phone_code": "+226"
    },
    {
      "name": "Burundi",
      "name_ar": "بوروندي",
      "code": "BI",
      "phone_code": "+257"
    },
    {
      "name": "Cambodia",
      "name_ar": "كمبوديا",
      "code": "KH",
      "phone_code": "+855"
    },
    {
      "name": "Cameroon",
      "name_ar": "الكاميرون",
      "code": "CM",
      "phone_code": "+237"
    },
    {"name": "Canada", "name_ar": "كندا", "code": "CA", "phone_code": "+1"},
    {
      "name": "Cape Verde",
      "name_ar": "الرأس الأخضر",
      "code": "CV",
      "phone_code": "+238"
    },
    {
      "name": "Central African Republic",
      "name_ar": "جمهورية أفريقيا الوسطى",
      "code": "CF",
      "phone_code": "+236"
    },
    {"name": "Chad", "name_ar": "تشاد", "code": "TD", "phone_code": "+235"},
    {"name": "Chile", "name_ar": "تشيلي", "code": "CL", "phone_code": "+56"},
    {"name": "China", "name_ar": "الصين", "code": "CN", "phone_code": "+86"},
    {
      "name": "Colombia",
      "name_ar": "كولومبيا",
      "code": "CO",
      "phone_code": "+57"
    },
    {
      "name": "Comoros",
      "name_ar": "جزر القمر",
      "code": "KM",
      "phone_code": "+269"
    },
    {"name": "Congo", "name_ar": "الكونغو", "code": "CG", "phone_code": "+242"},
    {
      "name": "Costa Rica",
      "name_ar": "كوستاريكا",
      "code": "CR",
      "phone_code": "+506"
    },
    {
      "name": "Croatia",
      "name_ar": "كرواتيا",
      "code": "HR",
      "phone_code": "+385"
    },
    {"name": "Cuba", "name_ar": "كوبا", "code": "CU", "phone_code": "+53"},
    {"name": "Cyprus", "name_ar": "قبرص", "code": "CY", "phone_code": "+357"},
    {
      "name": "Czech Republic",
      "name_ar": "جمهورية التشيك",
      "code": "CZ",
      "phone_code": "+420"
    },
    {
      "name": "Denmark",
      "name_ar": "الدنمارك",
      "code": "DK",
      "phone_code": "+45"
    },
    {
      "name": "Djibouti",
      "name_ar": "جيبوتي",
      "code": "DJ",
      "phone_code": "+253"
    },
    {
      "name": "Dominica",
      "name_ar": "دومينيكا",
      "code": "DM",
      "phone_code": "+1-767"
    },
    {
      "name": "Dominican Republic",
      "name_ar": "جمهورية الدومينيكان",
      "code": "DO",
      "phone_code": "+1-809"
    },
    {
      "name": "Ecuador",
      "name_ar": "الإكوادور",
      "code": "EC",
      "phone_code": "+593"
    },
    {"name": "Egypt", "name_ar": "مصر", "code": "EG", "phone_code": "+20"},
    {
      "name": "El Salvador",
      "name_ar": "السلفادور",
      "code": "SV",
      "phone_code": "+503"
    },
    {
      "name": "Equatorial Guinea",
      "name_ar": "غينيا الاستوائية",
      "code": "GQ",
      "phone_code": "+240"
    },
    {
      "name": "Eritrea",
      "name_ar": "إريتريا",
      "code": "ER",
      "phone_code": "+291"
    },
    {
      "name": "Estonia",
      "name_ar": "إستونيا",
      "code": "EE",
      "phone_code": "+372"
    },
    {
      "name": "Eswatini",
      "name_ar": "إسواتيني",
      "code": "SZ",
      "phone_code": "+268"
    },
    {
      "name": "Ethiopia",
      "name_ar": "إثيوبيا",
      "code": "ET",
      "phone_code": "+251"
    },
    {"name": "Fiji", "name_ar": "فيجي", "code": "FJ", "phone_code": "+679"},
    {
      "name": "Finland",
      "name_ar": "فنلندا",
      "code": "FI",
      "phone_code": "+358"
    },
    {"name": "France", "name_ar": "فرنسا", "code": "FR", "phone_code": "+33"},
    {"name": "Gabon", "name_ar": "الغابون", "code": "GA", "phone_code": "+241"},
    {"name": "Gambia", "name_ar": "غامبيا", "code": "GM", "phone_code": "+220"},
    {
      "name": "Georgia",
      "name_ar": "جورجيا",
      "code": "GE",
      "phone_code": "+995"
    },
    {
      "name": "Germany",
      "name_ar": "ألمانيا",
      "code": "DE",
      "phone_code": "+49"
    },
    {"name": "Ghana", "name_ar": "غانا", "code": "GH", "phone_code": "+233"},
    {"name": "Greece", "name_ar": "اليونان", "code": "GR", "phone_code": "+30"},
    {
      "name": "Grenada",
      "name_ar": "غرينادا",
      "code": "GD",
      "phone_code": "+1-473"
    },
    {
      "name": "Guatemala",
      "name_ar": "غواتيمالا",
      "code": "GT",
      "phone_code": "+502"
    },
    {"name": "Guinea", "name_ar": "غينيا", "code": "GN", "phone_code": "+224"},
    {
      "name": "Guinea-Bissau",
      "name_ar": "غينيا بيساو",
      "code": "GW",
      "phone_code": "+245"
    },
    {"name": "Guyana", "name_ar": "غيانا", "code": "GY", "phone_code": "+592"},
    {"name": "Haiti", "name_ar": "هايتي", "code": "HT", "phone_code": "+509"},
    {
      "name": "Honduras",
      "name_ar": "هندوراس",
      "code": "HN",
      "phone_code": "+504"
    },
    {
      "name": "Hungary",
      "name_ar": "هنغاريا",
      "code": "HU",
      "phone_code": "+36"
    },
    {
      "name": "Iceland",
      "name_ar": "آيسلندا",
      "code": "IS",
      "phone_code": "+354"
    },
    {"name": "India", "name_ar": "الهند", "code": "IN", "phone_code": "+91"},
    {
      "name": "Indonesia",
      "name_ar": "إندونيسيا",
      "code": "ID",
      "phone_code": "+62"
    },
    {"name": "Iran", "name_ar": "إيران", "code": "IR", "phone_code": "+98"},
    {"name": "Iraq", "name_ar": "العراق", "code": "IQ", "phone_code": "+964"},
    {
      "name": "Ireland",
      "name_ar": "أيرلندا",
      "code": "IE",
      "phone_code": "+353"
    },
    {
      "name": "Israel",
      "name_ar": "إسرائيل",
      "code": "IL",
      "phone_code": "+972"
    },
    {"name": "Italy", "name_ar": "إيطاليا", "code": "IT", "phone_code": "+39"},
    {
      "name": "Jamaica",
      "name_ar": "جامايكا",
      "code": "JM",
      "phone_code": "+1-876"
    },
    {"name": "Japan", "name_ar": "اليابان", "code": "JP", "phone_code": "+81"},
    {"name": "Jordan", "name_ar": "الأردن", "code": "JO", "phone_code": "+962"},
    {
      "name": "Kazakhstan",
      "name_ar": "كازاخستان",
      "code": "KZ",
      "phone_code": "+7"
    },
    {"name": "Kenya", "name_ar": "كينيا", "code": "KE", "phone_code": "+254"},
    {
      "name": "Kiribati",
      "name_ar": "كيريباس",
      "code": "KI",
      "phone_code": "+686"
    },
    {"name": "Kuwait", "name_ar": "الكويت", "code": "KW", "phone_code": "+965"},
    {
      "name": "Kyrgyzstan",
      "name_ar": "قيرغيزستان",
      "code": "KG",
      "phone_code": "+996"
    },
    {"name": "Laos", "name_ar": "لاوس", "code": "LA", "phone_code": "+856"},
    {"name": "Latvia", "name_ar": "لاتفيا", "code": "LV", "phone_code": "+371"},
    {"name": "Lebanon", "name_ar": "لبنان", "code": "LB", "phone_code": "+961"},
    {
      "name": "Lesotho",
      "name_ar": "ليسوتو",
      "code": "LS",
      "phone_code": "+266"
    },
    {
      "name": "Liberia",
      "name_ar": "ليبيريا",
      "code": "LR",
      "phone_code": "+231"
    },
    {"name": "Libya", "name_ar": "ليبيا", "code": "LY", "phone_code": "+218"},
    {
      "name": "Liechtenstein",
      "name_ar": "ليختنشتاين",
      "code": "LI",
      "phone_code": "+423"
    },
    {
      "name": "Lithuania",
      "name_ar": "ليتوانيا",
      "code": "LT",
      "phone_code": "+370"
    },
    {
      "name": "Luxembourg",
      "name_ar": "لوكسمبورغ",
      "code": "LU",
      "phone_code": "+352"
    },
    {
      "name": "Madagascar",
      "name_ar": "مدغشقر",
      "code": "MG",
      "phone_code": "+261"
    },
    {"name": "Malawi", "name_ar": "مالاوي", "code": "MW", "phone_code": "+265"},
    {
      "name": "Malaysia",
      "name_ar": "ماليزيا",
      "code": "MY",
      "phone_code": "+60"
    },
    {
      "name": "Maldives",
      "name_ar": "المالديف",
      "code": "MV",
      "phone_code": "+960"
    },
    {"name": "Mali", "name_ar": "مالي", "code": "ML", "phone_code": "+223"},
    {"name": "Malta", "name_ar": "مالطا", "code": "MT", "phone_code": "+356"},
    {
      "name": "Marshall Islands",
      "name_ar": "جزر مارشال",
      "code": "MH",
      "phone_code": "+692"
    },
    {
      "name": "Mauritania",
      "name_ar": "موريتانيا",
      "code": "MR",
      "phone_code": "+222"
    },
    {
      "name": "Mauritius",
      "name_ar": "موريشيوس",
      "code": "MU",
      "phone_code": "+230"
    },
    {"name": "Mexico", "name_ar": "المكسيك", "code": "MX", "phone_code": "+52"},
    {
      "name": "Micronesia",
      "name_ar": "ميكرونيزيا",
      "code": "FM",
      "phone_code": "+691"
    },
    {
      "name": "Moldova",
      "name_ar": "مولدوفا",
      "code": "MD",
      "phone_code": "+373"
    },
    {"name": "Monaco", "name_ar": "موناكو", "code": "MC", "phone_code": "+377"},
    {
      "name": "Mongolia",
      "name_ar": "منغوليا",
      "code": "MN",
      "phone_code": "+976"
    },
    {
      "name": "Montenegro",
      "name_ar": "الجبل الأسود",
      "code": "ME",
      "phone_code": "+382"
    },
    {
      "name": "Morocco",
      "name_ar": "المغرب",
      "code": "MA",
      "phone_code": "+212"
    },
    {
      "name": "Mozambique",
      "name_ar": "موزمبيق",
      "code": "MZ",
      "phone_code": "+258"
    },
    {
      "name": "Myanmar",
      "name_ar": "ميانمار",
      "code": "MM",
      "phone_code": "+95"
    },
    {
      "name": "Namibia",
      "name_ar": "ناميبيا",
      "code": "NA",
      "phone_code": "+264"
    },
    {"name": "Nauru", "name_ar": "ناورو", "code": "NR", "phone_code": "+674"},
    {"name": "Nepal", "name_ar": "نيبال", "code": "NP", "phone_code": "+977"},
    {
      "name": "Netherlands",
      "name_ar": "هولندا",
      "code": "NL",
      "phone_code": "+31"
    },
    {
      "name": "New Zealand",
      "name_ar": "نيوزيلندا",
      "code": "NZ",
      "phone_code": "+64"
    },
    {
      "name": "Nicaragua",
      "name_ar": "نيكاراغوا",
      "code": "NI",
      "phone_code": "+505"
    },
    {"name": "Niger", "name_ar": "النيجر", "code": "NE", "phone_code": "+227"},
    {
      "name": "Nigeria",
      "name_ar": "نيجيريا",
      "code": "NG",
      "phone_code": "+234"
    },
    {
      "name": "North Korea",
      "name_ar": "كوريا الشمالية",
      "code": "KP",
      "phone_code": "+850"
    },
    {
      "name": "North Macedonia",
      "name_ar": "مقدونيا الشمالية",
      "code": "MK",
      "phone_code": "+389"
    },
    {"name": "Norway", "name_ar": "النرويج", "code": "NO", "phone_code": "+47"},
    {"name": "Oman", "name_ar": "عمان", "code": "OM", "phone_code": "+968"},
    {
      "name": "Pakistan",
      "name_ar": "باكستان",
      "code": "PK",
      "phone_code": "+92"
    },
    {"name": "Palau", "name_ar": "بالاو", "code": "PW", "phone_code": "+680"},
    {
      "name": "Palestine",
      "name_ar": "فلسطين",
      "code": "PS",
      "phone_code": "+970"
    },
    {"name": "Panama", "name_ar": "بنما", "code": "PA", "phone_code": "+507"},
    {
      "name": "Papua New Guinea",
      "name_ar": "بابوا غينيا الجديدة",
      "code": "PG",
      "phone_code": "+675"
    },
    {
      "name": "Paraguay",
      "name_ar": "باراغواي",
      "code": "PY",
      "phone_code": "+595"
    },
    {"name": "Peru", "name_ar": "بيرو", "code": "PE", "phone_code": "+51"},
    {
      "name": "Philippines",
      "name_ar": "الفلبين",
      "code": "PH",
      "phone_code": "+63"
    },
    {"name": "Poland", "name_ar": "بولندا", "code": "PL", "phone_code": "+48"},
    {
      "name": "Portugal",
      "name_ar": "البرتغال",
      "code": "PT",
      "phone_code": "+351"
    },
    {"name": "Qatar", "name_ar": "قطر", "code": "QA", "phone_code": "+974"},
    {
      "name": "Romania",
      "name_ar": "رومانيا",
      "code": "RO",
      "phone_code": "+40"
    },
    {"name": "Russia", "name_ar": "روسيا", "code": "RU", "phone_code": "+7"},
    {"name": "Rwanda", "name_ar": "رواندا", "code": "RW", "phone_code": "+250"},
    {
      "name": "Saint Kitts and Nevis",
      "name_ar": "سانت كيتس ونيفيس",
      "code": "KN",
      "phone_code": "+1-869"
    },
    {
      "name": "Saint Lucia",
      "name_ar": "سانت لوسيا",
      "code": "LC",
      "phone_code": "+1-758"
    },
    {
      "name": "Saint Vincent and the Grenadines",
      "name_ar": "سانت فنسنت وجزر غرينادين",
      "code": "VC",
      "phone_code": "+1-784"
    },
    {"name": "Samoa", "name_ar": "ساموا", "code": "WS", "phone_code": "+685"},
    {
      "name": "San Marino",
      "name_ar": "سان مارينو",
      "code": "SM",
      "phone_code": "+378"
    },
    {
      "name": "Sao Tome and Principe",
      "name_ar": "ساو تومي وبرينسيبي",
      "code": "ST",
      "phone_code": "+239"
    },
    {
      "name": "Saudi Arabia",
      "name_ar": "السعودية",
      "code": "SA",
      "phone_code": "+966"
    },
    {
      "name": "Senegal",
      "name_ar": "السنغال",
      "code": "SN",
      "phone_code": "+221"
    },
    {"name": "Serbia", "name_ar": "صربيا", "code": "RS", "phone_code": "+381"},
    {
      "name": "Seychelles",
      "name_ar": "سيشل",
      "code": "SC",
      "phone_code": "+248"
    },
    {
      "name": "Sierra Leone",
      "name_ar": "سيراليون",
      "code": "SL",
      "phone_code": "+232"
    },
    {
      "name": "Singapore",
      "name_ar": "سنغافورة",
      "code": "SG",
      "phone_code": "+65"
    },
    {
      "name": "Slovakia",
      "name_ar": "سلوفاكيا",
      "code": "SK",
      "phone_code": "+421"
    },
    {
      "name": "Slovenia",
      "name_ar": "سلوفينيا",
      "code": "SI",
      "phone_code": "+386"
    },
    {
      "name": "Solomon Islands",
      "name_ar": "جزر سليمان",
      "code": "SB",
      "phone_code": "+677"
    },
    {
      "name": "Somalia",
      "name_ar": "الصومال",
      "code": "SO",
      "phone_code": "+252"
    },
    {
      "name": "South Africa",
      "name_ar": "جنوب أفريقيا",
      "code": "ZA",
      "phone_code": "+27"
    },
    {
      "name": "South Korea",
      "name_ar": "كوريا الجنوبية",
      "code": "KR",
      "phone_code": "+82"
    },
    {
      "name": "South Sudan",
      "name_ar": "جنوب السودان",
      "code": "SS",
      "phone_code": "+211"
    },
    {"name": "Spain", "name_ar": "إسبانيا", "code": "ES", "phone_code": "+34"},
    {
      "name": "Sri Lanka",
      "name_ar": "سريلانكا",
      "code": "LK",
      "phone_code": "+94"
    },
    {"name": "Sudan", "name_ar": "السودان", "code": "SD", "phone_code": "+249"},
    {
      "name": "Suriname",
      "name_ar": "سورينام",
      "code": "SR",
      "phone_code": "+597"
    },
    {"name": "Sweden", "name_ar": "السويد", "code": "SE", "phone_code": "+46"},
    {
      "name": "Switzerland",
      "name_ar": "سويسرا",
      "code": "CH",
      "phone_code": "+41"
    },
    {"name": "Syria", "name_ar": "سوريا", "code": "SY", "phone_code": "+963"},
    {"name": "Taiwan", "name_ar": "تايوان", "code": "TW", "phone_code": "+886"},
    {
      "name": "Tajikistan",
      "name_ar": "طاجيكستان",
      "code": "TJ",
      "phone_code": "+992"
    },
    {
      "name": "Tanzania",
      "name_ar": "تنزانيا",
      "code": "TZ",
      "phone_code": "+255"
    },
    {
      "name": "Thailand",
      "name_ar": "تايلاند",
      "code": "TH",
      "phone_code": "+66"
    },
    {
      "name": "Timor-Leste",
      "name_ar": "تيمور الشرقية",
      "code": "TL",
      "phone_code": "+670"
    },
    {"name": "Togo", "name_ar": "توغو", "code": "TG", "phone_code": "+228"},
    {"name": "Tonga", "name_ar": "تونغا", "code": "TO", "phone_code": "+676"},
    {
      "name": "Trinidad and Tobago",
      "name_ar": "ترينيداد وتوباغو",
      "code": "TT",
      "phone_code": "+1-868"
    },
    {"name": "Tunisia", "name_ar": "تونس", "code": "TN", "phone_code": "+216"},
    {"name": "Turkey", "name_ar": "تركيا", "code": "TR", "phone_code": "+90"},
    {
      "name": "Turkmenistan",
      "name_ar": "تركمانستان",
      "code": "TM",
      "phone_code": "+993"
    },
    {"name": "Tuvalu", "name_ar": "توفالو", "code": "TV", "phone_code": "+688"},
    {"name": "Uganda", "name_ar": "أوغندا", "code": "UG", "phone_code": "+256"},
    {
      "name": "Ukraine",
      "name_ar": "أوكرانيا",
      "code": "UA",
      "phone_code": "+380"
    },
    {
      "name": "United Arab Emirates",
      "name_ar": "الإمارات العربية المتحدة",
      "code": "AE",
      "phone_code": "+971"
    },
    {
      "name": "United Kingdom",
      "name_ar": "المملكة المتحدة",
      "code": "GB",
      "phone_code": "+44"
    },
    {
      "name": "United States",
      "name_ar": "الولايات المتحدة",
      "code": "US",
      "phone_code": "+1"
    },
    {
      "name": "Uruguay",
      "name_ar": "أوروغواي",
      "code": "UY",
      "phone_code": "+598"
    },
    {
      "name": "Uzbekistan",
      "name_ar": "أوزبكستان",
      "code": "UZ",
      "phone_code": "+998"
    },
    {
      "name": "Vanuatu",
      "name_ar": "فانواتو",
      "code": "VU",
      "phone_code": "+678"
    },
    {
      "name": "Vatican City",
      "name_ar": "مدينة الفاتيكان",
      "code": "VA",
      "phone_code": "+379"
    },
    {
      "name": "Venezuela",
      "name_ar": "فنزويلا",
      "code": "VE",
      "phone_code": "+58"
    },
    {"name": "Vietnam", "name_ar": "فيتنام", "code": "VN", "phone_code": "+84"},
    {"name": "Yemen", "name_ar": "اليمن", "code": "YE", "phone_code": "+967"},
    {"name": "Zambia", "name_ar": "زامبيا", "code": "ZM", "phone_code": "+260"},
    {
      "name": "Zimbabwe",
      "name_ar": "زيمبابوي",
      "code": "ZW",
      "phone_code": "+263"
    }
  ];
}
