// api_service.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:picstar/pages/ai_generator_screen/apiclient/img2prompt/api_client.dart';
import 'package:retrofit/dio.dart';

import '../../../../global/exceptions/api_exceptions.dart';

class Img2Prompt {
  Future<String> sendImage(XFile? imageFile, BuildContext context) async {
    if (imageFile == null) {
      throw Exception("No image file provided");
    }

    // Initialize Dio and ApiService
    final dio = Dio(); // Provide a Dio instance to handle HTTP requests
    final apiService = ApiService(dio);

    const String token = "token f0fbd09d9ee66a95ecfce28301132c7b56fa32a4";

    try {
      // Convert XFile to File
      File file = File(imageFile.path);

      // Make the POST request using Retrofit
      HttpResponse response = await apiService.sendImage(file, token);

      // Print response details for debugging
      print("Response Status Code: ${response.response.statusCode}");
      print("Response Body: ${response.response.data}");

      // Process the response
      if (response.response.statusCode == 200) {
        // Parse the response and extract the caption
        Map<String, dynamic> jsonResponse = response.response.data;
        if (jsonResponse['status'] == 'Success') {
          return jsonResponse['data']['caption'];
        } else {
          // Handle the case where the response indicates an error
          throw Exception("Error: ${jsonResponse['message']}");
        }
      } else {
        // If the status code is not 200, throw an error
        throw Exception(
            "Error: Unexpected status code ${response.response.statusCode}");
      }
    } on NetworkUnavailableException catch (e) {
      // Handle specific network unavailable exceptions
      print('$e');
      _showErrorPopup(context, 'Error',
          'Network is unreachable. Please check your internet connection.');
    } on HttpClientException catch (e) {
      // Handle specific HTTP client exceptions
      print('$e');
      _showErrorPopup(
          context, 'Error', 'An error occurred in the HTTP client.');
    } on SocketExceptionWrapper catch (e) {
      // Handle specific socket exceptions
      print('$e');
      if (e.isNetworkUnreachable) {
        _showErrorPopup(context, 'Error',
            'Network is unreachable. Please check your internet connection.');
      } else {
        _showErrorPopup(context, 'Error', 'A network error occurred.');
      }
    } on BadRequestException catch (e) {
      // Handle specific bad request exceptions
      print('$e');

      _showErrorPopup(
          context, 'Error', 'Bad request. Please check your input.');
    } on UnauthorizedException catch (e) {
      // Handle specific unauthorized exceptions
      print('$e');

      _showErrorPopup(
          context, 'Error', 'Unauthorized. Please check your credentials.');
    } on NotFoundException catch (e) {
      // Handle specific not found exceptions
      print('$e');

      _showErrorPopup(context, 'Error', 'Resource not found.');
    } on ApiException catch (e) {
      // Handle other generic API exceptions
      print('$e');

      _showErrorPopup(context, 'Error', 'An API error occurred: ${e.message}');
    } catch (e) {
      // Handle unexpected errors
      print('Unexpected error: $e');

      _showErrorPopup(context, 'Error', 'An unexpected error occurred.+$e');
    }
    return 'Default return value or error message';
  }

  void _showErrorPopup(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                // );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showErrorPopup(
      BuildContext context, String title, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
