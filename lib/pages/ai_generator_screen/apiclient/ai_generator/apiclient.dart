import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:picstar/pages/ai_generator_screen/apiclient/ai_generator/api_client.dart';

import 'package:picstar/pages/ai_generator_screen/text_to_image2.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../global/exceptions/api_exceptions.dart';

class ApiRequests {
  Future<void> sendRequest(
    BuildContext context,
    TextEditingController textController,
    String? samplingMethod,
    String? negativePrompt,
    String? seed,
    double? slidervalue,
    int? selectedStylesid,
    String? selectedSize,
    Function(String) updateStatusCallback,
  ) async {
    updateStatusCallback("Warming up the AI engines...");
    await Future.delayed(const Duration(milliseconds: 1000));
    // Print statements for debugging
    print('data before sending to api------->');
    print('sampling method: $samplingMethod');
    print('negative prompt: $negativePrompt');
    print('seed: $seed');
    print('sampling steps: $slidervalue');
    print('size: $selectedSize');
    print('stylesid: $selectedStylesid');

    // Initialize Dio and ApiService
    final dio = Dio(); // Provide a Dio instance to handle HTTP requests
    final apiService = ApiService(dio);
    updateStatusCallback("Analyzing your prompts...");
    await Future.delayed(const Duration(milliseconds: 1000));
    // Prepare the request body
    Map<String, dynamic> requestBody = {
      "generation_steps": slidervalue ?? 20,
      "guidance_scale": 7,
      "sampler_name": samplingMethod ?? "Euler a",
      "sampler_index": "Euler a",
      "generation_prompt": textController.text,
      "negative_prompt": negativePrompt ??
          "ugly, deformed, noisy, blurry, distorted, out of focus, bad anatomy, extra limbs, poorly drawn face, poorly drawn hands, missing fingers",
      "generation_seed": seed ?? -1,
      "width": 512,
      "height": 512,
      "batch_size": 5,
      "sid": selectedStylesid,
      "cat": 2,
      "img_ratio": selectedSize ?? "square",
      "hit_point": "mobile"
    };

    // Print the request body for debugging
    print('Request Body: $requestBody');

    try {
      // Make the POST request using Retrofit
      String mobileToken = "token f0fbd09d9ee66a95ecfce28301132c7b56fa32a4";
      updateStatusCallback("The AI is painting your vision...");
      HttpResponse<dynamic> response =
          await apiService.sendRequest(requestBody, mobileToken);

      // Print the response body for debugging
      print("Response Body: ${response.response.data}");

      // Process the response

      if (response.response.statusCode == 200) {
        updateStatusCallback("Wrapping up the masterpiece...");
        await Future.delayed(const Duration(milliseconds: 1000));
        // Parse and handle the response
        Map<String, dynamic> jsonResponse = response.data;

        // Handle the parsed response
        if (jsonResponse.containsKey('data') &&
            jsonResponse['data'].containsKey('images')) {
          List<dynamic> images = jsonResponse['data']['images'];
          if (images.isNotEmpty) {
            // Assuming you want to navigate to a new screen with the image URLs
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Text2ImageScreen2(
                    imageUrl1: "https://cognise.art" + images[0]['image'],
                    imageUrl2: "https://cognise.art" + images[1]['image'],
                    imageUrl3: "https://cognise.art" + images[2]['image'],
                    imageUrl4: "https://cognise.art" + images[3]['image'],
                    enteredText: textController.text,
                    samplingMethod: samplingMethod,
                    negativePrompt: negativePrompt,
                    seed: seed,
                    slidervalue: slidervalue,
                    selectedStylesid: selectedStylesid,
                    selectedSize: selectedSize),
              ),
            );
          } else {
            print("No images found in response.");
          }
        } else {
          print("Invalid response format");
        }
      } else {
        // Handle HTTP errors
        print("Request failed with status: ${response.response.statusCode}");
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
