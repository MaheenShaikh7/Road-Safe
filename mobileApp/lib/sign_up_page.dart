import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:road_safe_app/sign_in_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:io' as io;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isNotValidate = false;
  bool isLoading = false;

  io.File? selectedImage;

  late String img64;
  String? base64String;
  late List<String> parts;
  late String type = "";
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

  late String signedUrl;
  late String photoKey = "";

  void uploadUserPhoto_() async {
    var reqBody = {"email": emailController.text, "type": type};

    var response = await http.post(Uri.parse(uploadUserPhoto),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    var jsonResponse = jsonDecode(response.body);

    signedUrl = jsonResponse["success"][0];
    photoKey = jsonResponse["success"][1];

    uploadS3_();
    registerUser();
  }

  void uploadS3_() async {
    var response = await http.put(Uri.parse(signedUrl),
        headers: {"Content-Type": "image/$type"}, body: imageData);
  }

  void endPoint() {
    if (type.isNotEmpty) {
      uploadUserPhoto_();
    } else {
      registerUser();
    }
  }

  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      var regBody = {
        "userImage": photoKey,
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInPage()));
      } else {
        isLoading = false;
      }
    } else {
      setState(() {
        _isNotValidate = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.clamp,
                  colors: [Colors.blue, Colors.white])),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign Up",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // displaying the selected image
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.amber,
                            width: 4,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 60,
                          child: selectedImage != null
                              ? ClipOval(
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                    width: 200,
                                    height: 200,
                                  ),
                                )
                              : const Icon(
                                  Icons.image,
                                  size: 100,
                                  color: Color.fromARGB(255, 73, 72, 72),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            color: Colors.amber,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.image_search_rounded,
                                  size: 30,
                                ),
                              ],
                            ),
                            onPressed: () {
                              pickImageFromGallery();
                            },
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          MaterialButton(
                            color: Colors.amber,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                // SizedBox(width: 4),
                              ],
                            ),
                            onPressed: () {
                              pickImageFromCamera();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: firstNameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'First Name',
                            isCollapsed:
                                true, // Reduces the height of the input field
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 15.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: lastNameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Last Name',
                            isCollapsed:
                                true, // Reduces the height of the input field
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 15.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(
                                color: const Color.fromARGB(255, 19, 18, 18)),
                            errorText: _isNotValidate
                                ? "Enter a valid Email address"
                                : null,
                            hintText: 'Email',
                            isCollapsed:
                                true, // Reduces the height of the input field
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 15.0),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(
                                color: const Color.fromARGB(255, 19, 18, 18)),
                            errorText: _isNotValidate
                                ? "Enter a valid Password"
                                : null,
                            hintText: 'Password',
                            isCollapsed:
                                true, // Reduces the height of the input field
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 15.0),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : endPoint,
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                )
                              : const Text('Sign Up'),
                        )),
                    const SizedBox(
                      height: 7,
                    ),
                    Text("Already have an account?"),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()));
                        },
                        child: Text('Sign In'),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
