import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'scanner_page.dart';

// Future<HomeScreen> home() async {
//   // Ensure that plugin services are initialized so that `availableCameras()`
//   // can be called before `runApp()`
//   WidgetsFlutterBinding.ensureInitialized();

//   // initialize Firebase using the DefaultFirebaseOptions object exported by the configuration file:
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

// // Obtain a list of the available cameras on the device.
// final cameras = await availableCameras();

// // Get a specific camera from the list of available cameras.
// final firstCamera = cameras.first;

// return const HomeScreen(
//   title: 'Robochef Demo Home Page',
// );

// runApp(
//   MaterialApp(
//     theme: ThemeData.dark(),
//     home: const HomePage(
//       title: 'Robochef Demo Home Page',
//       camera: firstCamera,
//     ),
//   ),
// );
// }

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({
    super.key,
    required this.title,
  });

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // late List<CameraDescription> cameras = <CameraDescription>[];
  // late CameraController cameraController;
  // bool _isReady = false;

  // @override
  // void initState() {
  //   super.initState();
  //   setupCameras();
  // }

  // Future<void> setupCameras() async {
  //   try {
  //     // initialize cameras.
  //     cameras = await availableCameras();
  //     // initialize camera controllers.
  //     cameraController = CameraController(cameras[0], ResolutionPreset.medium);
  //     await cameraController.initialize();
  //   } on CameraException catch (e) {
  //     debugPrint("camera error $e");
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _isReady = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // if (!cameraController.value.isInitialized) {
    //   return const Center(
    //     child: CircularProgressIndicator(), // Or show a loading indicator
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Open camera'),
              onPressed: () async {
                await availableCameras().then(
                  (cameras) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScannerPage(cameras: cameras))),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
