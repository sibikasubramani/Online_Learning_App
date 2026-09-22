import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:online_learning_application/models/course.dart';
import 'package:online_learning_application/providers/course_provider.dart';
import 'package:online_learning_application/providers/cart_provider.dart';
import 'package:online_learning_application/utils/appcolor.dart';
import 'package:online_learning_application/views/course_details_screen.dart';
import 'package:online_learning_application/views/search_filter_screen.dart';
import 'package:intl/intl.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _selectedCategory = 'Flutter';
  String _activeTab = 'Most popular'; // 'Most popular' | 'Trending'
  bool _showAllCategories = false;

  final List<String> _allCategories = const [
    'Flutter', 'Web Development', 'Data Science', 'Mobile Development', 
    'Programming Languages', 'Game Development', 'Database Design', 'Software Testing',
    'Java', 'Python', 'UI/UX', 'DevOps', 
    'Machine Learning', 'Cybersecurity', 'Cloud Computing', 'Android', 
    'iOS', 'React Native', 'Blockchain', 'DSA', 'Networking'
  ];

  @override
  Widget build(BuildContext context) {
    final mq         = MediaQuery.of(context);
    final sw         = mq.size.width;
    final sh         = mq.size.height;
    final outerPad   = sw * 0.040;
    final sectionGap = sh * 0.022;
    final cardGap    = sh * 0.014;
    final cardRowGap = sw * 0.028;

    final courseProvider = Provider.of<CourseProvider>(context);

    // Filter courses by selected category
    List<Course> categoryCourses = courseProvider.allCourses
        .where((c) => c.category.toLowerCase().contains(_selectedCategory.toLowerCase()) ||
                      _selectedCategory.toLowerCase().contains(c.category.toLowerCase()))
        .toList();

    // Fallback to all courses if category has no direct mock items
    if (categoryCourses.isEmpty) {
      categoryCourses = courseProvider.allCourses.take(5).toList();
    }

    if (_activeTab == 'Trending') {
      categoryCourses.sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      categoryCourses.sort((a, b) => b.studentsEnrolled.compareTo(a.studentsEnrolled));
    }

    // Dynamic Category Rows:
    // Collapsed: 2 rows only (Row 1: 3 categories, Row 2: 2 categories + '__MORE__')
    // Expanded: Rows of 3 categories each + '__LESS__'
    List<List<String>> categoryRows = [];
    if (!_showAllCategories) {
      final row1 = _allCategories.sublist(0, 3.clamp(0, _allCategories.length));
      final row2 = [
        ..._allCategories.sublist(3.clamp(0, _allCategories.length), 5.clamp(0, _allCategories.length)),
        '__MORE__'
      ];
      categoryRows = [row1, row2];
    } else {
      final List<String> fullList = List.from(_allCategories)..add('__LESS__');
      for (int i = 0; i < fullList.length; i += 3) {
        final end = (i + 3 < fullList.length) ? i + 3 : fullList.length;
        categoryRows.add(fullList.sublist(i, end));
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: outerPad,
        title: const Text(
          'Explore Categories',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dynamic Rows Categories Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < categoryRows.length; i++) ...[
                    if (i > 0) SizedBox(height: cardGap),
                    _buildCategoryRow(categoryRows[i], outerPad, cardRowGap),
                  ],
                ],
              ),
            ),

            SizedBox(height: sectionGap),

            // Header Section: "[Category] Courses"
            Padding(
              padding: EdgeInsets.symmetric(horizontal: outerPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_selectedCategory Courses',
                    style: TextStyle(
                      fontSize: (sw * 0.065).clamp(22.0, 30.0),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: cardGap),
                  const Text(
                    'Courses to get you started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Explore courses from experienced, real-world experts.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Sub-tabs: "Most popular" | "Trending"
            Padding(
              padding: EdgeInsets.symmetric(horizontal: outerPad),
              child: Row(
                children: [
                  _buildSubTab('Most popular'),
                  const SizedBox(width: 24),
                  _buildSubTab('Trending'),
                ],
              ),
            ),
            
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 20),

            // Horizontal Scrollable Course Cards Section
            SizedBox(
              height: 255,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: outerPad),
                itemCount: categoryCourses.length,
                itemBuilder: (context, index) {
                  return _buildUdemyCourseCard(categoryCourses[index], sw, cardRowGap);
                },
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(List<String> categories, double outerPad, double cardRowGap) {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: outerPad),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];

          if (cat == '__MORE__') {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _showAllCategories = true;
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: cardRowGap),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'More',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            );
          }

          if (cat == '__LESS__') {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _showAllCategories = false;
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: cardRowGap),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Less',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_up, size: 16, color: Colors.black87),
                  ],
                ),
              ),
            );
          }

          final isSelected = _selectedCategory.toLowerCase() == cat.toLowerCase();

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: cardRowGap),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.textDark : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.textDark : Colors.grey[300]!,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                  color: isSelected ? Colors.white : AppColors.textDark,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubTab(String title) {
    final isSelected = _activeTab == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = title;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? AppColors.textDark : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: isSelected ? 40 : 0,
            color: isSelected ? AppColors.textDark : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildUdemyCourseCard(Course course, double sw, double cardRowGap) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Container(
      width: (sw * 0.72).clamp(260.0, 320.0),
      margin: EdgeInsets.only(right: cardRowGap),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailsScreen(course: course),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image with "Premium" Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: course.thumbnail.startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: course.thumbnail,
                          height: 95,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          course.thumbnail,
                          height: 95,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED), // Violet Premium Badge
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.workspace_premium, color: Colors.white, size: 10),
                        SizedBox(width: 2),
                        Text(
                          'Premium',
                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    course.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 1),
                  // Instructor
                  Text(
                    course.instructor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Tags: Bestseller | Course | ⭐ 4.7 | Ratings
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    runSpacing: 2,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECE9FE),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFC4B5FD)),
                        ),
                        child: const Text(
                          'Bestseller',
                          style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: const Text(
                          'Course',
                          style: TextStyle(fontSize: 8.5, color: Colors.black87),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFB45309), size: 12),
                          const SizedBox(width: 1),
                          Text(
                            '${course.rating}',
                            style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${NumberFormat.compact().format(course.studentsEnrolled)})',
                            style: TextStyle(fontSize: 9.5, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Pricing & Quick Add to Cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            currencyFormatter.format(course.discountedPrice),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            currencyFormatter.format(course.originalPrice),
                            style: TextStyle(
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          cartProvider.addToCart(course);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to Cart!')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add_shopping_cart, color: AppColors.primary, size: 16),
                        ),
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
  }
}
