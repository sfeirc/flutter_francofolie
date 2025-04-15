import 'package:flutter/material.dart';
import '../models/concert.dart';
import '../theme/app_theme.dart';
import '../animations/fade_animation.dart';
import '../l10n/fr.dart';
import '../providers/favorites_provider.dart';
import 'package:provider/provider.dart';

class ConcertDetailScreen extends StatelessWidget {
  final Concert concert;

  const ConcertDetailScreen({super.key, required this.concert});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(concert.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: isSmallScreen ? 150 : 200,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppTheme.primaryColor : Colors.white,
                ),
                onPressed: () {
                  favoritesProvider.toggleFavorite(concert);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite 
                          ? 'Concert retiré des favoris'
                          : 'Concert ajouté aux favoris',
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                concert.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              background: Hero(
                tag: 'concert-${concert.id}',
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.gradientStart.withOpacity(0.8),
                        AppTheme.gradientEnd.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeAnimation(
                    delay: 0.2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        concert.status,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeAnimation(
                    delay: 0.3,
                    child: Text(
                      FrenchTranslations.translations['artists']!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeAnimation(
                    delay: 0.4,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: concert.artists.map((artist) => Chip(
                        label: Text(artist),
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        labelStyle: TextStyle(color: AppTheme.primaryColor),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeAnimation(
                    delay: 0.5,
                    child: _buildInfoRow(
                      context,
                      Icons.location_on,
                      FrenchTranslations.translations['location']!,
                      '${concert.sceneName} - ${concert.location}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeAnimation(
                    delay: 0.6,
                    child: _buildInfoRow(
                      context,
                      Icons.calendar_today,
                      FrenchTranslations.translations['dateTime']!,
                      '${concert.date.day}/${concert.date.month}/${concert.date.year} à ${concert.date.hour}:${concert.date.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeAnimation(
                    delay: 0.7,
                    child: _buildInfoRow(
                      context,
                      Icons.timer,
                      FrenchTranslations.translations['duration']!,
                      concert.duration,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeAnimation(
                    delay: 0.8,
                    child: _buildInfoRow(
                      context,
                      Icons.people,
                      FrenchTranslations.translations['capacity']!,
                      '${concert.capacity} places',
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeAnimation(
                    delay: 0.9,
                    child: Text(
                      FrenchTranslations.translations['description']!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeAnimation(
                    delay: 1.0,
                    child: Text(
                      concert.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeAnimation(
                    delay: 1.1,
                    child: Text(
                      FrenchTranslations.translations['pricing']!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...concert.prices.entries.map(
                    (entry) => FadeAnimation(
                      delay: 1.2 + concert.prices.keys.toList().indexOf(entry.key) * 0.1,
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            entry.key,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${entry.value.toStringAsFixed(2)}€',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppTheme.secondaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(FrenchTranslations.translations['bookingComingSoon']!),
              backgroundColor: AppTheme.primaryColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.calendar_today),
        label: Text(FrenchTranslations.translations['bookNow']!),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String title, String content) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.subtitleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
} 