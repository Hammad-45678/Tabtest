import 'dart:io';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api_client.g.dart'; // This file will be generated

@RestApi(baseUrl: "https://cognise.art/api")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("/generatepromptviaimage")
  @MultiPart()
  Future<HttpResponse<dynamic>> sendImage(
      @Part(name: 'img') File imageFile, @Header("Authorization") String token);
}
