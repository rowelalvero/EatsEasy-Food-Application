import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/firebase_options.dart';
import 'package:eatseasy_admin/services/notification_service.dart';
import 'package:eatseasy_admin/views/auth/login_page.dart';
import 'package:eatseasy_admin/views/home/home_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/home_controller.dart';

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print("onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
}
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Widget defaultHome = const Login();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Starting Firebase");
  await Firebase.initializeApp(
    // name: 'eatseasy-food-apps',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase started");
  await GetStorage.init();
  await NotificationService().initialize(flutterLocalNotificationsPlugin);

  // Check network connectivity
  bool isConnected = await checkNetworkConnection();
  if (!isConnected) {
    if (kDebugMode) {
      print("No internet connection");
    }
  }

  Get.put(HomeController());
  runApp(
    const MyApp(),
  );
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
    bool? verification = box.read("verification");

    /*if (token != null && verification == false) {
      defaultHome = const VerificationPage();
    } else if (token != null && verification == true) {
      defaultHome = const HomePage();
    }*/
    if (token != null && verification == true) {
      defaultHome = const HomePage();
    }
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(375, 825),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'EatsEasy Admin',
            theme: ThemeData(
              scaffoldBackgroundColor: kOffWhite,
              iconTheme: const IconThemeData(color: kDark),
              primarySwatch: Colors.grey,
            ),
            home: defaultHome,
            navigatorKey: navigatorKey,
            // routes: {
            //   // '/order_details_page': (context) => const OrderDetailsPage(),
            // },
          );
        });
  }void showNoConnectionMessage(BuildContext context) {
    Get.snackbar(
      "No Internet Connection",
      "Please check your network settings",
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