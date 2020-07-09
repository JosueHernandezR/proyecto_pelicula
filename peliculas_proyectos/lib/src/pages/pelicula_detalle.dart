import 'package:flutter/material.dart';

import 'package:peliculas_proyectos/src/models/actores_model.dart';
import 'package:peliculas_proyectos/src/models/pelicula_model.dart';
import 'package:peliculas_proyectos/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );
  @override
  Widget build(BuildContext context) {
    //Recibir datos
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels ==
          _pageController.position.maxScrollExtent) {
        _pageController.position.animateTo(
          _pageController.position.maxScrollExtent - _screenSize.width * 0.35,
          duration: Duration(milliseconds: 500),
          curve: Curves.elasticOut,
        );
      }
      if (_pageController.position.pixels ==
          _pageController.position.minScrollExtent) {
        _pageController.position.animateTo(
          _screenSize.width * 0.3,
          duration: Duration(milliseconds: 500),
          curve: Curves.elasticOut,
        );
      }
    });

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppbar(pelicula),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            _posterTitulo(context, pelicula),
            _description(pelicula),
            _crearCasting(pelicula),
          ]),
        )
      ],
    ));
  }

  Widget _crearAppbar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      //Recibe un widget
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 300),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                pelicula.title,
                style: Theme.of(context).textTheme.title,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                pelicula.originalTitle,
                style: Theme.of(context).textTheme.subhead,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.star_border),
                  Text(
                    pelicula.voteAverage.toString(),
                    style: Theme.of(context).textTheme.subhead,
                  )
                ],
              )
            ],
          )),
        ],
      ),
    );
  }

  Widget _description(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    final _pageController =
        new PageController(initialPage: 1, viewportFraction: 0.3);
    _pageController.addListener(() {
      if (_pageController.position.pixels <= 50) {
        _pageController.animateToPage(1,
            duration: Duration(milliseconds: 3000), curve: Curves.elasticOut);
      }
    });

    return SizedBox(
      height: 200.0,
      child: PageView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          pageSnapping: false,
          controller: _pageController,
          itemCount: actores.length,
          itemBuilder: (context, int) => _actorTarjeta(actores[int])),
    );
  }

  Widget _actorTarjeta(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'),
              image: NetworkImage(actor.getFoto()),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
          )
        ],
      ),
    );
  }
}
