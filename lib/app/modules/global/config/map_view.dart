import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maryana/app/builtInPackage/flutter_google_places-0.3.0/lib/flutter_google_places.dart';
import 'package:maryana/app/builtInPackage/google_maps_webservice-master/lib/places.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_api_headers/google_api_headers.dart' as header;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class MyMapView extends StatefulWidget {
  final LatLng location;
  const MyMapView({Key? key, required this.location}) : super(key: key);

  @override
  State<MyMapView> createState() => _MapViewState();
}

class _MapViewState extends State<MyMapView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _selectedLocation;
  GoogleMapController? mapController;

  String? _mapStyle; // Variable to hold map style JSON
  AnimationController? _animationController;
  Animation<double>? _buttonScaleAnimation;
  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    mapController!.setMapStyle(_mapStyle); // Set the map style

    final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 0.5, size: Size(5, 5)),
      'assets/images/location.png', // Replace with the location of your marker image in the assets folder.
    );
    MarkerId markerId = MarkerId(_markerIdVal());
    LatLng position = widget.location;
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      draggable: false,
      icon: markerIcon, // Custom marker icon
    );
    setState(() {
      _markers[markerId] = marker;
    });

    Future.delayed(const Duration(milliseconds: 300), () async {
      GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 17.0,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _selectedLocation = widget.location;
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });

    _mapStyle = '''
[
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#fef9e8"
      }
    ]
  },
  {
    "featureType": "landscape",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f2f3f4"
      }
    ]
  },
    {
    "featureType": "poi",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.business",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "all",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#697579"
      }
    ]
  }
]
''';
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  void _onSelect() {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Your current location')));
    } else {
      Navigator.of(context).pop(_selectedLocation);
    }
  }

  Future<void> _handleSearch() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: "AIzaSyBPKhPD8sJQF1ky6VxvthFzkeYNjlZWjBg",
        onError: onError, // call the onError function below
        mode: Mode.overlay,
        language: 'en', //you can set any language for search
        strictbounds: false,
        logo: SizedBox(
            width: 375.w,
            height: 70.h,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    height: 50.h,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  SizedBox(
                      width: 180.w,
                      child: Text('Search your current location',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontSize:
                                    14.sp, // Adjust the font size as needed
                                fontWeight: FontWeight.w700, // Makes text bold
                                color:
                                    primaryColor, // Sets the color of the text
                              ))),
                ])),
        types: [],
        decoration: InputDecoration(
            hintText: 'Search',
            contentPadding: EdgeInsets.only(bottom: 2.h),
            hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 14.sp, // Adjust the font size as needed
                  fontWeight: FontWeight.w500, // Makes text bold
                  color: Colors.black, // Sets the color of the text
                ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white))),
        components: [] // you can determine search for just one country
        );
    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    print(" test lat");
    GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: "AIzaSyBPKhPD8sJQF1ky6VxvthFzkeYNjlZWjBg",
        apiHeaders: await const header.GoogleApiHeaders().getHeaders());
    print(" test lat");
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(p!.placeId!);
// detail will get place details that user chose from Prediction search

    final lat = detail.result.geometry!.location.lat;
    print(lat.toString() + " test lat");
    final lng = detail.result.geometry!.location.lng;

    setState(() {
      mapController
          ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, lng)!, // Your new LatLng
        zoom: 16.0,
      )));
      if (_markers.isNotEmpty) {
        MarkerId markerId = MarkerId(_markerIdVal());
        Marker? marker = _markers[markerId];
        Marker? updatedMarker = marker?.copyWith(
          positionParam: LatLng(lat, lng),
        );

        _markers[markerId] = updatedMarker!;
        _selectedLocation = LatLng(lat, lng);
        print(lat.toString() + " test lat");
      }
    });
    Future.delayed(Duration(milliseconds: 700))
        .then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    LatLng? latlng =
        LatLng(widget.location.latitude!, widget.location.latitude!);
    return Scaffold(
      key: homeScaffoldKey, // Assign the key here

      appBar: const CustomAppBar(
        title: 'Choose Your Location',
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     AwesomePlaceSearch(
      //       context: context,
      //       key: "AIzaSyBPKhPD8sJQF1ky6VxvthFzkeYNjlZWjBg",
      //       onTap: (value) async {
      //         final va = await value;
      //         setState(
      //           () {
      //             prediction = va;
      //             if (_markers.isNotEmpty) {
      //               MarkerId markerId = MarkerId(_markerIdVal());
      //               Marker? marker = _markers[markerId];
      //               Marker? updatedMarker = marker?.copyWith(
      //                 positionParam:
      //                     LatLng(prediction!.latitude!, prediction!.longitude!),
      //               );

      //               _markers[markerId] = updatedMarker!;
      //               _selectedLocation =
      //                   LatLng(prediction!.latitude!, prediction!.longitude!);
      //             }
      //           },
      //         );
      //       },
      //     ).show();
      //   },
      //   child: const Icon(Icons.search),
      // ),
      body: Stack(children: [
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              markers: Set<Marker>.of(_markers.values),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: widget.location,
                zoom: 12.0,
              ),
              myLocationEnabled: true,
              onCameraMove: (CameraPosition position) {
                if (_markers.isNotEmpty) {
                  MarkerId markerId = MarkerId(_markerIdVal());
                  Marker? marker = _markers[markerId];
                  Marker? updatedMarker = marker?.copyWith(
                    positionParam: position.target,
                  );

                  setState(() {
                    _markers[markerId] = updatedMarker!;
                    _selectedLocation = position.target;
                  });
                }
              },
            )),
        PositionedDirectional(
            top: 20.h,
            start: 10.w,
            child: GestureDetector(
              onTapDown: (_) => _animationController?.forward(),
              onTapUp: (_) => _animationController?.reverse(),
              onTapCancel: () => _animationController?.reverse(),
              child: Transform.scale(
                scale: _buttonScaleAnimation?.value ?? 1.0,
                child: FloatingActionButton(
                  onPressed: _handleSearch,
                  child: Icon(Icons.search, color: Colors.white),
                  backgroundColor: primaryColor,
                  elevation: 4.0,
                ),
              ),
            ))
      ]),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8),
        child: MySecondDefaultButton(
          isloading: false,
          onPressed: _onSelect,
          btnText: 'save',
        ),
      ),
    );
  }
}
