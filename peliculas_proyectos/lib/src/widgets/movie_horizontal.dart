import 'package:flutter/material.dart';
import 'package:peliculas_proyectos/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    //Escuchar todos los cambios en el pageViewController
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        //print('Cargar siguientes películas');
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.25,
      //.builder crea bajo demanda lo que se requiere
      child: PageView.builder(
        pageSnapping: false,
        //Posible falla de memoria
        controller: _pageController,
        //children: _tarjetas(context),
        //Como se va a construir cada PageView
        itemCount: peliculas.length,
        itemBuilder: (context, i) => _tarjeta( context, peliculas[i] ),
      ),
    );
  }
  //Crear una sola tarjeta
  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    return Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(pelicula.getPosterImg()),
              placeholder: AssetImage('assets/img/no.image.jpg'),
              fit: BoxFit.cover,
              height: 160.0,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  // List<Widget> _tarjetas(BuildContext context) {
  //   return peliculas.map((pelicula) {}).toList();
  // }
}
