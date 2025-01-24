import 'package:eatseasy_admin/views/home/screens/Rates/rates_page.dart';
import 'package:eatseasy_admin/views/home/screens/earnings/earnings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/custom_appbar.dart';
import 'package:eatseasy_admin/common/home_tile_holder.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/home_controller.dart';
import 'package:eatseasy_admin/views/home/screens/cashout/cashout_page.dart';
import 'package:eatseasy_admin/views/home/screens/categories/categories_page.dart';
import 'package:eatseasy_admin/views/home/screens/drivers/drivers_page.dart';
import 'package:eatseasy_admin/views/home/screens/foods/foods_page.dart';
import 'package:eatseasy_admin/views/home/screens/orders/orders_page.dart';
import 'package:eatseasy_admin/views/home/screens/restaurant/restaurant_page.dart';
import 'package:eatseasy_admin/views/home/screens/reviews/reviews_page.dart';
import 'package:eatseasy_admin/views/home/screens/statistics/stats_page.dart';
import 'package:eatseasy_admin/views/home/screens/transactions/transactions_page.dart';
import 'package:eatseasy_admin/views/home/screens/users/users_page.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../common/app_style.dart';
import '../../common/back_ground_container.dart';
import '../../common/reusable_text.dart';
import '../../controllers/admin_earnings_controller.dart';
import '../../controllers/login_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final loginController = Get.put(LoginController());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kOffWhite,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome to ",
                            overflow: TextOverflow.ellipsis,
                            style: appStyle(16, kDark, FontWeight.w500)),
                        ReusableText(
                            text: "EatsEasy Admin Panel",
                            style: appStyle(23, kDark, FontWeight.w700)),
                        /*Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            gradient: buttonGradient(),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(25),
                                bottomRight: Radius.circular(25)),
                          ),
                          child: ReusableText(
                              text: "EatsEasy Admin Panel",
                              style: appStyle(23, kLightWhite, FontWeight.w600)),
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm Logout"),
                          content: const Text("Are you sure you want to log out?"),
                          actions: [
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text("Logout"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                loginController.logout();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: SvgPicture.asset("assets/icons/shutdown.svg"),
                ),
              )
            ],
          ),
        ),
        body: Center(child: BackGroundContainer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const HomeTilesHolder(),

                Obx(() {
                  Widget currentPage;

                  switch (controller.currentPage.value) {
                    case 'Restaurant':
                      currentPage = const RestaurantPage();
                      break;
                    case 'Earnings':
                      currentPage = const EarningsPage();
                      break;
                    case 'Drivers':
                      currentPage = const DriversPage();
                      break;
                    case 'Orders':
                      currentPage = const OrdersPage();
                      break;

                    case 'Categories':
                      currentPage = const CategoriesPage();
                      break;

                    case 'Foods':
                      currentPage = const FoodsPage();
                      break;

                    case 'Users':
                      currentPage = const UsersPage();
                      break;

                    case 'Cashout':
                      currentPage = const CashoutPage();
                      break;

                    case 'Statistics':
                      currentPage = const StatsPage();
                      break;

                    case 'Transactions':
                      currentPage = const TransactionsPage();
                      break;

                    case 'Feedback':
                      currentPage = const FeedbackPage();
                      break;

                    case 'Rates':
                      currentPage = const RatesPage();
                      break;
                    default:
                      currentPage = const RestaurantPage();
                  }
                  return currentPage;
                }),
              ],
            ),
          ),
        )
        ),
    );
  }
}
