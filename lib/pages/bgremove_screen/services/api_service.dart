import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart'; // Generate this file using build_runner

@RestApi(baseUrl: "https://lama.cognise.art/api/v2")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST("/bg_rm")
  @MultiPart()
  Future<HttpResponse> removeBg(
    @Header("Authorization") String authorization,
    @Part(name: 'image') File image,
    @Part(name: 'time_zone') String timeZone,
    @Part(name: 'packagename') String packageName,
    @Part(name: 'api_key') String apiKey,
  );
}
