// lib/providers/news_provider.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsState {
  final List<NewsArticle> articles;
  final bool isLoading;
  final String? error;

  const NewsState({
    this.articles = const [],
    this.isLoading = false,
    this.error,
  });

  NewsState copyWith({
    List<NewsArticle>? articles,
    bool? isLoading,
    String? error,
  }) =>
      NewsState(
        articles: articles ?? this.articles,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class NewsNotifier extends StateNotifier<NewsState> {
  NewsNotifier() : super(const NewsState()) {
    fetch();
  }

  // Usando GNews API (gratuita, sem chave necessária para básico)
  // Substitua pela sua chave NewsAPI: https://newsapi.org
  static const _apiKey = 'SUA_CHAVE_NEWSAPI_AQUI';
  static const _useGNews = true; // true = sem chave, false = NewsAPI.org

  Future<void> fetch() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      List<NewsArticle> articles;

      if (_useGNews) {
        articles = await _fetchGNews();
      } else {
        articles = await _fetchNewsApi();
      }

      state = state.copyWith(articles: articles, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erro ao carregar notícias. Verifique sua conexão.',
        articles: _mockArticles(),
      );
    }
  }

  Future<List<NewsArticle>> _fetchGNews() async {
    // GNews API — gratuita, 100 req/dia sem conta
    final url = Uri.parse(
      'https://gnews.io/api/v4/search?q=financas+economia+brasil&lang=pt&country=br&max=10&apikey=GNEWS_KEY',
    );
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final articles = (data['articles'] as List<dynamic>? ?? []);
      return articles.map((a) => _fromGNews(a as Map<String, dynamic>)).toList();
    }
    return _mockArticles();
  }

  Future<List<NewsArticle>> _fetchNewsApi() async {
    final url = Uri.parse(
      'https://newsapi.org/v2/everything?q=finanças+pessoais+economia&language=pt&sortBy=publishedAt&pageSize=10&apiKey=$_apiKey',
    );
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final articles = (data['articles'] as List<dynamic>? ?? []);
      return articles.map((a) => NewsArticle.fromJson(a as Map<String, dynamic>)).toList();
    }
    return _mockArticles();
  }

  NewsArticle _fromGNews(Map<String, dynamic> json) => NewsArticle(
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
        url: json['url'] as String?,
        urlToImage: json['image'] as String?,
        source: (json['source'] as Map<String, dynamic>?)?['name'] as String?,
        publishedAt: json['publishedAt'] != null
            ? DateTime.tryParse(json['publishedAt'] as String)
            : null,
      );

  List<NewsArticle> _mockArticles() => [
        NewsArticle(
          title: 'Como controlar suas finanças pessoais em 2024',
          description:
              'Dicas práticas para organizar receitas e despesas e alcançar a liberdade financeira.',
          source: 'Finanças Hoje',
          publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        NewsArticle(
          title: 'Regra 50-30-20: o método mais popular para economizar',
          description:
              '50% para necessidades, 30% para desejos e 20% para poupança. Entenda como aplicar.',
          source: 'Investimentos & Cia',
          publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        NewsArticle(
          title: 'Inflação e poder de compra: o que você precisa saber',
          description:
              'Entenda como a inflação afeta seu orçamento e como se proteger dos seus efeitos.',
          source: 'Economia BR',
          publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        NewsArticle(
          title: 'Tesouro Direto: guia completo para iniciantes',
          description:
              'Aprenda a investir com segurança nos títulos públicos do governo federal.',
          source: 'Renda Fixa',
          publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        NewsArticle(
          title: 'Fundo de emergência: por que você precisa ter um',
          description:
              'Especialistas recomendam reservar ao menos 6 meses de despesas como segurança financeira.',
          source: 'Planejamento Financeiro',
          publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
}

final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>(
  (_) => NewsNotifier(),
);
