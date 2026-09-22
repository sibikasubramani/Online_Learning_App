import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_learning_application/providers/course_provider.dart';
import 'package:online_learning_application/widgets/course_card.dart';
import 'package:online_learning_application/utils/appcolor.dart';
import 'package:online_learning_application/data/mock_data.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CourseProvider>(context, listen: false);
    
    // Clear typed search data when entering the screen
    _searchController.text = '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        provider.setSearchQuery('');
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery calculation method
    final mq = MediaQuery.of(context);
    final sw = mq.size.width;
    final sh = mq.size.height;
    final outerPad = sw * 0.040;
    final sectionGap = sh * 0.022;

    final courseProvider = Provider.of<CourseProvider>(context);
    final results = courseProvider.filteredAndSortedCourses;
    final hasFilters = courseProvider.selectedCategories.isNotEmpty ||
                       courseProvider.selectedPriceFilter != 'All' ||
                       courseProvider.selectedRatingFilter != 'All';
    final isSearching = courseProvider.searchQuery.isNotEmpty || hasFilters;

    return Scaffold(
      backgroundColor: AppColors.bg,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              hintText: 'Search courses, instructors...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            onChanged: (val) {
              courseProvider.setSearchQuery(val);
            },
            onSubmitted: (val) {
              courseProvider.addSearchHistory(val);
            },
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          if (!isSearching) ...[
            if (courseProvider.searchHistory.isNotEmpty) ...[
              // History record
              Padding(
                padding: EdgeInsets.symmetric(horizontal: outerPad),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'History record',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<CourseProvider>(context, listen: false).clearSearchHistory();
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: Colors.black38, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            
            // History Chips
            Padding(
              padding: EdgeInsets.symmetric(horizontal: outerPad),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: courseProvider.searchHistory.map((historyItem) {
                  return InkWell(
                    onTap: () {
                      _searchController.text = historyItem;
                      courseProvider.setSearchQuery(historyItem);
                      courseProvider.addSearchHistory(historyItem);
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE8DCD5)), // light brownish/reddish
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        historyItem,
                        style: const TextStyle(
                          color: Color(0xFF8B645A), // brownish text
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ), // Closing for Padding
            ],

            SizedBox(height: sectionGap * 1.5),

            // You maybe like
            Padding(
              padding: EdgeInsets.symmetric(horizontal: outerPad),
              child: const Text(
                'You maybe like',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: sectionGap),
            
            // Recommended list (just using the first few courses from MockData)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: outerPad),
                itemCount: 3, // Show top 3
                itemBuilder: (context, index) {
                  return CourseCard(course: MockData.courses[index]);
                },
              ),
            ),
          ] else ...[
            // Active filters chip bar
            if (courseProvider.selectedCategories.isNotEmpty ||
                courseProvider.selectedPriceFilter != 'All' ||
                courseProvider.selectedRatingFilter != 'All')
              Container(
                height: 44,
                padding: EdgeInsets.symmetric(horizontal: outerPad),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...courseProvider.selectedCategories.map((cat) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Chip(
                            label: Text(cat, style: const TextStyle(fontSize: 12)),
                            onDeleted: () => courseProvider.toggleCategory(cat),
                          ),
                        )),
                    if (courseProvider.selectedPriceFilter != 'All')
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(courseProvider.selectedPriceFilter, style: const TextStyle(fontSize: 12)),
                          onDeleted: () => courseProvider.setPriceFilter('All'),
                        ),
                      ),
                    if (courseProvider.selectedRatingFilter != 'All')
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(courseProvider.selectedRatingFilter, style: const TextStyle(fontSize: 12)),
                          onDeleted: () => courseProvider.setRatingFilter('All'),
                        ),
                      ),
                  ],
                ),
              ),

            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off_rounded, size: 80, color: AppColors.textLight),
                          SizedBox(height: sectionGap),
                          const Text(
                            'No courses found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Try searching with different keywords or filters.',
                            style: TextStyle(fontSize: 14, color: AppColors.textMid),
                          ),
                          SizedBox(height: sectionGap),
                          ElevatedButton(
                            onPressed: () {
                              _searchController.clear();
                              courseProvider.setSearchQuery('');
                              courseProvider.clearFilters();
                            },
                            child: const Text('Clear All Filters'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(outerPad),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return CourseCard(course: results[index]);
                      },
                    ),
            ),
          ]
        ],
      ),
      ), // Closing for SafeArea
    );
 }
}
