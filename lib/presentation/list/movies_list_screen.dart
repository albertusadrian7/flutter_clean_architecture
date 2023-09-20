import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/data/repository/movies_repository.dart';
import 'package:flutter_clean_architecture/domain/models/movie.dart';
import 'package:provider/provider.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  @override
  Widget build(BuildContext context) {
    final movieRepo = Provider.of<MoviesRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Movies"),
      ),
      body: FutureBuilder<List<Movie>>(
        future: movieRepo.getUpcomingMovies(limit: 10, page: 1),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: List.generate(
                  snapshot.data!.length,
                  (index) => ListTile(
                        title: Text(snapshot.data![index].title),
                      )),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
