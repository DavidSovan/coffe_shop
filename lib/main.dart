import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uc_coffee_shop/features/orders/viewmodel/order_viewmodel.dart';
import 'package:uc_coffee_shop/features/product/viewmodel/cart_viewmodel.dart';
import 'package:uc_coffee_shop/features/product/viewmodel/product_viewmodel.dart';
import 'package:uc_coffee_shop/theme/app_theme.dart';
import 'features/auth/view/login_screen.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uc_coffee_shop/features/payments/viewmodel/payment_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => ProductViewModel()),
        ChangeNotifierProvider(create: (context) => CartViewModel()),
        ChangeNotifierProvider(create: (context) => OrderViewModel()),
        ChangeNotifierProvider(create: (context) => PaymentViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Coffee Shop',
        theme: CoffeeShopTheme.lightTheme,
        darkTheme: CoffeeShopTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const LoginScreen(),
      ),
    );
  }
}
