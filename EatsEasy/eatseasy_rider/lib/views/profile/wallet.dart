import 'package:eatseasy_rider/views/profile/payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../common/custom_btn.dart';
import '../../constants/constants.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/wallet_controller.dart';
import '../../models/login_response.dart';
import '../../models/wallet_top_up.dart';
import '../auth/widgets/email_textfield.dart';
import '../auth/widgets/login_redirect.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final TextEditingController _amountController = TextEditingController();
  final WalletController _walletController = Get.put(WalletController());
  final _controller = Get.put(LoginController());
  final box = GetStorage();
  LoginResponse? user;
  bool isToppingUp = false;
  String currentAction = ''; // Variable to track the action (load, pay, withdraw)
  double walletBalance = 7595.00;

  // List to store transactions, now with USD conversion
  List<Map<String, String>> transactions = [
    {'title': 'Spotify Subscription', 'amount': '-\$11.90', 'date': '12:01 am | 21 Jun 2021'},
    {'title': 'Pinterest Salary', 'amount': '+\$6359.00', 'date': '09:00 pm | 20 Jun 2021'},
  ];

  // Constant exchange rate: 1 PHP = 0.018 USD (This can be updated dynamically)
  static const double phpToUsdExchangeRate = 0.018;

  // A function to convert PHP to USD
  double convertPhpToUsd(double phpAmount) {
    return phpAmount * phpToUsdExchangeRate;
  }

  // Function to handle loading the wallet
  Future<void> _loadWallet() async {
    String? driverId = box.read('driverId');
    if (driverId != null && _amountController.text.isNotEmpty) {
      setState(() {
        double phpAmount = double.parse(_amountController.text);
        double usdAmount = convertPhpToUsd(phpAmount); // Convert PHP to USD

        DriverWallet newTransaction = DriverWallet(
          userId: driverId,
          walletTransactions: [
            WalletTransactions(
              amount: usdAmount, // Store the amount in USD
              paymentMethod: 'STRIPE',
            )
          ],
          walletBalance: walletBalance, // Or any balance update logic here
        );
        _walletController.paymentFunction(usdAmount, 'STRIPE', newTransaction);
      });
    } else {
      Get.snackbar(
        "Empty amount",
        "Please enter an amount",
        icon: const Icon(Icons.error),
      );
    }
  }

  // Function to handle payment
  Future<void> _pay() async {
    String? driverId = box.read('driverId');
    if (driverId != null && _amountController.text.isNotEmpty) {
      setState(() {
        double phpAmount = double.parse(_amountController.text);
        double usdAmount = convertPhpToUsd(phpAmount); // Convert PHP to USD

        DriverWallet newTransaction = DriverWallet(
          userId: driverId,
          walletTransactions: [
            WalletTransactions(
              amount: usdAmount, // Store the amount in USD
              paymentMethod: 'STRIPE',
            )
          ],
          walletBalance: walletBalance, // Or any balance update logic here
        );
        _walletController.paymentFunction(usdAmount, 'STRIPE', newTransaction);
      });
    } else {
      Get.snackbar(
        "Empty amount",
        "Please enter an amount",
        icon: const Icon(Icons.error),
      );
    }
  }

  // Function to handle withdrawal
  Future<void> _withdraw() async {
    String? driverId = box.read('driverId');
    if (driverId != null && _amountController.text.isNotEmpty) {
      setState(() {
        double phpAmount = double.parse(_amountController.text);
        double usdAmount = convertPhpToUsd(phpAmount); // Convert PHP to USD

        DriverWallet newTransaction = DriverWallet(
          userId: driverId,
          walletTransactions: [
            WalletTransactions(
              amount: usdAmount, // Store the amount in USD
              paymentMethod: 'STRIPE',
            )
          ],
          walletBalance: walletBalance, // Or any balance update logic here
        );
        _walletController.paymentFunction(usdAmount, 'STRIPE', newTransaction);
      });
    } else {
      Get.snackbar(
        "Empty amount",
        "Please enter an amount",
        icon: const Icon(Icons.error),
      );
    }
  }

  // Helper function to handle back press logic
  Future<bool> _onWillPop() async {
    if (isToppingUp) {
      setState(() {
        isToppingUp = false;
      });
      return false; // Prevents the Navigator from popping the page
    }
    return true; // Allows the Navigator to pop the page
  }

  @override
  Widget build(BuildContext context) {
    String? token = box.read('token');

    if (token != null) {
      user = _controller.getUserData();
      _walletController.fetchDriverDetails();
    }

    return token == null
        ? const LoginRedirection()
        : Obx(() => _walletController.paymentUrl.contains("https")
        ? PaymentWebView(amount: _amountController.text, currentAction: currentAction)
        : WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFF2B2B2B),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome back', style: TextStyle(color: Colors.white54, fontSize: 16)),
                  const SizedBox(height: 5),
                  Text(user!.username, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  // Expanded Card Section
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: kPrimary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user!.username, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                              const SizedBox(height: 5),
                              Text(user!.id, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                              const SizedBox(height: 10),
                              const Text('Available Balance', style: TextStyle(color: Colors.white54, fontSize: 14)),
                              const SizedBox(height: 5),
                              _walletController.driver.value?.walletBalance == null ?
                              const Text('Loading...', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)) :
                              Text('Php ${_walletController.driver.value?.walletBalance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons Row
                  // Action Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentAction = 'load'; // Set the action to load
                            isToppingUp = true; // Open the DraggableScrollableSheet
                          });
                        },
                        child: _buildActionButton(Icons.input, 'Load', Colors.blue.withOpacity(0.2)),
                      ),
                      /*GestureDetector(
                        onTap: () {
                          setState(() {
                            currentAction = 'pay'; // Set the action to pay
                            isToppingUp = true; // Open the DraggableScrollableSheet
                          });
                        },
                        child: _buildActionButton(Icons.wallet, 'Pay', Colors.red.withOpacity(0.2)),
                      ),*/
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentAction = 'withdraw'; // Set the action to withdraw
                            isToppingUp = true; // Open the DraggableScrollableSheet
                          });
                        },
                        child: _buildActionButton(Icons.atm, 'Withdraw', Colors.green.withOpacity(0.2)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Recent Transactions
                  Expanded(
                    child: _walletController.driver.value?.walletTransactions.isEmpty ?? true
                        ? const Center(child: Text("No transactions yet", style: TextStyle(color: Colors.white54)))
                        : ListView.builder(
                      itemCount: _walletController.driver.value!.walletTransactions.length,
                      itemBuilder: (context, index) {
                        // Reverse the transactions list for display
                        final transaction = _walletController.driver.value!.walletTransactions.reversed.toList()[index];
                        return _buildTransactionRow(
                          transaction.id.toString(), // Title or description of the transaction
                          transaction.amount, // Ensure this is a double
                          transaction.transactionDate.toString(), // Adjust this as needed
                          transaction.paymentMethod, // Payment method
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            isToppingUp
                ? DraggableScrollableSheet(
              snap: true,
              initialChildSize: 0.2,
              minChildSize: 0.2,
              maxChildSize: 0.2,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B4B4B),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          EmailTextField(
                            hintText: "Enter amount",
                            controller: _amountController,
                            prefixIcon: Icon(
                              Icons.money_rounded,
                              color: Theme.of(context).dividerColor,
                              size: 20.h,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 20.h),
                          _walletController.isLoading ?
                          Center(
                              child: LoadingAnimationWidget.waveDots(
                                color: kPrimary,
                                size: 35,
                              ))
                              :
                          CustomButton(
                            onTap: () async {
                              if (_amountController.text.isNotEmpty) {
                                if (currentAction == 'load') {
                                  print(currentAction);
                                  await _loadWallet();
                                } else if (currentAction == 'pay') {
                                  print(currentAction);
                                  await _pay();
                                } else if (currentAction == 'withdraw') {
                                  print(currentAction);
                                  await _withdraw();
                                }
                                setState(() {
                                  isToppingUp = false; // Close the sheet after action
                                });
                              } else {
                                Get.snackbar(
                                  "Empty amount",
                                  "Please enter an amount",
                                  icon: const Icon(Icons.error),
                                );
                              }
                            },
                            color: kPrimary,
                            btnHieght: kCustomButtonHeight,
                            radius: kCustomButtonRadius,
                            text: "Confirm", // Text that indicates the action being taken
                          )

                        ],
                      ),
                    ),
                  ),
                );
              },
            )
                : const SizedBox.shrink(),
          ],
        ),
        /*bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF333333),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.white),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz, color: Colors.white),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: Colors.white),
              label: '',
            ),
          ],
        ),*/
      ),
    ));
  }

  // Helper method for action buttons
  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: color.withOpacity(1)),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  // Helper method for transaction rows
  // Helper method for transaction rows
  Widget _buildTransactionRow(String title, double amount, String date, String paymentType) {
    // Determine the sign and color of the amount
    Color amountColor = paymentType == 'Pay' || paymentType == 'Withdrawal' || paymentType == 'Order paid' ? Colors.red : Colors.green;
    String formattedAmount = paymentType == 'Pay' || paymentType == 'Withdrawal' || paymentType == 'Order paid' ? '-Php ${amount.abs().toStringAsFixed(2)}' : '+Php ${amount.toStringAsFixed(2)}';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 5),
              Text(date, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          Column(
            children: [
              Text(formattedAmount, style: TextStyle(color: amountColor, fontSize: 16)),
              Text(paymentType, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}