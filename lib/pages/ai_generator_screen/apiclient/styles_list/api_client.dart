import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api_client.g.dart'; // This file will be generated

@RestApi(baseUrl: "https://cognise.art/api/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/styles")
  Future<HttpResponse<dynamic>> fetchItems(
      @Header("Authorization") String token);
}
