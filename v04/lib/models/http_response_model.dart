import 'hero_model.dart';

class HttpResponseSearchModel {
  final String response;
  final String resultsFor;
  final List<HeroModel> results;

  HttpResponseSearchModel({
    required this.response,
    required this.resultsFor,
    required this.results,
  });

  factory HttpResponseSearchModel.fromJson(Map<String, dynamic> json) {
    return HttpResponseSearchModel(
      response: json['response'] ?? '',
      resultsFor: json['results-for'] ?? '',
      results: (json['results'] as List<dynamic>)
          .map((e) => HeroModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'results-for': resultsFor,
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}
