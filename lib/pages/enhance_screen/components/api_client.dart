import 'dart:async';
import 'dart:io';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://lama.cognise.art/api/v2/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("/img_upscale")
  @MultiPart()
  Future<HttpResponse<dynamic>> upscaleImage(
    @Part(name: 'image') File image,
    @Part(name: 'time_zone') String timeZone,
    @Part(name: 'packagename') String packageName,
    @Part(name: 'api_key') String apiKey,
    @Part(name: 'upscale') String upscale,
    @CancelRequest() CancelToken cancelToken,
  );

  @POST("/img_enhance")
  @MultiPart()
  Future<HttpResponse<dynamic>> enhanceImage(
    @Part(name: 'image') File image,
    @Part(name: 'time_zone') String timeZone,
    @Part(name: 'packagename') String packageName,
    @Part(name: 'api_key') String apiKey,
    @CancelRequest() CancelToken cancelToken,
  );
}
