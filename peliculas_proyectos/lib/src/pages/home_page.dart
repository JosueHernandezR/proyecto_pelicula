import 'package:flutter/material.dart';
import 'package:peliculas_proyectos/src/providers/peliculas_provider.dart';
import 'package:peliculas_proyectos/src/widgets/card_swiper_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Películas en cines'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        child: Column(children: <Widget>[
          _swiperTarjetas(),
        ]),
      ),
    );
  }

  Widget _swiperTarjetas() {
    final peliculasProvider =  new PeliculasProvider();
    peliculasProvider.getEnCines();
    return CardSwiper(
      peliculas: [1,2,3,4,5,6],
    );
  }
}
