import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

import 'list_ingredient_page.dart';

class ScannerNavBarPage extends StatefulWidget {
  final CameraController cameraController;

  const ScannerNavBarPage({
    super.key,
    required this.cameraController,
  });

  @override
  ScannerNavBarPageState createState() => ScannerNavBarPageState();
}

class ScannerNavBarPageState extends State<ScannerNavBarPage> {
  // Add code to initialize camera and capture images
  late CameraController cameraController;

  Future<void> setupCameras() async {
    // Initialize the controller, this returns a Future.
    try {
      await cameraController.initialize();
      if (!mounted) return;
      setState(() {});
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // call the function above to initialize the camera
    setupCameras();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    cameraController.dispose();
    super.dispose();
  }

  // Add code to receive and display inferenced results

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: AspectRatio(
        aspectRatio: cameraController.value.aspectRatio,
        child: CameraPreview(cameraController),
      ),
      // FutureBuilder<void>(
      //   future: _initializeControllerFuture,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       // If the Future is complete, display the preview.
      //       return CameraPreview(cameraController);
      //     } else {
      //       // Otherwise, display a loading indicator.
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            // await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await cameraController.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            debugPrint(e.toString());
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(imagePath)),
            ElevatedButton(
                child: const Text('Upload'),
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  final idToken = await user?.getIdTokenResult();

                  // HTTP POST request to perform file upload
                  File imageFile = File(imagePath);

                  //// Read bytes from the file object
                  // Uint8List bytes = await imageFile.readAsBytes();
                  //// base64 encode the bytes
                  // String base64String = base64.encode(bytes);

                  // html.Blob blob = html.Blob(await imageFile.readAsBytes());
                  final http.Response response;
                  try {
                    response = await http.post(
                        Uri.parse(
                            "https://6gl6qn0zu5.execute-api.us-west-2.amazonaws.com/Prod/"),
                        // Send authorization headers to the backend.
                        headers: {
                          HttpHeaders.authorizationHeader:
                              idToken!.token.toString(),
                          HttpHeaders.contentTypeHeader: 'image/jpeg',
                        },
                        // body: blob);
                        body: imageFile.readAsBytesSync());

                    final List result = json.decode(response.body);
                    final int length = result.length;
                    debugPrint(result.toString());

                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ListIngredientPage(
                          resultData: result,
                          resultLength: length,
                        ),
                      ),
                    );
                  } on Exception catch (_) {
                    rethrow;
                  }

                  //// GET request to retrieve S3 presigned URL
                  // final response = await http.get(
                  //   Uri.parse(
                  //       "https://6gl6qn0zu5.execute-api.us-west-2.amazonaws.com/Prod/"),
                  //   // Send authorization headers to the backend.
                  //   headers: {
                  //     HttpHeaders.authorizationHeader:
                  //         idToken!.token.toString(),
                  //   },
                  // );
                  // final lambdaResponse = jsonDecode(response.body);
                  // debugPrint(lambdaResponse.toString());

                  //// HTTP Multipart request to perform file multipart upload
                  // try {
                  //   final request = http.MultipartRequest(
                  //       "POST",
                  //       Uri.parse(
                  //           "https://6gl6qn0zu5.execute-api.us-west-2.amazonaws.com/Prod/"));
                  //   // Send authorization headers to the backend.
                  //   Map<String, String> headers = {
                  //     HttpHeaders.authorizationHeader:
                  //         idToken!.token.toString(),
                  //   };
                  //   request.headers.addAll(headers);
                  //   request.files.add(await http.MultipartFile.fromPath(
                  //       'file', imagePath)); //fromPath('file', image));
                  // } on Exception catch (_) {
                  //   rethrow;
                  // }

                  // var response = await request.send();

                  // var responsed = await http.Response.fromStream(response);

                  // final responseData = json.decode(responsed.body);
                }

                // await availableCameras().then(
                //   (cameras) => Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => ScannerNavBarPage(cameras: cameras))),
                // );

                ),
          ],
        ),
      ),
    );
  }
}
