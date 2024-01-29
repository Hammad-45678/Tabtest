import 'dart:io';
import 'package:dio/dio.dart';
import 'package:picstar/pages/bgremove_screen/services/api_service.dart';

class ApiRepository {
  final ApiClient _client;

  ApiRepository(this._client);

  Future<String> removeBgApi(String imagePath,
      {required CancelToken cancelToken}) async {
    try {
      final response = await _client.removeBg(
        "token c20427c5b6cbd5cd63096d2777f882fe9b4b1263",
        File(imagePath),
        "Asia/Karachi",
        "testing",
        "cognise-6f15cec1-6686-4ffe-990a-bf6683429651",
      );

      if (response.response.statusCode == 200) {
        final jsonResponse = response.data;
        if (jsonResponse["status"] == "success") {
          var data = jsonResponse['data'];
          if (data != null && data.containsKey('image')) {
            return "https://lama.cognise.art${data['image']}";
          } else {
            throw Exception("Image key not found in response");
          }
        } else {
          throw Exception("Error occurred: ${jsonResponse["message"]}");
        }
      } else {
        throw Exception(
            "Error occurred with response ${response.response.statusCode}");
      }
    } on DioError catch (e) {
      // Handle Dio specific errors
      throw Exception("DioError: ${e.message}");
    }
  }
}
