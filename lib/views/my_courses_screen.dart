import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:online_learning_application/providers/course_provider.dart';
import 'package:online_learning_application/utils/appcolor.dart';
import 'package:online_learning_application/views/learning_screen.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

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

    final courseProvider = Provider.of<CourseProvider>(context);
    final purchasedCourses = courseProvider.purchasedCourses;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('My Courses'),
        centerTitle: false,
      ),
      body: purchasedCourses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school_outlined, size: 80, color: AppColors.textLight),
                  SizedBox(height: sectionGap),
                  const Text(
                    'No enrolled courses yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Purchase a course to start learning!',
                    style: TextStyle(fontSize: 14, color: AppColors.textMid),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(outerPad),
              itemCount: purchasedCourses.length,
              itemBuilder: (context, index) {
                final course = purchasedCourses[index];
                final progress = courseProvider.getCourseProgress(course);
                final completedCount = course.lessons.where((l) => l.isCompleted).length;
                final totalLessons = course.lessons.length;
                final percentageInt = (progress * 100).toInt();

                return Container(
                  margin: EdgeInsets.only(bottom: cardGap),
                  padding: EdgeInsets.all(outerPad * 0.8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: course.thumbnail.startsWith('http')
                                ? CachedNetworkImage(
                                    imageUrl: course.thumbnail,
                                    width: sw * 0.22,
                                    height: sw * 0.22,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    course.thumbnail,
                                    width: sw * 0.22,
                                    height: sw * 0.22,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          SizedBox(width: cardRowGap),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'by ${course.instructor}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textMid),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: cardGap),

                      // Progress section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress: $percentageInt%',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark),
                          ),
                          Text(
                            '$completedCount / $totalLessons lessons completed',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMid),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Custom Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: AppColors.surfaceVariant,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                      SizedBox(height: cardGap),

                      // Continue Learning Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.play_circle_fill, size: 20),
                          label: const Text('Continue Learning'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LearningScreen(course: course),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
