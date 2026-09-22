import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_learning_application/data/mock_data.dart';
import 'package:online_learning_application/providers/course_provider.dart';
import 'package:online_learning_application/utils/appcolor.dart';
import 'package:online_learning_application/widgets/course_card.dart';
import 'package:online_learning_application/views/search_filter_screen.dart';
import 'package:online_learning_application/views/categories_screen.dart';
import 'package:online_learning_application/views/notification_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onSeeAllCategoriesTap;
  const HomeScreen({super.key, this.onSeeAllCategoriesTap});

  void _showFilterModal(BuildContext context) {
    final mq         = MediaQuery.of(context);
    final sh         = mq.size.height;
    final modalHeight = sh * 0.75;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final provider = Provider.of<CourseProvider>(context);

            return Container(
              height: modalHeight,
              color: AppColors.surface,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter & Sort',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      TextButton(
                        onPressed: () {
                          provider.clearFilters();
                          setModalState(() {});
                        },
                        child: const Text('Reset All', style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      children: [
                        // Categories
                        const Text('Categories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: MockData.categories.map((cat) {
                            final isSelected = provider.selectedCategories.contains(cat);
                            return FilterChip(
                              label: Text(cat),
                              selected: isSelected,
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              checkmarkColor: AppColors.primary,
                              onSelected: (val) {
                                provider.toggleCategory(cat);
                                setModalState(() {});
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        // Price
                        const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: ['All', 'Free', 'Under ₹500', '₹500-₹1,000', 'Above ₹1,000'].map((price) {
                            final isSelected = provider.selectedPriceFilter == price;
                            return ChoiceChip(
                              label: Text(price),
                              selected: isSelected,
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              onSelected: (selected) {
                                if (selected) {
                                  provider.setPriceFilter(price);
                                  setModalState(() {});
                                }
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        // Rating
                        const Text('Rating', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: ['All', '4★ & above', '3★ & above'].map((rating) {
                            final isSelected = provider.selectedRatingFilter == rating;
                            return ChoiceChip(
                              label: Text(rating),
                              selected: isSelected,
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              onSelected: (selected) {
                                if (selected) {
                                  provider.setRatingFilter(rating);
                                  setModalState(() {});
                                }
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        // Sort By
                        const Text('Sort Options', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                        const SizedBox(height: 8),
                        Column(
                          children: [
                            RadioListTile<SortOption>(
                              title: const Text('Popular'),
                              value: SortOption.popular,
                              groupValue: provider.selectedSortOption,
                              onChanged: (val) {
                                if (val != null) {
                                  provider.setSortOption(val);
                                  setModalState(() {});
                                }
                              },
                            ),
                            RadioListTile<SortOption>(
                              title: const Text('Highest Rated'),
                              value: SortOption.highestRated,
                              groupValue: provider.selectedSortOption,
                              onChanged: (val) {
                                if (val != null) {
                                  provider.setSortOption(val);
                                  setModalState(() {});
                                }
                              },
                            ),
                            RadioListTile<SortOption>(
                              title: const Text('Price: Low → High'),
                              value: SortOption.priceLowHigh,
                              groupValue: provider.selectedSortOption,
                              onChanged: (val) {
                                if (val != null) {
                                  provider.setSortOption(val);
                                  setModalState(() {});
                                }
                              },
                            ),
                            RadioListTile<SortOption>(
                              title: const Text('Price: High → Low'),
                              value: SortOption.priceHighLow,
                              groupValue: provider.selectedSortOption,
                              onChanged: (val) {
                                if (val != null) {
                                  provider.setSortOption(val);
                                  setModalState(() {});
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SearchFilterScreen()),
                        );
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ),
            ),
            );
          },
        );
      },
    );
  }

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
    final double featuredHeight = sh * 0.35;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        titleSpacing: outerPad,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'DhiGrowth',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: outerPad),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationScreen()),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                child: const Icon(Icons.notifications_none, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: outerPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: outerPad),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SearchFilterScreen()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: outerPad, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: AppColors.textLight),
                            SizedBox(width: cardRowGap),
                            const Expanded(
                              child: Text(
                                'Search courses...',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: AppColors.textLight, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter Button
                  GestureDetector(
                    onTap: () => _showFilterModal(context),
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.tune_rounded, color: Colors.white),
                        ),
                        if (Provider.of<CourseProvider>(context).selectedCategories.isNotEmpty ||
                            Provider.of<CourseProvider>(context).selectedPriceFilter != 'All' ||
                            Provider.of<CourseProvider>(context).selectedRatingFilter != 'All')
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sectionGap),

            // Categories Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: outerPad),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  TextButton(
                    onPressed: () {
                      if (onSeeAllCategoriesTap != null) {
                        onSeeAllCategoriesTap!();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CategoriesScreen()),
                        );
                      }
                    },
                    child: const Text('See All', style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            SizedBox(height: cardGap * 0.5),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: outerPad),
                itemCount: MockData.categories.length,
                itemBuilder: (context, index) {
                  final category = MockData.categories[index];
                  return GestureDetector(
                    onTap: () {
                      courseProvider.clearFilters();
                      courseProvider.toggleCategory(category);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchFilterScreen()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: cardRowGap),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primary),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: sectionGap),

            // Featured Courses Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: outerPad),
              child: const Text('Featured Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ),
            SizedBox(height: cardGap),
            SizedBox(
              height: featuredHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: outerPad),
                itemCount: courseProvider.featuredCourses.length,
                itemBuilder: (context, index) {
                  return CourseCard(
                    course: courseProvider.featuredCourses[index],
                    isHorizontal: true,
                  );
                },
              ),
            ),
            SizedBox(height: sectionGap),

            // Popular Courses Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: outerPad),
              child: const Text('Popular Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ),
            SizedBox(height: cardGap),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: outerPad),
              itemCount: courseProvider.popularCourses.length,
              itemBuilder: (context, index) {
                return CourseCard(course: courseProvider.popularCourses[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
