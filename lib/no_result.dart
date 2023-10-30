import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'display_image_upload.dart';
import 'package:image_picker/image_picker.dart';

class NoResultScreen extends StatefulWidget {
  const NoResultScreen({
    super.key,
  });

  @override
  State<NoResultScreen> createState() => NoResultScreenState();
}

class NoResultScreenState extends State<NoResultScreen> {
  File? image;

  Future<bool> pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) {
        return false;
      } else {
        setState(() => this.image = File(image.path));
        debugPrint(image.path);
        return true;
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      rethrow;
    }
  }

  Future<bool> pickImageCamera() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) {
        return false;
      } else {
        setState(() => this.image = File(image.path));
        debugPrint(image.path);
        return true;
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/robochef_sad.png'),
          const Align(
            alignment: Alignment.center,
            child: Text(
              "\nUnfortunately we can't identify \n any ingredients :( \n \n Please try again! \n",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('Scan Again'),
            onPressed: () async {
              if (await pickImageCamera()) {
                debugPrint('goes to image pages');
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                      // Pass the automatically generated path to
                      // the DisplayPictureScreen widget.
                      imagePath: image!.path,
                    ),
                  ),
                );
              } else {
                const Text("No image selected");
              }

              // await availableCameras().then(
              //   (cameras) => Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => ScannerPage(cameras: cameras))),
              // );
            },
          ),
          ElevatedButton(
            child: const Text('Pick Another Image'),
            onPressed: () async {
              if (await pickImage()) {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                      // Pass the automatically generated path to
                      // the DisplayPictureScreen widget.
                      imagePath: image!.path,
                    ),
                  ),
                );
              } else {
                const Text("No image selected");
              }
            },
          ),
        ],
      ),
    );
  }
}
