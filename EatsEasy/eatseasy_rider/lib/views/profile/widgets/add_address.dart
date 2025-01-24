
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/common/back_ground_container.dart';
import 'package:eatseasy_rider/common/custom_btn.dart';
import 'package:eatseasy_rider/common/reusable_text.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/controllers/address_controller.dart';
import 'package:eatseasy_rider/controllers/location_controller.dart';
import 'package:eatseasy_rider/models/request_address_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final TextEditingController _searchController = TextEditingController();
  late final PageController _pageController = PageController(initialPage: 0);
  GoogleMapController? _mapController;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<dynamic> _placeList = [];
  List<dynamic> _selectedPlace = [];

  LatLng? _selectedLocation;

  void _onSearchChanged(String searchQuery) async {
    if (searchQuery.isNotEmpty) {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchQuery&key=$googleApiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      }
    } else {
      setState(() {
        _placeList = [];
      });
    }
  }

  void _getPlaceDetail(String placeId) async {
    final detailUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey');
    final detailResponse = await http.get(detailUrl);

    if (detailResponse.statusCode == 200) {
      final responseBody = json.decode(detailResponse.body);

      // Extracting latitude and longitude
      final lat = responseBody['result']['geometry']['location']['lat'];
      final lng = responseBody['result']['geometry']['location']['lng'];

      // Extracting the formatted address
      final address = responseBody['result']['formatted_address'];

      // Extracting the postal code
      String postalCode = "";
      final addressComponents = responseBody['result']['address_components'];
      for (var component in addressComponents) {
        if (component['types'].contains('postal_code')) {
          postalCode = component['long_name'];
          break;
        }
      }

      setState(() {
        _selectedLocation = LatLng(lat, lng);
        _searchController.text = address;
        _postalCodeRes.text = postalCode;
        moveToSelectedLocation();
        _placeList = [];
      });
    }
  }

  void moveToSelectedLocation() {
    if (_selectedLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _selectedLocation!,
            zoom: 16.0, // You can adjust the zoom level
          ),
        ),
      );
    }
  }

  void _onMarkerDragEnd(LatLng newPosition) async {
    setState(() {
      _selectedLocation = newPosition;
    });

    final reverseGeocodeUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${newPosition.latitude},${newPosition.longitude}&key=${googleApiKey}');

    final response = await http.get(reverseGeocodeUrl);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      // Extracting the formatted address
      final address = responseBody['results'][0]['formatted_address'];

      // Extracting the postal code
      String postalCode = "";
      final addressComponents =
      responseBody['results'][0]['address_components'];
      for (var component in addressComponents) {
        if (component['types'].contains('postal_code')) {
          postalCode = component['long_name'];
          break;
        }
      }

      // Update the state with the new address and postal code
      setState(() {
        _searchController.text = address;
        _postalCodeRes.text = postalCode;
      });
    } else {
      // Handle the error or no result case
      print('Failed to fetch address');
    }
  }

  String restaurantAddress = "";
  final TextEditingController _postalCodeRes = TextEditingController();
  final TextEditingController _instructions = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserLocationController());
    final addressController = Get.put(AddressController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ReusableText(
            text: "Add Address", style: appStyle(16, kDark, FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Obx(
              () => Padding(
            padding: EdgeInsets.only(right: 0),
            child: controller.currentIndex == 0
                ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios, color: kPrimary,))
                : IconButton(
              onPressed: () {
                controller.currentIndex = 0;
                _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
              },
              icon: const Icon(Icons.arrow_back_ios, color: kPrimary,),
            ),
          ),
        ),
        actions: [
          Obx(() => Padding(
            padding: EdgeInsets.only(right: 0, top: 6 ),
            child: controller.currentIndex == 1
                ? const SizedBox.shrink()
                : IconButton(
              onPressed: () {
                controller.currentIndex = 1;
                _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
              },
              icon: Icon(Icons.arrow_forward_ios, color: kPrimary,),
            ),
          ))
        ],
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: PageView(
          controller: _pageController,
          pageSnapping: false,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            _pageController.jumpToPage(index);
          },
          children: [
            Container(
              color: kGrayLight,
              width: width,
              height: height,
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: _selectedLocation ??
                          const LatLng(
                              37.77483, -122.41942), // Default location
                      zoom: 15.0,
                    ),
                    markers: _selectedLocation == null
                    // ignore: prefer_collection_literals
                        ? Set.of([])
                    // ignore: prefer_collection_literals
                        : Set.of([
                      Marker(
                        markerId: const MarkerId('Your Location'),
                        position: _selectedLocation!,
                        draggable: true,
                        onDragEnd: (newPosition) {
                          _onMarkerDragEnd(newPosition);
                        },
                      )
                    ]),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10 ),
                        color: Colors.white,
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: const InputDecoration(
                              hintText: 'Search for your address...'),
                        ),
                      ),
                      _placeList.isEmpty
                          ? const SizedBox.shrink()
                          : Expanded(
                        child: ListView(
                          children: List.generate(
                            _placeList.length,
                                (index) {
                              return Container(
                                color: Colors.white,
                                child: ListTile(
                                  visualDensity: VisualDensity.compact,
                                  title: Text(
                                      _placeList[index]['description']),
                                  onTap: () {
                                    _getPlaceDetail(
                                        _placeList[index]['place_id']);
                                    _selectedPlace.add(_placeList[index]);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            BackGroundContainer(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10),
                children: [
                  SizedBox(
                    height: 20 ,
                  ),
                  SizedBox(
                    height: 20 ,
                  ),
                  _buildtextfield(
                    hintText: "Postal Code",
                    controller: _postalCodeRes,
                    onSubmitted: (value) {},
                  ),
                  SizedBox(
                    height: 20 ,
                  ),
                  _buildtextfield(
                    hintText: "Address",
                    controller: _searchController,
                    onSubmitted: (value) {},
                  ),
                  SizedBox(
                    height: 20 ,
                  ),
                  _buildtextfield(
                    hintText: "Your vehicle number",
                    controller: _instructions,
                    onSubmitted: (value) {},
                  ),
                  SizedBox(
                    height: 20 ,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Set this address as default",
                              style:
                              appStyle(12, Colors.black, FontWeight.w500)),
                          Obx(() => CupertinoSwitch(
                            value: controller.defaultAddress,
                            onChanged: (value) {
                              controller.defaultAddress = value;
                            },
                            thumbColor: kSecondary,
                            activeColor: kPrimary,
                          ))
                        ]),
                  ),
                  SizedBox(
                    height: 20 ,
                  ),
                  CustomButton(
                    onTap: () {
                      if (_searchController.text.isNotEmpty &&
                          _postalCodeRes.text.isNotEmpty &&
                          _instructions.text.isNotEmpty) {
                        AddressRequest address = AddressRequest(
                            addressLine1: _searchController.text,
                            postalCode: _postalCodeRes.text,
                            latitude: _selectedLocation!.latitude,
                            longitude: _selectedLocation!.longitude,
                            addressRequestDefault: controller.defaultAddress,
                            deliveryInstructions: _instructions.text);

                        String addressData = addressRequestToJson(address);

                        addressController.addAddress(addressData);
                      } else {
                        Get.snackbar(
                            "Error", "Please fill all the fields to continue",
                            icon: const Icon(Icons.error));
                      }
                    },
                    radius: 9,
                    color: kPrimary,
                    btnWidth: width * 0.95,
                    btnHieght: 34 ,
                    text: "S U B M I T",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _buildtextfield extends StatelessWidget {
  const _buildtextfield({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.onSubmitted,
    this.keyboard,
    this.readOnly,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboard;
  final void Function(String)? onSubmitted;
  final bool? readOnly;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: TextField(
          keyboardType: keyboard,
          readOnly: readOnly ?? false,
          decoration: InputDecoration(
              hintText: hintText,
              // contentPadding: EdgeInsets.only(left: 24),
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kRed, width: 0.5),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kPrimary, width: 0.5),
              ),
              focusedErrorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kRed, width: 0.5),
              ),
              disabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kGray, width: 0.5),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kGray, width: 0.5),
              ),
              border: InputBorder.none),
          controller: controller,
          cursorHeight: 25,
          style: appStyle(12, Colors.black, FontWeight.normal),
          onSubmitted: onSubmitted),
    );
  }
}
