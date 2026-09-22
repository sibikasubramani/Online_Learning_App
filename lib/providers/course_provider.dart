import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:online_learning_application/models/course.dart';
import 'package:online_learning_application/data/mock_data.dart';

enum SortOption { popular, highestRated, priceLowHigh, priceHighLow }

class CourseProvider with ChangeNotifier {
  List<Course> _allCourses = MockData.courses;
  
  // Search & Filter State
  String _searchQuery = '';
  List<String> _selectedCategories = [];
  String _selectedPriceFilter = 'All'; // 'All', 'Free', 'Under ₹500', '₹500-₹1,000', 'Above ₹1,000'
  String _selectedRatingFilter = 'All'; // 'All', '4★ & above', '3★ & above'
  SortOption _selectedSortOption = SortOption.popular;

  // Search History
  final List<String> _searchHistory = [
    'Flutter',
    'Python',
    'UI/UX',
    'Machine Learning',
    'Java',
    'Web Development'
  ];

  // Purchased Courses
  List<Course> _purchasedCourses = [];

  CourseProvider() {
    _loadLocalData();
  }

  Future<void> _loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final purchasedIds = prefs.getStringList('purchased_courses') ?? [];
    _purchasedCourses = _allCourses.where((c) => purchasedIds.contains(c.id)).toList();
    
    final completedLessonIds = prefs.getStringList('completed_lessons') ?? [];
    for (var course in _purchasedCourses) {
      for (var lesson in course.lessons) {
        if (completedLessonIds.contains(lesson.id)) {
          lesson.isCompleted = true;
        }
      }
    }
    
    notifyListeners();
  }

  List<Course> get allCourses => _allCourses;
  List<Course> get featuredCourses => _allCourses.where((c) => c.isFeatured).toList();
  List<Course> get popularCourses => _allCourses.where((c) => c.isPopular).toList();
  List<Course> get purchasedCourses => _purchasedCourses;

  // Search & Filter Getters
  String get searchQuery => _searchQuery;
  List<String> get searchHistory => _searchHistory;
  List<String> get selectedCategories => _selectedCategories;
  String get selectedPriceFilter => _selectedPriceFilter;
  String get selectedRatingFilter => _selectedRatingFilter;
  SortOption get selectedSortOption => _selectedSortOption;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addSearchHistory(String query) {
    if (query.trim().isEmpty) return;
    final cleanQuery = query.trim();
    _searchHistory.remove(cleanQuery);
    _searchHistory.insert(0, cleanQuery);
    if (_searchHistory.length > 10) {
      _searchHistory.removeLast();
    }
    notifyListeners();
  }

  void clearSearchHistory() {
    _searchHistory.clear();
    notifyListeners();
  }

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  void setPriceFilter(String filter) {
    _selectedPriceFilter = filter;
    notifyListeners();
  }

  void setRatingFilter(String filter) {
    _selectedRatingFilter = filter;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _selectedSortOption = option;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategories.clear();
    _selectedPriceFilter = 'All';
    _selectedRatingFilter = 'All';
    _selectedSortOption = SortOption.popular;
    notifyListeners();
  }

  List<Course> get filteredAndSortedCourses {
    List<Course> result = _allCourses.toList();

    // 1. Apply Search
    if (_searchQuery.isNotEmpty) {
      final lowerQuery = _searchQuery.toLowerCase();
      result = result.where((c) {
        return c.title.toLowerCase().contains(lowerQuery) ||
               c.instructor.toLowerCase().contains(lowerQuery) ||
               c.category.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    // 2. Apply Category Filter
    if (_selectedCategories.isNotEmpty) {
      result = result.where((c) => _selectedCategories.contains(c.category)).toList();
    }

    // 3. Apply Price Filter
    if (_selectedPriceFilter != 'All') {
      result = result.where((c) {
        if (_selectedPriceFilter == 'Free') return c.discountedPrice == 0;
        if (_selectedPriceFilter == 'Under ₹500') return c.discountedPrice > 0 && c.discountedPrice < 500;
        if (_selectedPriceFilter == '₹500-₹1,000') return c.discountedPrice >= 500 && c.discountedPrice <= 1000;
        if (_selectedPriceFilter == 'Above ₹1,000') return c.discountedPrice > 1000;
        return true;
      }).toList();
    }

    // 4. Apply Rating Filter
    if (_selectedRatingFilter != 'All') {
      result = result.where((c) {
        if (_selectedRatingFilter == '4★ & above') return c.rating >= 4.0;
        if (_selectedRatingFilter == '3★ & above') return c.rating >= 3.0;
        return true;
      }).toList();
    }

    // 5. Apply Sorting
    switch (_selectedSortOption) {
      case SortOption.popular:
        result.sort((a, b) => b.studentsEnrolled.compareTo(a.studentsEnrolled));
        break;
      case SortOption.highestRated:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.priceLowHigh:
        result.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;
      case SortOption.priceHighLow:
        result.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
        break;
    }

    return result;
  }

  Future<void> purchaseCourses(List<Course> courses) async {
    final prefs = await SharedPreferences.getInstance();
    final purchasedIds = prefs.getStringList('purchased_courses') ?? [];
    
    bool updated = false;
    for (var course in courses) {
      if (!_purchasedCourses.any((c) => c.id == course.id)) {
        _purchasedCourses.add(course);
        purchasedIds.add(course.id);
        updated = true;
      }
    }
    
    if (updated) {
      await prefs.setStringList('purchased_courses', purchasedIds);
      notifyListeners();
    }
  }

  Future<void> markLessonCompleted(String courseId, String lessonId) async {
    final courseIndex = _purchasedCourses.indexWhere((c) => c.id == courseId);
    if (courseIndex != -1) {
      final course = _purchasedCourses[courseIndex];
      final lesson = course.lessons.firstWhere((l) => l.id == lessonId);
      
      if (!lesson.isCompleted) {
        lesson.isCompleted = true;
        
        final prefs = await SharedPreferences.getInstance();
        final completedLessonIds = prefs.getStringList('completed_lessons') ?? [];
        if (!completedLessonIds.contains(lessonId)) {
          completedLessonIds.add(lessonId);
          await prefs.setStringList('completed_lessons', completedLessonIds);
        }
        
        notifyListeners();
      }
    }
  }

  double getCourseProgress(Course course) {
    if (course.lessons.isEmpty) return 0.0;
    int completedCount = course.lessons.where((l) => l.isCompleted).length;
    return completedCount / course.lessons.length;
  }
}
