import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:road_safe_app/complaint_status.dart';
import 'package:road_safe_app/config.dart';
import 'package:road_safe_app/retry_status.dart';
import 'package:road_safe_app/utils/app_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Dashboard extends StatefulWidget {
  final token;
  const Dashboard({@required this.token, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController problemController = TextEditingController();

  // Picking Up Image
  io.File? selectedImage;

  late String img64;
  late String base64String;
  bool isLoading = false;
  late List<String> parts;
  late String type;
  late Uint8List imageData;

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = io.File(returnedImage!.path);
    });

    imageData = await readImageFile(selectedImage!.path);
    String selectedImg = selectedImage.toString();
    parts = selectedImg.split('.');
    String extension_ = parts[parts.length - 1];
    type = extension_[0] + extension_[1] + extension_[2];
  }

  Future pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      selectedImage = io.File(returnedImage!.path);
    });

    imageData = await readImageFile(selectedImage!.path);
    String selectedImg = selectedImage.toString();
    parts = selectedImg.split('.');
    String extension_ = parts[parts.length - 1];
    type = extension_[0] + extension_[1] + extension_[2];
  }

  Future<Uint8List> readImageFile(String filePath) async {
    io.File imageFile = io.File(filePath);
    return await imageFile.readAsBytes();
  }

  //gettingLocation

  Location location = Location();
  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  LocationData? currentLocation; //setting location state
  late double latitude;
  late double longitude;
  String address = 'Your address';
  bool isLoadingLocation = false;
  late String signedUrl;
  late String photoKey;

  Future<void> getLocation() async {
    setState(() {
      isLoadingLocation = true;
    });

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() {
          isLoadingLocation = false;
        });
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          isLoadingLocation = false;
        });
        return;
      }
    }

    currentLocation = await location.getLocation();

    setState(() {
      latitude = currentLocation!.latitude!;
      longitude = currentLocation!.longitude!;
      isLoadingLocation = false;
    });

    getLocationDetails(latitude, longitude);
  }

  String accessToken = "pk.6ad0615ce37a554ee116ff99d77a2b36";

  Future<void> getLocationDetails(double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://us1.locationiq.com/v1/reverse?key=$accessToken&lat=$latitude&lon=$longitude&format=json'),
      );

      if (response.statusCode == 200) {
        // Successful response
        final data = json.decode(response.body);
        setState(() {
          address = data['display_name'];
        });
      } else {
        print("Error is 1 - location: ${response.statusCode}");
      }
    } catch (e) {
      print("Error is 2 - location : $e");
    }
  }

  //Choice Chip
  Map<String, bool> ProblemFilter = {
    'Pothole': false,
    'Cracks': false,
    'Water logging': false,
  };

  List<String> selectedChips = [];
  bool isSelectedChip = false;

  //YOLO_model_run

  late FlutterVision vision;
  int imageHeight = 1;
  int imageWidth = 1;

  late List<Map<String, dynamic>> yoloResults;

  late String email;
  late String Uid;

  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
    loadModel();

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    Uid = jwtDecodedToken['_id'];
  }

  Future loadModel() async {
    await vision.loadYoloModel(
        labels: 'assets/multi_detection/labels.txt',
        modelPath: 'assets/multi_detection/best_float32.tflite',
        modelVersion: "yolov8",
        quantization: false,
        numThreads: 1,
        useGpu: false);
    print('model loaded');
  }

//  Uint8List byte = selectedImage.readAsBytes();
  late final result;

  Future yolov8(io.File imageFile) async {
    Uint8List byte = await imageFile.readAsBytes();

    final image = await decodeImageFromList(byte);
    imageHeight = image.height;
    imageWidth = image.width;

    result = await vision.yoloOnImage(
        bytesList: byte,
        imageHeight: imageHeight,
        imageWidth: imageWidth,
        iouThreshold: 0.8,
        confThreshold: 0.4,
        classThreshold: 0.5);

    if (result.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => complaint_status()),
      );
      uploadPhoto_();
      // raiseComplaint_();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const retry()),
      );
    }
  }

  void uploadPhoto_() async {
    var reqBody = {"email": email, "type": type};

    var response = await http.post(Uri.parse(uploadPhoto),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    var jsonResponse = jsonDecode(response.body);

    signedUrl = jsonResponse["success"][0];
    photoKey = jsonResponse["success"][1];
    uploadS3_();
    raiseComplaint_();
  }

  void uploadS3_() async {
    var response = await http.put(Uri.parse(signedUrl),
        headers: {"Content-Type": "image/$type"}, body: imageData);
  }

  void raiseComplaint_() async {
    var reqBody = {
      "userID": Uid,
      "email": email,
      "image": photoKey,
      "location": address,
      "category": result[0]['tag'],
      "description": problemController.text
    };

    var response = await http.post(Uri.parse(complaintDetails),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //picking up image
              Row(
                children: [
                  MaterialButton(
                    color: Colors.amber,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.image_search_rounded),
                        SizedBox(width: 4),
                        Text('Choose from gallery'),
                      ],
                    ),
                    onPressed: () {
                      pickImageFromGallery();
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  MaterialButton(
                    color: Colors.amber,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt),
                        SizedBox(width: 4),
                        Text('Take a picture'),
                      ],
                    ),
                    onPressed: () {
                      pickImageFromCamera();
                    },
                  ),
                ],
              ),

              // displaying the selected image
              selectedImage != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.30,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                8.0), // Adjust the radius as needed
                            child: Image.file(selectedImage!, fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the radius as needed
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.3,
                            color: Colors.grey[400],
                            child: const Icon(
                              Icons.image_rounded,
                              size: 150,
                            ),
                          ),
                        ),
                      ),
                    ),

              //Adding Location
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: MaterialButton(
                        color: Colors.amber,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on),
                            SizedBox(width: 8),
                            Text('Location'),
                          ],
                        ),
                        onPressed: () {
                          getLocation();
                        }),
                  ),
                ],
              ),
              if (isLoadingLocation)
                Transform.translate(
                  offset: const Offset(4.0, 0.0), // Move 4 pixels to the right
                  child: const SizedBox(
                    width: 25,
                    height: 25,
                    child: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                        strokeWidth: 3.0, // Reduce the thickness
                      ),
                    ),
                  ),
                ),

              Wrap(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    address,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ]),

              const SizedBox(
                height: 5,
              ),

              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Text("Problem Description (if Any)",
                    style: TextStyle(
                      fontSize: 20,
                    )),
              ),

              const SizedBox(
                height: 8,
              ),

              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 5,
                children: [
                  for (var option in ProblemFilter.keys)
                    FilterChip(
                      label: Text(option),
                      selected: ProblemFilter[option]!,
                      selectedColor: Colors.amber,
                      onSelected: (selected) {
                        setState(() {
                          ProblemFilter[option] = selected;
                        });
                        selectedChips = ProblemFilter.entries
                            .where((entry) => entry.value)
                            .map((entry) => entry.key)
                            .toList();
                      },
                    )
                ],
              ),

              const SizedBox(height: 10),

              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: TextFormField(
                  controller: problemController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Problem description (if any)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: MaterialButton(
                  color: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    'Raise Complaint',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onPressed: () {
                    if (selectedImage != null && !isLoading) {
                      setState(() {
                        isLoading = true;
                      });
                      yolov8(selectedImage!).then((_) {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    }
                  },
                ),
              ),

              const SizedBox(height: 10),

              if (isLoading) // Show loading indicator if isLoading is true
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
            ],
          ),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
