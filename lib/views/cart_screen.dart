import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:online_learning_application/providers/cart_provider.dart';
import 'package:online_learning_application/utils/appcolor.dart';
import 'package:online_learning_application/views/checkout_screen.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  String? _appliedCoupon;
  double _couponDiscount = 0.0;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _showCouponDialog(double currentTotal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Apply Coupon',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _couponController,
                      decoration: InputDecoration(
                        hintText: 'Enter coupon code (e.g. DHI20)',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final code = _couponController.text.trim().toUpperCase();
                      if (code == 'DHI20' || code == 'UDEMY20' || code == 'SAVER') {
                        setState(() {
                          _appliedCoupon = code;
                          _couponDiscount = currentTotal * 0.20;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('🎉 20% Coupon Applied Successfully!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid coupon code. Try DHI20'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    },
                    child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _couponController.text = 'DHI20';
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFC4B5FD)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.local_offer, color: AppColors.primary, size: 20),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DHI20', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                          Text('Get 20% extra discount on all cart items', style: TextStyle(fontSize: 12, color: Colors.black87)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery calculation variables
    final mq         = MediaQuery.of(context);
    final sw         = mq.size.width;
    final sh         = mq.size.height;
    final outerPad   = sw * 0.040;
    final sectionGap = sh * 0.022;
    final cardRowGap = sw * 0.028;

    final cartProvider = Provider.of<CartProvider>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

    final double baseTotal = cartProvider.totalDiscountedPrice;
    final double finalTotal = (baseTotal - _couponDiscount).clamp(0.0, double.infinity);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: outerPad,
        title: const Text(
          'Shopping Cart',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: cartProvider.cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                  SizedBox(height: sectionGap),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore courses and add them to your cart',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cart Item Count Header: "N Courses in Cart"
                Padding(
                  padding: EdgeInsets.fromLTRB(outerPad, 16, outerPad, 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${cartProvider.cartItems.length} ${cartProvider.cartItems.length == 1 ? 'Course' : 'Courses'} in Cart',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, thickness: 1),

                // List of Cart Items
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: outerPad, vertical: 12),
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.cartItems[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: Colors.white,
                        surfaceTintColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Course Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: item.thumbnail.startsWith('http')
                                  ? CachedNetworkImage(
                                      imageUrl: item.thumbnail,
                                      width: (sw * 0.28).clamp(90.0, 120.0),
                                      height: 75,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      item.thumbnail,
                                      width: (sw * 0.28).clamp(90.0, 120.0),
                                      height: 75,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            SizedBox(width: cardRowGap),

                            // Course Info Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppColors.textDark,
                                      height: 1.25,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'By ${item.instructor}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 11.5, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: [
                                      if (item.isPopular)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                          color: const Color(0xFFECEB98),
                                          child: const Text('Bestseller', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                      Text(
                                        '${item.rating}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFB45309),
                                        ),
                                      ),
                                      const Icon(Icons.star, color: Color(0xFFF59E0B), size: 12),
                                      Text(
                                        '(${NumberFormat.compact().format(item.studentsEnrolled)} ratings)',
                                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.duration} • ${item.lessons.length} lectures • All Levels',
                                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7C3AED),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.verified, size: 12, color: Colors.white),
                                        SizedBox(width: 4),
                                        Text('Premium', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: const Text('Remove Course'),
                                                  content: const Text('Do you want to remove this course from the cart?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        cartProvider.removeFromCart(item.id);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text('Item removed from cart')),
                                                        );
                                                      },
                                                      child: const Text('Remove', style: TextStyle(color: Color(0xFF7C3AED))),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: const Text('Remove', style: TextStyle(color: Color(0xFF7C3AED), fontSize: 12)),
                                          ),

                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            currencyFormatter.format(item.discountedPrice),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF7C3AED),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.local_offer, color: Color(0xFF7C3AED), size: 14),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                    left: outerPad, 
                    right: outerPad, 
                    top: 16, 
                    bottom: 16 + mq.padding.bottom,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                    border: Border(top: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total Label and Total Price
                      if (_appliedCoupon != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.green[300]!),
                            ),
                            child: Text(
                              'Coupon: $_appliedCoupon (-${currencyFormatter.format(_couponDiscount)})',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(fontSize: 20, color: Colors.grey[700], fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            currencyFormatter.format(finalTotal),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Primary Button: Proceed to Checkout ->
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C3AED), // Vibrant Purple
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Proceed to Checkout',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Outlined Button: Apply Coupon
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF7C3AED),
                            side: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _showCouponDialog(baseTotal),
                          child: const Text(
                            'Apply Coupon',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
