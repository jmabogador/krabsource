import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'dashboard_page.dart';
import 'display_page.dart';
import 'about_page.dart'; // Import the about page

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Static variable to hold the selected image
  static File? selectedImage;

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  File? imageFile;
  final ImagePicker imagePicker = ImagePicker();
  Map<String, dynamic>? _output;
  bool _isClassifying = false;
  bool _isNavigating = false;
  String? _mappingsHtml;

  Future<void> getFromGallery() async {
    if (_isClassifying || _isNavigating) return;

    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 90,
    );

    if (pickedFile != null) {
      final image = File(pickedFile.path);
      if (await image.exists()) {
        setState(() {
          imageFile = image;
          MyPage.selectedImage = image;
        });
      }
    }
  }

  void _showLoadingScreen(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.orange[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Classifying Image',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> classifyImage(BuildContext context) async {
    if (imageFile == null) {
      if (kDebugMode) print('Image file is null');
      return;
    }

    _showLoadingScreen(context);

    Position? currentPosition = await _getCurrentLocation();
    if (currentPosition == null) {
      if (kDebugMode) print('Could not get current location');
      Navigator.of(context).pop();
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.236.238:5000/classify'),
    );

    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile!.path));
    request.fields['latitude'] = currentPosition.latitude.toString();
    request.fields['longitude'] = currentPosition.longitude.toString();

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var data = jsonDecode(responseString);

    Navigator.of(context).pop();

    setState(() {
      _output = data;
    });

    await _displayMappings();

    if (_output != null && !_isNavigating && _mappingsHtml != null) {
      _isNavigating = true;

      MyPage.navigatorKey.currentState!
          .push(
        MaterialPageRoute(
          builder: (context) => DisplayPage(
            imageFile: imageFile!,
            output: _output!,
            mappingsHtml: _mappingsHtml!,
            crabData: [_output!],
          ),
        ),
      )
          .then((_) {
        _isNavigating = false;
        _isClassifying = false;
      });
    }
  }

  Future<void> _displayMappings() async {
    var response =
        await http.get(Uri.parse('http://192.168.236.238:5000/get_excel'));
    setState(() {
      _mappingsHtml = response.body;
    });
  }

  Future<Position?> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void initState() {
    super.initState();
    if (MyPage.selectedImage != null) {
      imageFile = MyPage.selectedImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/krab_logo2.png'),
        ),
        title: const Text("Camera",
            style: TextStyle(color: Colors.white, fontSize: 28)),
        backgroundColor: Colors.orange[900],
      ),
      body: SingleChildScrollView(
        // Makes the content scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(40),
              width: size.width,
              height: 400,
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                color: Colors.orange,
                strokeWidth: 3,
                dashPattern: const [15, 15],
                child: SizedBox.expand(
                  child: FittedBox(
                    child: imageFile != null
                        ? Image.file(File(imageFile!.path), fit: BoxFit.cover)
                        : const Icon(
                            Icons.image_outlined,
                            color: Colors.orange,
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.orange[900],
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: showPictureDialog,
                      child: const Center(
                        child: Text(
                          'Pick Image',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.orange[900],
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        classifyImage(context);
                      },
                      child: const Center(
                        child: Text(
                          'Classify Image',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.orange[900],
        unselectedItemColor: Colors.orange,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AboutPage()),
            );
          }
        },
      ),
    );
  }

  Future<void> showPictureDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Image'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                getFromGallery();
              },
              child: const Text('Choose from Gallery'),
            ),
          ],
        );
      },
    );
  }
}
