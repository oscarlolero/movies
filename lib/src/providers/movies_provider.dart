import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/src/models/actors_model.dart';
import 'package:movies/src/models/movies_model.dart';

class MoviesProvider {
  String _apikey = '8f06e24c34f67bd39de1c397ff85d112';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularPage = 0;
  bool _loadingPage = false;

  List<Movie> _popular = new List();

  //entre <> se especifica que es lo que va a fluir en el stream
  final _popularStreamController = StreamController<List<Movie>>.broadcast();

  //insertar info al stream
  Function(List<Movie>) get popularSink => _popularStreamController.sink.add;

  //escuchar tod0 lo que el stream emite
  Stream<List<Movie>> get popularStream => _popularStreamController.stream;

  void disposeStreams() {
    // el signo es para que solo en caso de que este declarado se cierre
    _popularStreamController?.close();
  }

  Future<List<Movie>> _processUrl(Uri url) async {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);

    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language
    });

    return await _processUrl(url);
  }

  Future<List<Movie>> getPopular() async {
    if(_loadingPage) return [];

    _loadingPage = true;
    _popularPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularPage.toString()
    });

    final response = await _processUrl(url);

    _popular.addAll(response);
    popularSink(_popular);

    _loadingPage = false;
    return response;
  }

  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits', {
      'api_key': _apikey,
      'language': _language
    });

    final response = await http.get(url);
    final decodedData = json.decode(response.body);

    // final cast = new Cast.fromJsonList(decodedData['cast']);
    //
    // return cast.actors;
    return Cast.fromJsonList(decodedData['cast']).actors;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apikey,
      'language': _language,
      'query': query
    });

    return await _processUrl(url);
  }
}