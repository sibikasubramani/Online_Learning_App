import 'package:online_learning_application/models/lesson.dart';

class Course {
  final String id;
  final String title;
  final String instructor;
  final double rating;
  final int studentsEnrolled;
  final double originalPrice;
  final double discountedPrice;
  final String category;
  final String thumbnail;
  final String description;
  final List<String> whatYouWillLearn;
  final String duration;
  final List<Lesson> lessons;
  final bool isFeatured;
  final bool isPopular;

  Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.rating,
    required this.studentsEnrolled,
    required this.originalPrice,
    required this.discountedPrice,
    required this.category,
    required this.thumbnail,
    required this.description,
    required this.whatYouWillLearn,
    required this.duration,
    required this.lessons,
    this.isFeatured = false,
    this.isPopular = false,
  });

  int get discountPercentage {
    if (originalPrice == 0) return 0;
    return (((originalPrice - discountedPrice) / originalPrice) * 100).round();
  }

  bool get isFree => discountedPrice == 0;
}
