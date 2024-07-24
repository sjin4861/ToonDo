import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/gpt_service.dart';
import 'dart:convert';

class ActivityInputScreen extends StatefulWidget {
  @override
  _ActivityInputScreenState createState() => _ActivityInputScreenState();
}

class _ActivityInputScreenState extends State<ActivityInputScreen> {
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false;
  String? _result;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) {
      print('No image selected.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final base64Image = base64Encode(_image!.readAsBytesSync());
      final result = await GptService().analyzePlannerImage(base64Image);
      setState(() {
        _result = result['choices'][0]['message']['content'];
      });
      print('Result: $_result');
    } catch (e) {
      print('Error analyzing image: $e');
      setState(() {
        _result = 'Error analyzing image.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Input'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _analyzeImage,
              child: Text('Analyze Image'),
            ),
            SizedBox(height: 20),
            _result == null
                ? Container()
                : Text(
              _result!,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}