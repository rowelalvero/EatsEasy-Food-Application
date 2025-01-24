import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../../common/back_ground_container.dart';
import '../../controllers/wallet_controller.dart';
import 'package:universal_html/html.dart' as html;

class PaymentWebView extends StatefulWidget {
  final String amount;
  final String currentAction;

  const PaymentWebView(
      {super.key, required this.amount, required this.currentAction});

  @override State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;

  @override void initState() {
    super.initState();
    final WalletController walletController = Get.put(
        WalletController());
    if (kIsWeb) {
      _loadWebView(walletController);
    } else {
      _initializeWebView(walletController);
    }
  }

  void _initializeWebView(WalletController walletController) async {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},);
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    final WebViewController controller = WebViewController
        .fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (String url) {
        print('Page started loading: $url');
      }, onPageFinished: (String url) {
        print('Page finished loading: $url');
      }, onNavigationRequest: (NavigationRequest request) {
        return NavigationDecision.navigate;
      }, onUrlChange: (UrlChange change) async {
        if (change.url!.contains("checkout-success")) {
          walletController.paymentUrl = '';
          if (widget.currentAction == 'load') {
            await walletController.initiateTopUp(
                double.parse(widget.amount), 'Top-up');
          } else if (widget.currentAction == 'pay') {
            await walletController.initiatePay(
                double.parse(widget.amount), 'Pay');
          } else {
            await walletController.initiateWithdraw(
                double.parse(widget.amount), 'Withdraw');
          }
        } else if (change.url!.contains("cancel") ||
            change.url!.contains("checkout-failure")) {
          walletController.paymentUrl = '';
          walletController.handlePaymentFailure();
        }
      },),)
      ..addJavaScriptChannel(
        'Toaster', onMessageReceived: (JavaScriptMessage message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),);
      },);
    try {
      await controller.loadRequest(Uri.parse(walletController.paymentUrl));
    } catch (e) {
      print('Error loading payment URL: $e');
    }
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    setState(() {
      _controller = controller;
    });
  }

  StreamSubscription? _messageSubscription; // Track the subscription

  void _loadWebView(WalletController walletController) async {
    final String url = walletController.paymentUrl;

    html.window.open(url, "_blank");

    // Cancel any existing listener before attaching a new one
    _messageSubscription?.cancel();

    Future<void> messageListener(html.MessageEvent event) async {
      // we listen from the backend
      if (event.origin == "https://eatseasy-payment-backend.vercel.app") {
        print("Received message: ${event.data}");
        if (event.data == "payment_success") {
          await walletController.initiateTopUp(double.parse(widget.amount), 'Top-up');
        } else if (event.data == "payment_cancel") {
          walletController.paymentUrl = '';
          walletController.handlePaymentFailure();
        }
        // Cancel listener after processing the message
        _messageSubscription?.cancel();
      }
    }

    // Attach the listener and store the subscription
    _messageSubscription = html.window.onMessage.listen(messageListener);
  }

  @override Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 5,
          leading: Container(),),
        body: Center(child: kIsWeb ? Container()
                : BackGroundContainer(child: WebViewWidget(controller: _controller)), )
    ,
    );
  }
}
