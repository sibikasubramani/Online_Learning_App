import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:online_learning_application/models/course.dart';
import 'package:online_learning_application/utils/appcolor.dart';
import 'package:online_learning_application/views/course_details_screen.dart';
import 'package:intl/intl.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isHorizontal;

  const CourseCard({
    super.key,
    required this.course,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final mq         = MediaQuery.of(context);
    final sw         = mq.size.width;
    final sh         = mq.size.height;
    final outerPad   = sw * 0.040;
    final cardGap    = sh * 0.014;
    final cardRowGap = sw * 0.028;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final cardWidth = isHorizontal ? sw * 0.65 : double.infinity;
    final imageHeight = isHorizontal ? sh * 0.15 : sh * 0.20;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsScreen(course: course),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.only(bottom: cardGap, right: isHorizontal ? cardRowGap : 0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: course.thumbnail.startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: course.thumbnail,
                          height: imageHeight,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: imageHeight,
                            color: AppColors.surfaceVariant,
                            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: imageHeight,
                            color: AppColors.primary.withOpacity(0.1),
                            child: const Icon(Icons.school, size: 48, color: AppColors.primary),
                          ),
                        )
                      : Image.asset(
                          course.thumbnail,
                          height: imageHeight,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: imageHeight,
                            color: AppColors.primary.withOpacity(0.1),
                            child: const Icon(Icons.school, size: 48, color: AppColors.primary),
                          ),
                        ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      course.category,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: EdgeInsets.all(outerPad * 0.75),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: cardGap * 0.4),
                  Text(
                    'by ${course.instructor}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMid,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: cardGap * 0.6),
                  
                  // Rating & Enrolled
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.star, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${course.rating}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '|   ${NumberFormat.compact().format(course.studentsEnrolled)} students',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMid,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: cardGap * 0.8),

                  // Pricing
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (course.isFree)
                        const Text(
                          'FREE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.green,
                          ),
                        )
                      else ...[
                        Text(
                          currencyFormatter.format(course.discountedPrice),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          currencyFormatter.format(course.originalPrice),
                          style: const TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.discountBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${course.discountPercentage}% OFF',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.discountText,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
