import 'dart:async';
import 'dart:convert';
// import 'package:universal_html/html.dart' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:exif/exif.dart';

import 'package:aws_common/aws_common.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'list_ingredients_page.dart';
import 'no_result.dart';

class ScannerPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const ScannerPage({
    super.key,
    required this.cameras,
  });

  @override
  ScannerPageState createState() => ScannerPageState();
}

class ScannerPageState extends State<ScannerPage> {
  // Add code to initialize camera and capture images
  late CameraController cameraController;
  late Future<void> _initializeControllerFuture;
  bool floatExtended = false;

  // late File image;

  // Future pickImage() async {
  //   try {
  //     XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

  //     if (image == null) return;

  //     setState(() => this.image = File(image.path));
  //     debugPrint(image.path);
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }

  // Future pickImageCamera() async {
  //   try {
  //     XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

  //     if (image == null) return;

  //     setState(() => this.image = File(image.path));
  //     debugPrint(image.path);
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }

  Future<void> setupCameras(CameraDescription cameras) async {
    // Create a camera controller
    cameraController = CameraController(cameras, ResolutionPreset.high);

    // Initialize the controller, this returns a Future.
    try {
      _initializeControllerFuture = cameraController.initialize();
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
    setupCameras(widget.cameras[0]);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    cameraController.dispose();
    super.dispose();
  }

  // Add code to send captured image to the backend
  // Add code to receive and display inferenced results

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(cameraController);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton:
          // SpeedDial(
          //   icon: Icons.keyboard_arrow_up,
          //   activeIcon: Icons.close,
          //   label: floatExtended
          //       ? const Text("Open")
          //       : null, // The label of the main button.
          //   /// The active label of the main button, Defaults to label if not specified.
          //   activeLabel: floatExtended ? const Text("Close") : null,
          //   spaceBetweenChildren: 15,
          //   children: [
          //     SpeedDialChild(
          //         child: const Icon(Icons.image),
          //         label: 'Select from gallery',
          //         labelStyle: const TextStyle(
          //           fontSize: 18,
          //         ),
          //         onTap: () async {
          //           pickImage();
          //           image != null
          //               ? Image.file(image)
          //               : const Text("No image selected");
          //           await Navigator.of(context).push(
          //             MaterialPageRoute(
          //               builder: (context) => DisplayPictureScreen(
          //                 // Pass the automatically generated path to
          //                 // the DisplayPictureScreen widget.
          //                 imagePath: image!.path,
          //               ),
          //             ),
          //           );
          //         }
          //         ),
          //     SpeedDialChild(
          //       child: const Icon(Icons.camera_alt),
          //       label: 'Capture a new image',
          //       labelStyle: const TextStyle(
          //         fontSize: 18,
          //       ),
          //       onTap: () async {
          //         pickImageCamera();
          //         image != null
          //             ? Image.file(image)
          //             : const Text("No image selected");
          //         await Navigator.of(context).push(
          //           MaterialPageRoute(
          //             builder: (context) => DisplayPictureScreen(
          //               // Pass the automatically generated path to
          //               // the DisplayPictureScreen widget.
          //               imagePath: image!.path,
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ],
          //   isOpenOnStart: false,
          // ),
          FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

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
      appBar: AppBar(title: const Text('Upload and detect for ingredients')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
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

                  // upload with access key using aws sig4 library https://aws.amazon.com/blogs/opensource/introducing-the-aws-sigv4-signer-for-dart/
                  // const region = 'us-west-2';
                  // const signer = AWSSigV4Signer();
                  // final scope = AWSCredentialScope(
                  //     region: region, service: AWSService.s3);
                  // const bucketName = 'camera-photos-upload';
                  // const host = '$bucketName.s3.$region.amazonaws.com';
                  // final serviceConfiguration = S3ServiceConfiguration();

// Create a file and write some contents to it. Then, open it
// for reading.
                  final Directory directory =
                      await getApplicationDocumentsDirectory();
                  final filename = File('${directory.path}/testImage.jpg');
                  final targetPath = '${directory.path}/cleanImage.jpg';
                  await FlutterImageCompress.compressAndGetFile(
                      imageFile.path, targetPath);

                  debugPrint('original file: ${imageFile.path}');
                  debugPrint('clean file: $targetPath');
                  final cleanFilename = File(targetPath);

                  // // get image EXIF metadata
                  // final fileBytes = cleanFilename.readAsBytesSync();
                  // final data = await readExifFromBytes(fileBytes);
                  // debugPrint('image metadata: ');
                  // for (final e in data.entries) {
                  //   debugPrint('${e.key} = ${e.value}');
                  // }

                  final uint8List = cleanFilename.readAsBytesSync();
                  final file = File(targetPath)..writeAsBytesSync(uint8List);
                  final contents = file.openRead();
                  const key = '/O53M1yAqQGMZj7FsKRkPcVSQHUZ2/cleanImage.jpg';

// Create a PUT request to the path of the file.
                  // print('creating upload requests...');
                  // final uploadRequest = AWSStreamedHttpRequest.raw(
                  //   method: AWSHttpMethod.put,
                  //   host: host,
                  //   // uri: Uri.parse('http://$host'),
                  //   path: key,
                  //   body: contents,
                  //   headers: {
                  //     AWSHeaders.host: host,
                  //     AWSHeaders.contentType: 'image/jpeg',
                  //   },
                  // );

// Sign and send the upload request
                  // print('signing and sending upload requests...');
                  // final signedUploadRequest = await signer.sign(
                  //   uploadRequest,
                  //   credentialScope: scope,
                  //   serviceConfiguration: serviceConfiguration,
                  // );
                  // final uploadResponse = await signedUploadRequest.send();

                  // http upload - agw
                  final http.Response response;
                  try {
                    response = await http.post(
                        Uri.parse(
                            "https://x0codvlexc.execute-api.us-west-2.amazonaws.com/Prod/"),
                        // Send authorization headers to the backend.
                        headers: {
                          HttpHeaders.authorizationHeader:
                              idToken!.token.toString(),
                          HttpHeaders.contentTypeHeader: 'image/jpeg',
                        },
                        // body: blob);
                        body: cleanFilename.readAsBytesSync());
                    // body: imageFile.readAsBytesSync());

                    // final int statusCode =
                    //     json.decode(response.statusCode.toString());
                    // print(statusCode);

                    final List result = json.decode(response.body);
                    final int length = result[1]['ingredient_response'].length;
                    print(result);
                    print(length);

                    if (length == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NoResultScreen(),
                        ),
                      );
                    } else {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ListIngredientsPage(
                            resultData: result,
                            resultLength: length,
                          ),
                        ),
                      );
                    }
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
                //           builder: (context) => ScannerPage(cameras: cameras))),
                // );

                ),
          ],
        ),
      ),
    );
  }
}
