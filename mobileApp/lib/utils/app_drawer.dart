import 'package:flutter/material.dart';
import 'package:road_safe_app/dashboard.dart';
import 'package:road_safe_app/my_complaints.dart';
import 'package:road_safe_app/sign_in_page.dart';
import 'package:road_safe_app/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber[600],
              ),
              child: const Text(
                "Road Safe",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.black),
            title: const Text('Home'),
            selected: selectedIndex == 0,
            onTap: () {
              _onItemTapped(0);
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard(
                          token: prefs.getString('token'),
                        )),
              );
            },
          ),
          ListTile(
              leading: const Icon(Icons.check_circle_outline_outlined,
                  color: Colors.black),
              title: const Text('My Complaints'),
              selected: selectedIndex == 1,
              onTap: () {
                // Update the state of the app

                _onItemTapped(1);
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => my_complaint(
                            token: prefs.getString('token'),
                          )),
                );
                // Then close the drawer
              }),
          ListTile(
              leading:
                  const Icon(Icons.account_box_rounded, color: Colors.black),
              title: const Text(
                'Profile',
              ),
              selected: selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => user_profile(
                            token: prefs.getString('token'),
                          )),
                );
              }),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: const Text('Sign Out'),
            selected: selectedIndex == 3,
            onTap: () {
              // Clear JWT token from shared preferences
              prefs.remove('token');

              // Update the state of the app
              _onItemTapped(3);

              // Navigate to the login page
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
