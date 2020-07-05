import 'package:flutter/material.dart';
import 'package:peliculas_proyectos/src/models/pelicula_model.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Recibir datos
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Center(
        child: Text(pelicula.title),
      ),
    );
  }
}
