import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api_client.g.dart'; // This file will be generated

@RestApi(baseUrl: "https://cognise.art/api/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // Define the method for fetching inspiration items
  @GET("/generation/inspirations")
  Future<HttpResponse<dynamic>> fetchItems(
    @Query("pagination") int pagination,
    @Query("hit_point") String hitPoint,
    @Header("Authorization") String token,
  );
}
