import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_learning_application/data/mock_data.dart';
import 'package:online_learning_application/providers/cart_provider.dart';
import 'package:online_learning_application/providers/course_provider.dart';
import 'package:online_learning_application/utils/appcolor.dart';
import 'package:online_learning_application/views/order_success_screen.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'UPI';

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'UPI', 'label': 'UPI (GPay / PhonePe / Paytm)', 'icon': Icons.qr_code_scanner, 'imageAsset': 'assests/images/gpay.png'},
    {'id': 'CARD', 'label': 'Credit / Debit Card', 'icon': Icons.credit_card, 'imageAsset': 'assests/images/debit-card.png'},
    {'id': 'NET_BANKING', 'label': 'Net Banking', 'icon': Icons.account_balance, 'imageAsset': 'assests/images/bank.png'},
    {'id': 'CASH', 'label': 'Cash / Free Course', 'icon': Icons.payments, 'imageAsset': 'assests/images/cash-on-delivery.png'},
  ];

  @override
  Widget build(BuildContext context) {
    // MediaQuery calculation method
    final mq         = MediaQuery.of(context);
    final sw         = mq.size.width;
    final sh         = mq.size.height;
    final outerPad   = sw * 0.040;
    final sectionGap = sh * 0.022;
    final cardGap    = sh * 0.014;
    final cardRowGap = sw * 0.028;

    final cartProvider = Provider.of<CartProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(outerPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Section
            const Text('User Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            SizedBox(height: cardGap * 0.6),
            Container(
              padding: EdgeInsets.all(outerPad * 0.8),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: cardRowGap),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        MockData.mockUser['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
                      ),
                      Text(
                        MockData.mockUser['email']!,
                        style: const TextStyle(color: AppColors.textMid, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: sectionGap),

            // Order Summary
            const Text('Order Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            SizedBox(height: cardGap * 0.6),
            Container(
              padding: EdgeInsets.all(outerPad * 0.8),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  ...cartProvider.cartItems.map((course) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                course.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14, color: AppColors.textDark),
                              ),
                            ),
                            Text(
                              currencyFormatter.format(course.discountedPrice),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                            ),
                          ],
                        ),
                      )),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount Payable', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      Text(
                        currencyFormatter.format(cartProvider.totalDiscountedPrice),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: sectionGap),

            // Payment Methods
            const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            SizedBox(height: cardGap * 0.6),
            Column(
              children: _paymentMethods.map((method) {
                final isSelected = _selectedPaymentMethod == method['id'];
                return Container(
                  margin: EdgeInsets.only(bottom: cardGap * 0.6),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAlias,
                    child: RadioListTile<String>(
                    activeColor: AppColors.primary,
                    secondary: method.containsKey('imageAsset')
                        ? Image.asset(method['imageAsset'], width: 32, height: 32)
                        : Icon(method['icon'], color: isSelected ? AppColors.primary : AppColors.textLight),
                    title: Text(
                      method['label'],
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                    ),
                    value: method['id'],
                    groupValue: _selectedPaymentMethod,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedPaymentMethod = val;
                        });
                      }
                    },
                  ),
                ),
                );
              }).toList(),
            ),
            SizedBox(height: sectionGap * 1.5),

            // Pay Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final purchasedList = List.of(cartProvider.cartItems);
                  final paidAmount = cartProvider.totalDiscountedPrice;
                  
                  courseProvider.purchaseCourses(purchasedList);
                  cartProvider.clearCart();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderSuccessScreen(
                        orderId: 'DG-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}-001',
                        amountPaid: paidAmount,
                        purchasedCourses: purchasedList,
                      ),
                    ),
                  );
                },
                child: const Text('Pay Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
