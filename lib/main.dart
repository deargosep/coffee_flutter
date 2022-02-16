import 'package:coffee_flutter/screens/cart_screen.dart';
import 'package:coffee_flutter/screens/home_screen.dart';
import 'package:coffee_flutter/screens/product_screen.dart';
import 'package:coffee_flutter/store/cart.dart';
import 'package:coffee_flutter/store/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      cardColor: Color(0xFFE4F3F7),
      fontFamily: 'Readex',
      textTheme: TextTheme(caption: TextStyle(color: Colors.white)),
      primaryIconTheme: IconThemeData(color: Colors.black, size: 24),
      primaryColorDark: Colors.white,
      colorScheme: ColorScheme.light(),
      shadowColor: Color(0xFF54B2CF),
      buttonColor: Color(0xFF323232),
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.light));

  static ThemeData darkTheme = ThemeData(
      fontFamily: 'Readex',
      scaffoldBackgroundColor: Color(0xFF1F1D2B),
      cardColor: Color(0xFF262836),
      colorScheme: ColorScheme.dark(),
      shadowColor: Color(0xFF4795AD),
      buttonColor: Color(0xFF4795AD),
      textTheme: TextTheme(caption: TextStyle(color: Colors.black)),
      primaryIconTheme: IconThemeData(color: Colors.white),
      primaryColorDark: Color(0xFF1F1D2B),
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle.dark));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Cart()),
          ChangeNotifierProvider(create: (_) => Category()),
        ],
        builder: (context, child) {
          return GetMaterialApp(
            theme: ThemeClass.lightTheme,
            darkTheme: ThemeClass.darkTheme,
            getPages: [
              GetPage(name: '/', page: () => Home()),
              GetPage(name: '/cart', page: () => CartScreen()),
              GetPage(
                  name: '/product',
                  page: () => ProductScreen(),
                  transition: Transition.downToUp),
            ],
          );
        }),
  );
}
