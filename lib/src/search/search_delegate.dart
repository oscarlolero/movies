import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movies/src/models/movies_model.dart';
import 'package:movies/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {
  final moviesProvider = new MoviesProvider();

  final movies = ['Spiderman', 'Captain', 'Shrek', 'Ironman'];
  final recentMovies = ['Spiderman', 'Captain America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // acciones de nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izq del appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // builder que crea los resultados a mostrar
    return Center(
      child: Container(
        height: 100.0,
        child: Text('item seleccionado'),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return Container();

    return FutureBuilder(
        future: moviesProvider.searchMovies(query),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          final movies = snapshot.data;
          return snapshot.hasData
              ? ListView(
                  children: movies.map((movie) {
                    return ListTile(
                      leading: FadeInImage(
                        placeholder: AssetImage('assets/img/no-image.jpg'),
                        image: NetworkImage(movie.getPosterImg()),
                        width: 50.0,
                        fit: BoxFit.contain,
                      ),
                      title: Text(movie.title),
                      subtitle: Text('${movie.originalTitle} (${movie.originalLanguage})'),
                      trailing: Column(
                        children: [
                          SizedBox(height: 10),
                          Icon(Icons.star,size: 20),
                          Text(movie.voteAverage.toString(), style: TextStyle(fontSize: 12),)
                        ],
                      ),
                      onTap: () {
                        movie.uniqueId = '';
                        Navigator.pushNamed(context, 'detail', arguments: movie);
                      },
                    );
                  }).toList(),
                )
              : Center(child: CircularProgressIndicator());
        });
  }

// @override
// Widget buildSuggestions(BuildContext context) {
//   final suggeredList = query.isEmpty
//       ? recentMovies
//       : movies.where((p) => p.toLowerCase().startsWith(query)).toList();
//
//   // sugerencias que aparecen cuando la persona escribe
//   return ListView.builder(
//     itemCount: suggeredList.length,
//     itemBuilder: (context, i) {
//       return ListTile(
//         leading: Icon(Icons.movie),
//         title: Text(suggeredList[i]),
//         onTap: () {},
//       );
//     },
//   );
// }
}
