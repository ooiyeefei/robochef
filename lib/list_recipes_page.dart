import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'http_with_loader.dart';

import 'recipes_card.dart';
import 'no_result.dart';

class ListRecipesPage extends StatefulWidget {
  final List resultData;
  final int resultLength;
  final String uniqueId;

  const ListRecipesPage({
    super.key,
    required this.resultData,
    required this.resultLength,
    required this.uniqueId,
  });

  @override
  ListRecipesPageState createState() => ListRecipesPageState();
}

class ListRecipesPageState extends State<ListRecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Let's Get Cookin' 🍳")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.resultLength,
              itemBuilder: (context, index) {
                return RecipeCard(
                  recipeName: widget.resultData[index]['recipe_name'],
                  estTimeMin: widget.resultData[index]['est_time_min'],
                  availableIngredients: widget.resultData[index]
                      ['available_ingredients'],
                  missingIngredients: widget.resultData[index]
                      ['missing_ingredients'],
                  instructions: widget.resultData[index]['instructions'],
                  thumbnailUrl: widget.resultData[index]['imgUrl'],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        fit: StackFit.expand,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                child: SizedBox(
                  height: (MediaQuery.sizeOf(context).height) * 0.06,
                  child: FittedBox(
                    child: FloatingActionButton(
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        final idToken = await user?.getIdTokenResult();
                        // http get to refresh ingredient lists

                        final http.Response response;

                        try {
                          HTTP http_with_loader = HTTP(context);
                          response = await http_with_loader.getWithRetries(
                              "https://veo3slmw0g.execute-api.us-west-2.amazonaws.com/Prod/",
                              // Send authorization headers to the backend.
                              {
                                HttpHeaders.authorizationHeader:
                                    idToken!.token.toString(),
                                "unique_id": widget.uniqueId,
                              }, isEmpty: (http.Response result) {
                            final lambdaResponse = jsonDecode(result.body);
                            debugPrint(lambdaResponse.toString());
                            final int length = lambdaResponse.length;
                            return length == 0;
                          });

                          final lambdaResponse = jsonDecode(response.body);
                          debugPrint(lambdaResponse.toString());
                          final int length = lambdaResponse.length;

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
                                builder: (context) => ListRecipesPage(
                                  resultData: lambdaResponse,
                                  resultLength: length,
                                  uniqueId: widget.uniqueId,
                                ),
                              ),
                            );
                          }
                        } on Exception catch (_) {
                          rethrow;
                        }
                      },
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.refresh),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
