import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:picstar/pages/ai_generator_screen/apiclient/styles_list/api_client.dart';
import 'package:picstar/pages/ai_generator_screen/model/model.dart';

import '../../../../global/exceptions/api_exceptions.dart';

class StylesList {
  late List<ItemModel> stylesItems;
  Future<List<ItemModel>> fetchItems(BuildContext context) async {
    final dio = Dio(); // Provide a Dio instance to handle HTTP requests
    final apiService = ApiService(dio);

    try {
      final response = await apiService
          .fetchItems("token 7bb91a6699cc3794750101ce0354d80195f07c04");

      if (response.response.statusCode == 200) {
        final List<dynamic> itemsData = response.data['data'];
        stylesItems =
            itemsData.map((itemData) => ItemModel.fromJson(itemData)).toList();

        // Sort and print items as needed

        return stylesItems;
      } else {
        _showErrorPopup(context, 'Error',
            'Failed to load items. Status Code: ${response.response.statusCode}');
        return [];
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
    return stylesItems;
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
