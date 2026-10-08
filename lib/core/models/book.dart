class Book {
  final String key;
  final String title;
  final String? authorName;
  final int? coverId;
  final int? firstPublishYear;
  final double? ratingAverage;
  final int? ratingCount;

  const Book({
    required this.key,
    required this.title,
    this.authorName,
    this.coverId,
    this.firstPublishYear,
    this.ratingAverage,
    this.ratingCount,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final authors = json['author_name'];

    return Book(
      key: (json['key'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      authorName: authors is List && authors.isNotEmpty
          ? authors.first.toString()
          : json['authorName'] as String?,
      coverId:
          (json['cover_i'] as num?)?.toInt() ??
          (json['coverId'] as num?)?.toInt(),
      firstPublishYear:
          (json['first_publish_year'] as num?)?.toInt() ??
          (json['firstPublishYear'] as num?)?.toInt(),
      ratingAverage:
          (json['ratings_average'] as num?)?.toDouble() ??
          (json['ratingAverage'] as num?)?.toDouble(),
      ratingCount:
          (json['ratings_count'] as num?)?.toInt() ??
          (json['ratingCount'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'title': title,
    'authorName': authorName,
    'coverId': coverId,
    'firstPublishYear': firstPublishYear,
    'ratingAverage': ratingAverage,
    'ratingCount': ratingCount,
  };

  String get author => authorName ?? 'Unknown';

  String? get coverUrl {
    if (coverId == null) {
      return null;
    }

    return 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
  }
}
