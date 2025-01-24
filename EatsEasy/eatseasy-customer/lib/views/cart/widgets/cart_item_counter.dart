import 'package:flutter/cupertino.dart';

import '../../../hooks/fetchCart.dart';

class CartItemCounter extends ChangeNotifier {
  final hookResult = useFetchCart();
  int cartListItemCounter = 0;

  int get count => cartListItemCounter;

  Future<void> displayCartListItemsNumber(cartLength) async {
    cartListItemCounter = cartLength;

    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}