import 'package:flutter_clean_architecture/data/network/entity/movie_entity.dart';
import 'package:flutter_clean_architecture/domain/exception/mapper_exception.dart';
import 'package:flutter_clean_architecture/domain/models/movie.dart';
import 'package:logger/logger.dart';

class NetworkMapper {
  final Logger log;
  NetworkMapper({required this.log});

  Movie toMovie(MovieEntity movieEntity) {
    try {
      return Movie(
          id: movieEntity.id,
          title: movieEntity.titleText.text,
          imageUrl: movieEntity.primaryImage?.url,
        releaseDate: DateTime (
          movieEntity.releaseDate.year,
          movieEntity.releaseDate.month,
          movieEntity.releaseDate.day
        )
      );
    } catch (e) {
      throw MapperException<MovieEntity, Movie>(e.toString());
    }
  }

  List<Movie> toMovies(List<MovieEntity> movieEntities) {
    final List<Movie> movies = [];
    for(final movieEntity in movieEntities) {
      try {
        movies.add(toMovie(movieEntity));
      } catch (e) {
        log.e('Could not map entity ${movieEntity.id}', error: e);
      }
    }
    return movies;
  }
}

