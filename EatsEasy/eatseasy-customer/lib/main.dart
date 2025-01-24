import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eatseasy/views/auth/phone_verification.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/cart_controller.dart';
import 'package:eatseasy/firebase_options.dart';
import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/services/notification_service.dart';
import 'package:eatseasy/views/auth/verification_page.dart';
import 'package:eatseasy/views/entrypoint.dart';
import 'package:eatseasy/views/message/chat/index.dart';
import 'package:eatseasy/views/orders/order_details_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/address_controller.dart';
import 'controllers/catergory_controller.dart';
import 'controllers/contact_controller.dart';
import 'controllers/location_controller.dart';
import 'controllers/order_controller.dart';

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print("onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Widget defaultHome = MainScreen();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Firing up Firebase");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  print("Firebase Initialized");
  await dotenv.load(fileName: Environment.fileName);
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  await GetStorage.init();

  await NotificationService().initialize(flutterLocalNotificationsPlugin);

  // Check network connectivity
  bool isConnected = await checkNetworkConnection();
  if (!isConnected) {
    if (kDebugMode) {
      print("No internet connection");
    }
  }
  Get.put(CartController());
  Get.put(ContactController());
  Get.put(CategoryController());
  Get.put(UserLocationController());
  //Get.lazyPut(() => CartCheckoutController(), fenix: true);
  Get.lazyPut(() => OrderController(), fenix: true);
  Get.lazyPut(() => AddressController(), fenix: true);
  if(!kIsWeb) {
    await NotificationService().initialize(flutterLocalNotificationsPlugin);
  }
  runApp(const BetterFeedback(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isConnected = true;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    if(!kIsWeb) {
      monitorNetwork();
    }
  }

  @override
  void dispose() {
    // Ensure to cancel the subscription when the widget is disposed
    connectivitySubscription.cancel();
    super.dispose();
  }

  void monitorNetwork() {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      // Delay for 5 seconds to ensure no false positives
      await Future.delayed(const Duration(seconds: 5));

      bool connected = await checkNetworkConnection();

      if (connected) {
        setState(() {
          isConnected = true;
        });
        // Dismiss snackbar if reconnected
        Get.closeAllSnackbars();
      } else {
        setState(() {
          isConnected = false;
        });
        showNoConnectionMessage(context);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read('token');
    //bool? verification = box.read("phone_verification");
    bool? verification = box.read("verification");

    Widget defaultHome = MainScreen();
    if (token != null && verification == false) {
      defaultHome = const VerificationPage();
    } else if (token != null && verification == true) {
      defaultHome = MainScreen();
    }
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(375, 825),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'EatsEasy Food App',
            theme: ThemeData(
              scaffoldBackgroundColor: Color(kOffWhite.value),
              iconTheme: IconThemeData(color: Color(kDark.value)),
              primarySwatch: Colors.grey,
              textSelectionTheme: TextSelectionThemeData(
                selectionColor: kPrimary.withOpacity(.5),
                cursorColor: kPrimary.withOpacity(.6),
                selectionHandleColor: kPrimary.withOpacity(1),
              ),
            ),
            home: defaultHome,
            navigatorKey: navigatorKey,
            routes: {
              '/order_details_page': (context) => const OrderDetailsPage(),
              '/chat':(context)=> const ChatPage()
            },
          );
        });
  }
  // Show a message using context
  void showNoConnectionMessage(BuildContext context) {
    Get.snackbar(
      "No Internet Connection",
      "Please check your network settings",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

Future<bool> checkNetworkConnection() async {
  if (kIsWeb) {
    return true;// Check for web connectivity
  } else {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }
}
