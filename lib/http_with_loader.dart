import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'dart:convert';

class HTTP {

  BuildContext? context;

  HTTP(BuildContext this.context);
  
  Future<http.Response> get (uri, headers) async {

    final http.Response response;
    
    try {
      context?.loaderOverlay.show();
      response = await http.get(
          Uri.parse(uri),
          headers: headers
      );
    } on Exception catch(e) {
      context?.loaderOverlay.hide();
      print(e);
      rethrow;
    }

    context?.loaderOverlay.hide();
    
    return response;
  }

  Future<http.Response> getWithRetries (
      uri, 
      headers, 
      {required bool Function(http.Response result) isEmpty}
    ) async {

    final http.Response response;
    http.Response result;

    try {
      context?.loaderOverlay.show();

      result = await http.get(
          Uri.parse(uri),
          headers: headers
      );

      for (var i = 0; i< 8; i++) {

        result = await http.get(
            Uri.parse(uri),
            headers: headers
        );  
        if (!isEmpty(result)) {
          print("result is not empty, break: $i" );
          break;
        }
        
        print("result is empty, sleep for 5 seconds, running loop once more: $i" );
        await Future.delayed(const Duration(seconds: 5));
      }
      
      response = result;
      
    } on Exception catch(e) {
      context?.loaderOverlay.hide();
      print(e);
      rethrow;
    }

    context?.loaderOverlay.hide();
    
    return response;
  }

  Future<http.Response> post (uri, headers, body) async {

    
    final http.Response response;
    
    try {
      context?.loaderOverlay.show();
      response = await http.post(
          Uri.parse(uri),
          headers: headers,
          body: body
      );
      context?.loaderOverlay.hide();
    }
    on Exception catch(e) {
      context?.loaderOverlay.hide();
      print(e);
      rethrow;
    }
    
    return response;
  }
}