import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class ImageRecognitionPage extends StatefulWidget {
  @override
  _ImageRecognitionPageState createState() => _ImageRecognitionPageState();
}

class _ImageRecognitionPageState extends State<ImageRecognitionPage> {
  Uint8List? _image;
  final picker = ImagePicker();
  String result = "";

  final String recognitionApiKey = 'Your-Baidu-Recognition-Api-Key';
  final String recognitionSecretKey = 'Your-Baidu-Recognition-Serect-Key';
  final String translationApiKey = 'Your-Baidu-Recognition-Serect-Key';
  final String translationSecretKey = 'Your-Baidu-Translation-Serect-Key';

  Future<String> getRecognitionAccessToken() async {
    final response = await http.post(
      Uri.parse(
          'https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=$recognitionApiKey&client_secret=$recognitionSecretKey'),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to get recognition access token');
    }
  }

  Future<String> getTranslationAccessToken() async {
    final response = await http.post(
      Uri.parse(
          'https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=$translationApiKey&client_secret=$translationSecretKey'),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to get translation access token');
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image != null) {
        final compressedImage = img.encodeJpg(image, quality: 50);
        setState(() {
          _image = Uint8List.fromList(compressedImage);
        });
      }
    }
  }

  Future<void> recognizeImage() async {
    if (_image == null) {
      setState(() {
        result = "Please select an image first";
      });
      return;
    }

    final base64Image = base64Encode(_image!);
    final accessToken = await getRecognitionAccessToken();

    try {
      final response = await http.post(
        Uri.parse(
            'https://aip.baidubce.com/rest/2.0/image-classify/v1/animal?access_token=$accessToken'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'image': base64Image},
      );

      if (response.statusCode == 200) {
        final utf8DecodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(utf8DecodedBody);

        if (data['result'] != null && data['result'].isNotEmpty) {
          final topResult = data['result'][0];
          final String name = topResult['name'];
          final String score =
          (double.parse(topResult['score']) * 100).toStringAsFixed(2);
          final translatedName = await translateResult(name);
          setState(() {
            result = 'Name: $translatedName\nScore: $score%';
          });
        } else {
          setState(() {
            result = "Recognition result is empty";
          });
        }
      } else {
        setState(() {
          result = "Recognition failed, please try again";
        });
      }
    } catch (e) {
      setState(() {
        result = "An error occurred, please check your network connection";
      });
    }
  }

  Future<String> translateResult(String name) async {
    final accessToken = await getTranslationAccessToken();

    try {
      final response = await http.post(
        Uri.parse(
            'https://aip.baidubce.com/rpc/2.0/mt/texttrans/v1?access_token=$accessToken'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'q': name,
          'from': 'zh',
          'to': 'en',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['result']['trans_result'][0]['dst'];
      } else {
        return 'Translation failed';
      }
    } catch (e) {
      return 'An error occurred during translation';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDEFF9), Color(0xFFD1EAF5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Image Recognition',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _image == null
                        ? Center(
                      child: Text(
                        'Please select an image',
                        style: TextStyle(
                            color: Colors.grey, fontSize: 16),
                      ),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8EACE3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 12, horizontal: 40),
                    ),
                    child: Text(
                      'Select Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: recognizeImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8EACE3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 12, horizontal: 40),
                    ),
                    child: Text(
                      'Recognize Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    result,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/search');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8EACE3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Switch to Search Page'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8EACE3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Switch to Login Page'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
