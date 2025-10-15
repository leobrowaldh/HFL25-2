import '../models/http_response_model.dart';

abstract class IHeroHttpClient {
  Future<HttpResponseModel> searchHeroes(String query);
}
