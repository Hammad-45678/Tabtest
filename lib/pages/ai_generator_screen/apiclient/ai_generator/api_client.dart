import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api_client.g.dart'; // Generated file

@RestApi(baseUrl: "https://cognise.art/api/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("/mobile/txt2img/generate/v2")
  Future<HttpResponse> sendRequest(@Body() Map<String, dynamic> requestBody,
      @Header("Authorization") String token);
}
