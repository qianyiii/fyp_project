import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fyp_project/add_product.dart';
import 'package:fyp_project/firebase_options.dart';
import 'package:fyp_project/home.dart';
import 'package:fyp_project/login.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(SmartCheckout());
}


class SmartCheckout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
          )
      ),
      // This defines the route it should start with
      initialRoute: Login.id,
      //This defines the available named routes and the widgets to build when navigating to those routes
      routes: {
        Login.id: (context) => Login(),
        Home.id: (context) => Home(),
        AddProductPage.id: (context) => AddProductPage()
      },
    );
  }
}