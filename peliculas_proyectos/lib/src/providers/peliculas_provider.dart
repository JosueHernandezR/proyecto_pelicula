import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:peliculas_proyectos/src/models/pelicula_model.dart';

class PeliculasProvider{

  String _apikey   = 'd668e95fe7e3cf5a6ef69f2a008ddd16';
  String _url      = 'api.themoviedb.org';
  String _languaje = 'es-ES';

  //
  Future <List<Pelicula>> getEnCines() async{

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'  : _apikey,
      'languaje' : _languaje
    });

    //
    final resp = await http.get(url);
    //Codificar la data, obtener la data
    final decodeData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodeData['results']);
    print( peliculas.items[0].title);

    return peliculas.items;
  }
}