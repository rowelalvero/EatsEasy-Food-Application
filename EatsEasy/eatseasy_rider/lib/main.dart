import 'package:eatseasy_rider/services/notification_service.dart';
import 'package:eatseasy_rider/views/auth/verification_page.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/firebase_options.dart';
import 'package:eatseasy_rider/views/auth/login_page.dart';
import 'package:eatseasy_rider/views/auth/waiting_page.dart';
import 'package:eatseasy_rider/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Widget defaultHome = Login();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //name: 'eatseasy-food-apps',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  await NotificationService().initialize(flutterLocalNotificationsPlugin);
    runApp(const BetterFeedback(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read('token');
    String? driver = box.read('driverId');
    String? verification = box.read("verification");
    bool? emailVerification = box.read("e-verification");

    /*if (token == null) {
      defaultHome = const Login();
      // ignore: unnecessary_null_comparison
    } else if (token != null && driver == null) {
      defaultHome = const Login();
    } else if (token != null &&  emailVerification == false || emailVerification == null) {
      defaultHome = const VerificationPage();
    } else if (driver != null && verification == "Verified") {
      defaultHome = MainScreen();
    } else if (driver != null && verification != "Verified") {
      defaultHome = const WaitingPage();
    }*/

    if (token == null) {
      defaultHome = const Login();
      // ignore: unnecessary_null_comparison
    } else if (token != null && driver == null) {
      defaultHome = const Login();
    } /*else if (driver != null && verification == "Verified") {
      defaultHome = MainScreen();
    }*/ else if (driver != null && verification != "Verified") {
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
            title: 'EatsEasy Delivery App',
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
          );
        });
  }
}
