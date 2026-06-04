// lib/models/news_model.dart
class NewsArticle {
  final String title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? source;
  final DateTime? publishedAt;

  const NewsArticle({
    required this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.source,
    this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) => NewsArticle(
        title: json['title'] as String? ?? 'Sem título',
        description: json['description'] as String?,
        url: json['url'] as String?,
        urlToImage: json['urlToImage'] as String?,
        source: (json['source'] as Map<String, dynamic>?)?['name'] as String?,
        publishedAt: json['publishedAt'] != null
            ? DateTime.tryParse(json['publishedAt'] as String)
            : null,
      );
}
