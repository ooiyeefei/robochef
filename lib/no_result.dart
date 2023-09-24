import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'scanner_page.dart';

class NoResultScreen extends StatefulWidget {
  const NoResultScreen({
    super.key,
  });

  @override
  State<NoResultScreen> createState() => NoResultScreenState();
}

class NoResultScreenState extends State<NoResultScreen> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  Future<void> setupCameras() async {
    // Obtain a list of the available cameras on the device.
    // cameras = await availableCameras();

    try {
      // initialize cameras.
      cameras = await availableCameras();

      // initialize camera controllers.
      cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      await cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
    if (!mounted) return;
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Unfortunately we can't identify any ingredients :( \n \n Please try again! \n",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('Scan Again'),
            onPressed: () async {
              await availableCameras().then(
                (cameras) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScannerPage(cameras: cameras))),
              );
            },
          )
        ],
      ),
    );
  }
}
