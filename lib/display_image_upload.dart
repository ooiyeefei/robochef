import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'list_ingredients_page.dart';
import 'no_result.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload and get ingredients')),
      // resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
            ClipRRect(
              // Clip it cleanly.
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  color: Colors.grey.withOpacity(0.3),
                  alignment: Alignment.center,
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          final user = FirebaseAuth.instance.currentUser;
          final idToken = await user?.getIdTokenResult();

          // HTTP POST request to perform file upload
          File imageFile = File(imagePath);

          // Create a file and write some contents to it. Then, open it
          // for reading.
          final Directory directory = await getApplicationDocumentsDirectory();
          final targetPath = '${directory.path}/cleanImage.jpg';
          await FlutterImageCompress.compressAndGetFile(
              imageFile.path, targetPath);

          debugPrint('original file: ${imageFile.path}');
          debugPrint('clean file: $targetPath');
          final cleanFilename = File(targetPath);

          // final uint8List = cleanFilename.readAsBytesSync();
          // final file = File(targetPath)..writeAsBytesSync(uint8List);
          // final contents = file.openRead();
          // const key = '/O53M1yAqQGMZj7FsKRkPcVSQHUZ2/cleanImage.jpg';

          // http upload - agw
          final http.Response response;
          try {
            response = await http.post(
                Uri.parse(
                    "https://x0codvlexc.execute-api.us-west-2.amazonaws.com/Prod/"),
                // Send authorization headers to the backend.
                headers: {
                  HttpHeaders.authorizationHeader: idToken!.token.toString(),
                  HttpHeaders.contentTypeHeader: 'image/jpeg',
                },
                body: cleanFilename.readAsBytesSync());

            // final int statusCode =
            //     json.decode(response.statusCode.toString());
            // print(statusCode);

            final List result = json.decode(response.body);
            final Map body = result.length != 2 ? {} : result[1];
            final int length = body.containsKey("ingredient_response") ? body["ingredient_response"].length : 0;

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
        },
      ),
    );
  }
}
