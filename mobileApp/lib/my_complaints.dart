import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:road_safe_app/config.dart';
import 'package:road_safe_app/utils/app_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class my_complaint extends StatefulWidget {
  final token;
  const my_complaint({@required this.token, Key? key}) : super(key: key);

  @override
  State<my_complaint> createState() => _my_complaintState();
}

class _my_complaintState extends State<my_complaint> {
  List? items;
  List? cnt;
  bool isLoading = true;
  late String email;
  late String Uid;

  @override
  void initState() {
    super.initState();

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    Uid = jwtDecodedToken['_id'];
    getComplaintDetails(email);
  }

  void getComplaintDetails(email) async {
    setState(() {
      isLoading = true; // Set isLoading to true before making the request
    });
    var reqBody = {"email": email};

    var response = await http.post(Uri.parse(getComplaintData),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    var jsonResponse = jsonDecode(response.body);

    items = jsonResponse['success'];
    cnt = jsonResponse['count'];

    setState(() {
      isLoading = false; // Set isLoading to false after getting the response
    });
  }

  void deleteItem(id) async {
    var reqBody = {"id": id};

    var response = await http.post(Uri.parse(deleteComplaints),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      getComplaintDetails(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Complaint Status"),
            backgroundColor: Colors.amber),
        drawer: const AppDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (cnt != null && cnt!.isNotEmpty)
                      Text(
                        'Total number of Complaint raised : ${cnt![0]}',
                        style: TextStyle(fontSize: 17),
                      ),
                    if (cnt != null && cnt!.isNotEmpty)
                      Text('Total number of Completed : ${cnt![1]}',
                          style: TextStyle(fontSize: 17)),
                    if (cnt != null && cnt!.isNotEmpty)
                      Text('Total number of Inprocess raised : ${cnt![2]}',
                          style: TextStyle(fontSize: 17)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: isLoading
                    ? const Center(
                        // Show loading indicator if isLoading is true
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.amber),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: items == null
                            ? null
                            : ListView.builder(
                                itemCount: items!.length,
                                itemBuilder: (context, int index) {
                                  int reverseIndex = items!.length - 1 - index;
                                  return Slidable(
                                    key: ValueKey(items![reverseIndex]['_id']),
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          backgroundColor: Color(0xFFFE4A49),
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                          onPressed: (BuildContext context) {
                                            print(
                                                '${items![reverseIndex]['_id']}');
                                            deleteItem(
                                                '${items![reverseIndex]['_id']}');
                                          },
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      // borderOnForeground: false,
                                      child: ListTile(
                                        // leading: Icon(Icons.task),
                                        title: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            items![reverseIndex]['objectUrl'],
                                            width: 50,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: 'Complaint Id : ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold, // Make the "Email :" text bold
                                                  fontSize:
                                                      16, // Set the font size
                                                  color: Colors.black,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        '${items![reverseIndex]['_id']}',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight
                                                          .normal, // Keep the email text normal
                                                      fontSize:
                                                          16, // Set the font size
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                                'Address : ${items![reverseIndex]['location']}'),
                                            Text(
                                                'Category : ${items![reverseIndex]['category'][0]}'),
                                            Text(
                                                'Description : ${items![reverseIndex]['description']}'),
                                            Text(
                                                'Date : ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(items![reverseIndex]['createdAt']).toLocal())}'),
                                            SizedBox(height: 8),
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10), // Add border radius
                                              ),
                                              // isComplaintRaised ? 'Complaint raised!' : 'No complaint raised',
                                              child: Text(
                                                ("${items![reverseIndex]['status']}" ==
                                                        'Update Status')
                                                    ? "Complaint raised!"
                                                    : "${items![reverseIndex]['status']}",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Icon(Icons.arrow_back),
                                      ),
                                    ),
                                  );
                                }),
                      ),
              ),
            )
          ],
        ));
  }
}
