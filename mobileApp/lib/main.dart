import 'package:flutter/material.dart';
import 'package:road_safe_app/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs;
  String? token;

  try {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  } catch (e) {
    print('Error retrieving token: $e');
  }

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({
    required this.token,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
          SplashScreen(token: token), // Use SplashScreen as the initial screen
    );
  }
}
