
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/firebase_options.dart';
import 'package:eatseasy_partner/models/environment.dart';
import 'package:eatseasy_partner/services/notification_service.dart';
import 'package:eatseasy_partner/views/auth/login_page.dart';
import 'package:eatseasy_partner/views/auth/verification_page.dart';
import 'package:eatseasy_partner/views/auth/waiting_page.dart';
import 'package:eatseasy_partner/views/home/home_page.dart';
import 'package:eatseasy_partner/views/order/notifications_active_order.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'controllers/contact_controller.dart';
import 'controllers/location_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/restaurant_controller.dart';
import 'controllers/updates_controllers/new_orders_controller.dart';
import 'controllers/updates_controllers/picked_controller.dart';
import 'controllers/updates_controllers/ready_for_pick_up_controller.dart';



Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print(
      "onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Widget defaultHome = const Login();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //name: 'eatseasy-food-apps',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  await dotenv.load(fileName: Environment.fileName);
 await NotificationService().initialize(flutterLocalNotificationsPlugin);

  // Check network connectivity
  bool isConnected = await checkNetworkConnection();
  if (!isConnected) {
    if (kDebugMode) {
      print("No internet connection");
    }
  }
  Get.put(ContactController());
  Get.put(UserLocationController());
  Get.put(RestaurantController());
  Get.put(ReadyForPickUpController());
  Get.put(PickedController());
  Get.put(NewOrdersController());
  Get.put(LoginController());
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
    String? restaurantId = box.read('restaurantId');
    String? verification = box.read("verification");
    bool? emailVerification = box.read("e-verification");

    if (token == null) {
      defaultHome = const Login();
      // ignore: unnecessary_null_comparison
    } else if (token != null && restaurantId == null) {
      defaultHome = const Login();
      // ignore: unnecessary_null_comparison
    }else if (token != null &&  emailVerification == false || emailVerification == null) {
      defaultHome = const VerificationPage();
    }  /*else if (restaurantId != null &&  verification == "Verified") {
      defaultHome = const HomePage();
    }*/ else if (restaurantId != null && verification != "Verified") {
      defaultHome = const WaitingPage();
    }

    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'EatsEasy Partner',
            theme: ThemeData(
              scaffoldBackgroundColor: kOffWhite,
              iconTheme: const IconThemeData(color: kDark),
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
              '/order_details_page': (context) => const NotificationOrderPage(),
            },
          );
        });
  }
  void showNoConnectionMessage(BuildContext context) {
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
