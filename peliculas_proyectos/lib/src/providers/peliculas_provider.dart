import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas_proyectos/src/models/pelicula_model.dart';

class PeliculasProvider {


  String _apikey = 'd668e95fe7e3cf5a6ef69f2a008ddd16';
  String _url = 'api.themoviedb.org';
  String _languaje = 'es-ES';

  int _popularesPage = 0;
  bool _cargando     = false;

  //Stream: corriente de datos
  List<Pelicula> _populares = new List();
  //Código del stream
  //Si se pone el broadcas permite que se escuche el stream en varios puntos
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();
  //Cerrar streams cuando no se use
  void disposeStreams(){
    _popularesStreamController?.close();
  }
  //Solo apunta al stream para agregar peliculas al afluentes que maneja el stream
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
  //Función para escuchar peliculas del flujo del stream
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    //Codificar la data, obtener la data
    final decodeData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodeData['results']);
    // print( peliculas.items[0].title);

    return peliculas.items;
  }

  //
  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey, 
      'languaje': _languaje
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if ( _cargando ) return [];
    
    _cargando = true;

    _popularesPage ++;

    //print('Cargando siguientes...');

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key' : _apikey, 
      'languaje': _languaje,
      'page'    : _popularesPage.toString(),
    });

    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);
    //Mandar al inicio del flujo de datos
    popularesSink( _populares);
    _cargando = false;
    return resp;
  }
  
}
