import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:online_learning_application/providers/course_provider.dart';
import 'package:online_learning_application/providers/cart_provider.dart';
import 'package:online_learning_application/utils/appcolor.dart';
import 'package:online_learning_application/utils/app_theme.dart';
import 'package:online_learning_application/views/main_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.darkPurple,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: MaterialApp(
          title: 'Online Learning App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const MainNavigation(),
        ),
      ),
    );
  }
}
