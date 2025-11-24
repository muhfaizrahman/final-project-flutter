/// Domain Entity - Pure business object, no dependencies on frameworks
class MovieEntity {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double? ratingAverage;
  final String? releaseDate;
  final List<String>? genres;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    this.ratingAverage,
    this.releaseDate,
    this.genres,
  });

  MovieEntity copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    double? ratingAverage,
    String? releaseDate,
    List<String>? genres,
  }) {
    return MovieEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MovieEntity &&
        other.id == id &&
        other.title == title &&
        other.overview == overview &&
        other.posterPath == posterPath &&
        other.ratingAverage == ratingAverage &&
        other.releaseDate == releaseDate &&
        other.genres == genres;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        overview.hashCode ^
        posterPath.hashCode ^
        ratingAverage.hashCode ^
        releaseDate.hashCode ^
        genres.hashCode;
  }
}

