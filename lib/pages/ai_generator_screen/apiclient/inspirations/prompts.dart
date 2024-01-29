import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:picstar/pages/ai_generator_screen/apiclient/inspirations/api_client.dart';

import 'package:retrofit/dio.dart';

import '../../../../global/exceptions/api_exceptions.dart';
import '../../model/promptsModel.dart';

class InspirationsPrompt {
  Future<List<InspirationInfo>> fetchItems(BuildContext context) async {
    List<InspirationInfo> items = [];
    const String token = "token 7bb91a6699cc3794750101ce0354d80195f07c04";

    // Initialize Dio and ApiService
    final dio = Dio(); // Provide a Dio instance to handle HTTP requests
    final apiService = ApiService(dio);

    try {
      // Make the GET request using Retrofit
      HttpResponse<dynamic> response =
          await apiService.fetchItems(50, "mobile", token);

      if (response.response.statusCode == 200) {
        final List<dynamic> itemsData = response.data['data'];
        items = itemsData
            .map((itemData) => InspirationInfo.fromJson(itemData))
            .toList();

        // Sort items based on the 'order' property (if needed)

        // Print the fetched items (for debugging)
        for (var item in items) {
          print('Fetched Item: ${item.image}, ${item.prompt}');
        }
        return items;
      } else {
        print(
            'Failed to load items. Status Code: ${response.response.statusCode}');
        throw Exception('Failed to load items');
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
    return items;
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
