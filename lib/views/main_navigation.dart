import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_learning_application/providers/cart_provider.dart';
import 'package:online_learning_application/utils/appcolor.dart';
import 'package:online_learning_application/views/home_screen.dart';
import 'package:online_learning_application/views/categories_screen.dart';
import 'package:online_learning_application/views/my_courses_screen.dart';
import 'package:online_learning_application/views/cart_screen.dart';
import 'package:online_learning_application/views/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final List<Widget> screens = [
      HomeScreen(
        onSeeAllCategoriesTap: () {
          setState(() {
            _currentIndex = 1; // Switch to Categories navigation tab
          });
        },
      ),
      const CategoriesScreen(),
      const MyCoursesScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'Categories',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.play_lesson_outlined),
            activeIcon: Icon(Icons.play_lesson_rounded),
            label: 'My Courses',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: cartProvider.cartItems.isNotEmpty,
              label: Text('${cartProvider.cartItems.length}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            activeIcon: Badge(
              isLabelVisible: cartProvider.cartItems.isNotEmpty,
              label: Text('${cartProvider.cartItems.length}'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
