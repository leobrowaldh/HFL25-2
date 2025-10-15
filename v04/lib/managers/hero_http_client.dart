import 'i_hero_http_client.dart';
import '../models/http_response_model.dart';

class HeroHttpClient implements IHeroHttpClient {
  @override
  Future<HttpResponseModel> searchHeroes(String query) async {
    throw UnimplementedError();
  }
}
