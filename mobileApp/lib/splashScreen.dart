import 'dart:async';
import 'package:flutter/material.dart';
import 'package:road_safe_app/dashboard.dart';
import 'package:road_safe_app/sign_in_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashScreen extends StatefulWidget {
  final String? token;

  const SplashScreen({required this.token, Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  _navigateToNext() async {
    await Future.delayed(Duration(seconds: 2));
    if (widget.token != null && !JwtDecoder.isExpired(widget.token!)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard(token: widget.token!)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.clamp,
            colors: [Colors.blue, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(10.0), // Adjust the radius as needed
                child: Image.asset(
                  'assets/images/appIcon.png',
                  width: 130,
                  height: 130,
                  fit: BoxFit
                      .cover, // Ensure the image fits within the rounded corners
                ),
              ),
              SizedBox(height: 20),
              Text(
                'RoadSafe',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
