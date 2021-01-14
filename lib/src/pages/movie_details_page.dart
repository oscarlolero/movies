import 'package:flutter/material.dart';
import 'package:movies/src/models/movies_model.dart';

class MovieDetailsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //tambien se podria desde el constructor recibir Movie pero esta es otra forma de hacerlo
    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Center(child: Text(movie.title)),
    );
  }
}
