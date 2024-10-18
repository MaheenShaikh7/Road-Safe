import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:road_safe_app/config.dart';
import 'dart:convert';

import 'package:road_safe_app/utils/app_drawer.dart';

class user_profile extends StatefulWidget {
  final token;
  const user_profile({@required this.token, Key? key}) : super(key: key);

  @override
  State<user_profile> createState() => _user_profileState();
}

class _user_profileState extends State<user_profile> {
  List? items;
  late String email;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    userDetails(email);
  }

  void userDetails(email) async {
    setState(() {
      isLoading = true; // Set isLoading to true before making the request
    });
    var reqBody = {"email": email};

    var response = await http.post(Uri.parse(userDetail),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    var jsonResponse = jsonDecode(response.body);

    items = jsonResponse['success'];

    setState(() {
      isLoading = false; // Set isLoading to false after getting the response
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("My Profile"), backgroundColor: Colors.amber),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              if (items != null && items!.isNotEmpty)
                Center(
                    child: (items![0]['userImage'].isNotEmpty)
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.amber,
                                width: 4,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 100,
                              backgroundImage: NetworkImage(items![1]),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.amber,
                                width: 4,
                              ),
                            ),
                            child: const CircleAvatar(
                              child: Icon(Icons.person, size: 150),
                              backgroundColor: Colors.grey,
                              radius: 100,
                            ),
                          )),
              const SizedBox(
                height: 10,
              ),
              if (items != null && items!.isNotEmpty)
                Text(
                  '${items![0]['firstName']} ' + '${items![0]['lastName']}',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              SizedBox(height: 20),
              if (items != null && items!.isNotEmpty)
                Container(
                  width: 340,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'First Name: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors
                                .black, // Ensure the text color is set, as TextSpan doesn't inherit color from RichText
                          ),
                        ),
                        TextSpan(
                          text: items![0]['firstName'],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            // Ensure the text color is set, as TextSpan doesn't inherit color from RichText
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              if (items != null && items!.isNotEmpty)
                Container(
                  width: 340,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Last Name: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors
                                .black, // Ensure the text color is set, as TextSpan doesn't inherit color from RichText
                          ),
                        ),
                        TextSpan(
                          text: items![0]['lastName'],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            // Ensure the text color is set, as TextSpan doesn't inherit color from RichText
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              if (items != null && items!.isNotEmpty)
                Container(
                  width: 340,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Email : ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors
                                .black, // Ensure the text color is set, as TextSpan doesn't inherit color from RichText
                          ),
                        ),
                        TextSpan(
                          text: items![0]['email'],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            // Ensure the text color is set, as TextSpan doesn't inherit color from RichText
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              if (items != null && items!.isNotEmpty)
                Container(
                  width: 340,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(items![0]['createdAt']).toLocal())}'
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Registered on : ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors
                                .black, // Ensure the text color is set, as TextSpan doesn't inherit color from RichText
                          ),
                        ),
                        TextSpan(
                          text: DateFormat('yyyy-MM-dd HH:mm:ss').format(
                              DateTime.parse(items![0]['createdAt']).toLocal()),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            // Ensure the text color is set, as TextSpan doesn't inherit color from RichText
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              if (isLoading)
                const Center(
                  // Show loading indicator if isLoading is true
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
