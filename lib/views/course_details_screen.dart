import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:online_learning_application/models/course.dart';
import 'package:online_learning_application/providers/cart_provider.dart';
import 'package:online_learning_application/providers/course_provider.dart';
import 'package:online_learning_application/utils/appcolor.dart';
import 'package:online_learning_application/views/checkout_screen.dart';
import 'package:online_learning_application/views/learning_screen.dart';
import 'package:intl/intl.dart';

class CourseDetailsScreen extends StatelessWidget {
  final Course course;

  const CourseDetailsScreen({super.key, required this.course});

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
    final courseProvider = Provider.of<CourseProvider>(context);
    final isEnrolled = courseProvider.purchasedCourses.any((c) => c.id == course.id);
    final isInCart = cartProvider.isInCart(course.id);
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    final double imageHeight = sh * 0.26;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Course Details'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(outerPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: course.thumbnail.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: course.thumbnail,
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: imageHeight,
                        color: AppColors.surfaceVariant,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: imageHeight,
                        color: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(Icons.broken_image, color: AppColors.primary, size: 50),
                      ),
                    )
                  : Image.asset(
                      course.thumbnail,
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: imageHeight,
                        color: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(Icons.broken_image, color: AppColors.primary, size: 50),
                      ),
                    ),
            ),
            SizedBox(height: cardGap),

            // Category badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                course.category,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Title & Instructor
            Text(
              course.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Created by ${course.instructor}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textMid,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: cardGap),

            // Rating, Students, Duration
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.star, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${course.rating}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${course.studentsEnrolled} students)',
                  style: const TextStyle(color: AppColors.textMid, fontSize: 13),
                ),
                const Spacer(),
                const Icon(Icons.schedule, size: 16, color: AppColors.textMid),
                const SizedBox(width: 4),
                Text(
                  course.duration,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark),
                ),
              ],
            ),
            const Divider(height: 32),

            // Price Section
            Row(
              children: [
                if (course.isFree)
                  const Text(
                    'FREE',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.green),
                  )
                else ...[
                  Text(
                    currencyFormatter.format(course.discountedPrice),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    currencyFormatter.format(course.originalPrice),
                    style: const TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.lineThrough,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.discountBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${course.discountPercentage}% OFF',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.discountText),
                    ),
                  ),
                ],
              ],
            ),
            const Divider(height: 32),

            // What You'll Learn
            const Text('What you\'ll learn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(outerPad * 0.75),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: course.whatYouWillLearn.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 14, color: AppColors.textDark),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: sectionGap),

            // Description
            const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 8),
            Text(
              course.description,
              style: const TextStyle(fontSize: 14, color: AppColors.textMid, height: 1.4),
            ),
            SizedBox(height: sectionGap),

            // Course Curriculum Breakdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Course Curriculum', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                Text(
                  '${course.lessons.length} Lessons',
                  style: const TextStyle(color: AppColors.textMid, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: course.lessons.length,
              itemBuilder: (context, index) {
                final lesson = course.lessons[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                    title: Text(
                      lesson.title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
                    ),
                    trailing: Text(
                      lesson.duration,
                      style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                    ),
                  ),
                  ),
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: isEnrolled
          ? Container(
              padding: EdgeInsets.only(
                left: outerPad, right: outerPad, top: outerPad, bottom: outerPad + mq.padding.bottom
              ),
              color: AppColors.cardBg,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LearningScreen(course: course),
                      ),
                    );
                  },
                  child: const Text('Continue Learning'),
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.only(
                left: outerPad, right: outerPad, top: outerPad, bottom: outerPad + mq.padding.bottom
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: AppColors.primary),
                      ),
                      onPressed: () {
                        if (isInCart) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Course already in cart!')),
                          );
                        } else {
                          cartProvider.addToCart(course);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to Cart!')),
                          );
                        }
                      },
                      child: Text(
                        isInCart ? 'In Cart' : 'Add to Cart',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(width: cardRowGap),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (!isInCart) {
                          cartProvider.addToCart(course);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutScreen(),
                          ),
                        );
                      },
                      child: const Text('Buy Now'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
