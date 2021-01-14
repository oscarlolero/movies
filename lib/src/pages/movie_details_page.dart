import 'package:flutter/material.dart';

import 'package:movies/src/models/actors_model.dart';
import 'package:movies/src/models/movies_model.dart';
import 'package:movies/src/providers/movies_provider.dart';

class MovieDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //tambien se podria desde el constructor recibir Movie pero esta es otra forma de hacerlo
    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            _createAppbar(movie),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 10.0),
                  _posterTitle(context, movie),
                  _description(movie),
                  _createCasting(movie),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createAppbar(Movie movie) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/img/loading.gif'),
          image: NetworkImage(movie.getBackgroundImg()),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitle(BuildContext context, Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(movie.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  movie.originalTitle,
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Icon(Icons.star_border),
                    SizedBox(width: 4.0),
                    Text(
                      movie.voteAverage.toString(),
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _description(Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _createCasting(Movie movie) {
    final movieProvider = new MoviesProvider();
    return FutureBuilder(
        future: movieProvider.getCast(movie.id.toString()),
        builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
          return snapshot.hasData
              ? _createCastingPageView(context, snapshot.data)
              : Center(child: CircularProgressIndicator());
        });
  }

  Widget _createCastingPageView(BuildContext context, List<Actor> cast) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: cast.length,
        itemBuilder: (context, i) {
          return _actorCard(cast[i]);
        },
      ),
    );
  }

  Widget _actorCard(Actor actor) {
    return Container(
      margin: EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'),
              image: NetworkImage(actor.getActorImg()),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
