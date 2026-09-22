import 'package:flutter/material.dart';
import 'package:online_learning_application/models/course.dart';

class CartProvider with ChangeNotifier {
  List<Course> _cartItems = [];

  List<Course> get cartItems => _cartItems;

  void addToCart(Course course) {
    if (!_cartItems.any((item) => item.id == course.id)) {
      _cartItems.add(course);
      notifyListeners();
    }
  }

  void removeFromCart(String courseId) {
    _cartItems.removeWhere((item) => item.id == courseId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  bool isInCart(String courseId) {
    return _cartItems.any((item) => item.id == courseId);
  }

  double get totalOriginalPrice {
    return _cartItems.fold(0, (sum, item) => sum + item.originalPrice);
  }

  double get totalDiscountedPrice {
    return _cartItems.fold(0, (sum, item) => sum + item.discountedPrice);
  }

  double get totalDiscount {
    return totalOriginalPrice - totalDiscountedPrice;
  }
}
