import 'package:flutter/material.dart';
import 'package:online_learning_application/models/course.dart';
import 'package:online_learning_application/utils/appcolor.dart';
import 'package:online_learning_application/views/learning_screen.dart';
import 'package:online_learning_application/views/main_navigation.dart';
import 'package:intl/intl.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final double amountPaid;
  final List<Course> purchasedCourses;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.amountPaid,
    required this.purchasedCourses,
  });

  @override
  Widget build(BuildContext context) {
    // MediaQuery calculation method
    final mq         = MediaQuery.of(context);
    final sw         = mq.size.width;
    final sh         = mq.size.height;
    final outerPad   = sw * 0.040;
    final sectionGap = sh * 0.022;
    final cardRowGap = sw * 0.028;

    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Order Confirmed'),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(outerPad * 1.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 90,
                  color: AppColors.green,
                ),
              ),
              SizedBox(height: sectionGap),
              const Text(
                'Payment Successful',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 12),
              const Text(
                'Congratulations! Your course has been added to your learning account.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: AppColors.textMid, height: 1.4),
              ),
              SizedBox(height: sectionGap * 1.5),

              // Summary Box
              Container(
                padding: EdgeInsets.all(outerPad),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Order ID', style: TextStyle(color: AppColors.textMid)),
                        Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Amount Paid', style: TextStyle(color: AppColors.textMid)),
                        Text(
                          currencyFormatter.format(amountPaid),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: AppColors.primary),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainNavigation(initialIndex: 2),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text('My Courses', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: cardRowGap),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (purchasedCourses.isNotEmpty) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainNavigation(initialIndex: 0),
                            ),
                            (route) => false,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LearningScreen(course: purchasedCourses.first),
                            ),
                          );
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainNavigation(initialIndex: 2),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: const Text('Start Learning'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
