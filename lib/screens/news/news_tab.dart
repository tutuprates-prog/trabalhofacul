// lib/screens/news/news_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/news_model.dart';
import '../../providers/news_provider.dart';
import '../../widgets/skeleton_loader.dart';

class NewsTab extends ConsumerWidget {
  const NewsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(newsProvider);

    if (state.isLoading) {
      return ListView(
        padding: const EdgeInsets.only(top: 12),
        children: List.generate(
            5, (_) => const NewsSkeletonTile()),
      );
    }

    if (state.error != null && state.articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_outlined,
                size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(state.error!,
                style: TextStyle(color: Colors.grey.shade500),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(newsProvider.notifier).fetch(),
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(180, 44)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(newsProvider.notifier).fetch(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.trending_up,
                        size: 14, color: Colors.blue.shade700),
                    const SizedBox(width: 4),
                    Text('Dicas & Notícias Financeiras',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(),
          const SizedBox(height: 14),

          if (state.error != null)
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Colors.amber.shade700, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                        'Exibindo notícias de exemplo. Configure uma chave de API para dados reais.',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade800)),
                  ),
                ],
              ),
            ).animate().fadeIn(),

          ...state.articles.asMap().entries.map((e) {
            return _NewsCard(article: e.value)
                .animate()
                .fadeIn(delay: Duration(milliseconds: e.key * 60))
                .slideY(begin: 0.04);
          }),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsArticle article;
  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          if (article.url != null) {
            final uri = Uri.tryParse(article.url!);
            if (uri != null) {
              try {
                await launchUrl(uri,
                    mode: LaunchMode.externalApplication);
              } catch (_) {}
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem / placeholder
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: article.urlToImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          article.urlToImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                              Icons.newspaper_outlined,
                              color: Colors.blue.shade200,
                              size: 32),
                        ),
                      )
                    : Icon(Icons.newspaper_outlined,
                        color: Colors.blue.shade200, size: 32),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(article.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    if (article.description != null)
                      Text(article.description!,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (article.source != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(article.source!,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 6),
                        ],
                        if (article.publishedAt != null)
                          Text(
                            _timeAgo(article.publishedAt!),
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}min atrás';
    if (diff.inHours < 24) return '${diff.inHours}h atrás';
    return DateFormat('dd/MM').format(dt);
  }
}
