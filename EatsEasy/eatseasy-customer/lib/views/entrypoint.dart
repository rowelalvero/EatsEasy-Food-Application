import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/hooks/fetchDefaultAddress.dart';
import 'package:eatseasy/views/cart/restaurant_cart_page.dart';
import 'package:eatseasy/views/home/home_page.dart';
import 'package:eatseasy/views/profile/profile_page.dart';
import 'package:eatseasy/views/search/seach_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainScreen extends HookWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final PersistentTabController controller = useState(PersistentTabController(initialIndex: 0)).value;
    final reloadTrigger = useState(0); // State variable to trigger page reload

    // Fetch the default address only if token and verification conditions are met
    String? token = box.read('token');
    /*bool? verification = box.read("verification");

    if (token != null && verification == true) {
      useFetchDefault(context, true);  // Hook now called within build method
    }*/

    List<Widget> buildScreens() {
      return [
        HomePage(key: ValueKey(reloadTrigger.value)), // Use ValueKey to force rebuild
        SearchPage(key: ValueKey(reloadTrigger.value)),
        RestaurantCartPage(key: ValueKey(reloadTrigger.value)),
        ProfilePage(key: ValueKey(reloadTrigger.value)),
      ];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.house_fill),
          title: ("Home"),
          activeColorPrimary: kPrimary,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.search),
          title: ("Search"),
          activeColorPrimary: kPrimary,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.cart_fill),
          title: box.read('cart') ?? "0",
          activeColorPrimary: kPrimary,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.person_fill),
          title: ("Profile"),
          activeColorPrimary: kPrimary,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ];
    }

    return PersistentTabView(
      context,
      controller: controller,
      screens: buildScreens(),
      items: navBarsItems(),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: kOffWhite,
      isVisible: true,
      onItemSelected: (index) {
        // Trigger a page rebuild by updating the reloadTrigger state
        reloadTrigger.value++;
      },
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.style12,
    );
  }
}

