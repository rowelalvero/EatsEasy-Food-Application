import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../controllers/order_controller.dart';
import '../../models/client_orders.dart';
import '../../models/environment.dart';

class OrderTrackingPage extends StatefulWidget {

  const OrderTrackingPage({Key? key, required this.order}) : super(key: key);
  final ClientOrders order;
  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final box = GetStorage();
  final controller = Get.put(OrderController());
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
    _initializeOrderTracking();
  }

  void _initializeWebViewController() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent);
  }

  Future<void> _initializeOrderTracking() async {
    await _getOrderData();
    _loadWebViewContent();
  }

  Future<void> _getOrderData() async {
    await controller.getOrderDetails(widget.order.id);
  }

  void _loadWebViewContent() {
    // Create Google Maps HTML content
    final String htmlContent = '''
      <!DOCTYPE html>
      <html>
      <head>
        <title>Google Maps</title>
        <script src="https://maps.googleapis.com/maps/api/js?key=${Environment.googleApiKey}&libraries=geometry,places"></script>
        <script>
          let map, restaurantMarker, clientMarker, riderMarker;
          function initMap() {
            map = new google.maps.Map(document.getElementById('map'), {
              center: { lat: ${controller.getOrder!.restaurantCoords![0]}, lng: ${controller.getOrder!.restaurantCoords![1]} },
              zoom: 14,
            });

            // Add Restaurant Marker
            restaurantMarker = new google.maps.Marker({
              position: { lat: ${controller.getOrder!.restaurantCoords![0]}, lng: ${controller.getOrder!.restaurantCoords![1]} },
              map,
              title: 'Restaurant',
            });

            // Add Client Marker
            clientMarker = new google.maps.Marker({
              position: { lat: ${controller.getOrder!.recipientCoords![0]}, lng: ${controller.getOrder!.recipientCoords![1]} },
              map,
              title: 'Client',
            });

            // Rider Marker (Dynamic)
            riderMarker = new google.maps.Marker({
              position: { lat: ${controller.getOrder!.driverId?.currentLocation?.latitude ?? 0}, lng: ${controller.getOrder!.driverId?.currentLocation?.longitude ?? 0} },
              map,
              title: 'Rider',
            });
          }

          function updateRiderLocation(lat, lng) {
            if (riderMarker) {
              riderMarker.setPosition({ lat, lng });
              map.panTo({ lat, lng });
            }
          }
        </script>
      </head>
      <body onload="initMap()">
        <div id="map" style="width: 100%; height: 100vh;"></div>
      </body>
      </html>
    ''';

    // Encode HTML as a data URI
    final String dataUri = Uri.dataFromString(
      htmlContent,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();

    _webViewController.loadRequest(Uri.parse(dataUri));
  }

  Future<void> _updateRiderLocation() async {
    // Fetch rider location via proxy server to avoid CORS
    final response = await http.get(Uri.parse('https://your-proxy-server.com/rider/location'));
    if (response.statusCode == 200) {
      final location = jsonDecode(response.body);
      final lat = location['latitude'];
      final lng = location['longitude'];
      _webViewController.runJavaScript('updateRiderLocation($lat, $lng);');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking')),
      body: WebViewWidget(controller: _webViewController),
    );
  }
}
