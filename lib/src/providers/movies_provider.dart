import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:movies/src/models/movies_model.dart';

class MoviesProvider {
  String _apikey = '8f06e24c34f67bd39de1c397ff85d112';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  Future<List<Movie>>getNowPlaying() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language
    });

    final response = await http.get(url);
    final decodedData = json.decode(response.body);

    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }
}