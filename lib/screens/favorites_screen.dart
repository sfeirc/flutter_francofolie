import 'package:flutter/material.dart';
import '../models/concert.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../animations/fade_animation.dart';
import '../l10n/fr.dart';
import '../providers/favorites_provider.dart';
import 'package:provider/provider.dart';
import 'concert_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ApiService _apiService = ApiService();
  List<Concert> _allConcerts = [];
  List<Concert> _favoriteConcerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConcerts();
  }

  Future<void> _loadConcerts() async {
    try {
      final concerts = await _apiService.getConcerts();
      setState(() {
        _allConcerts = concerts;
        _isLoading = false;
      });
      _updateFavorites();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(FrenchTranslations.translations['errorLoading']!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _updateFavorites() {
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    setState(() {
      _favoriteConcerts = favoritesProvider.filterFavorites(_allConcerts);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, _) {
          _favoriteConcerts = favoritesProvider.filterFavorites(_allConcerts);
          
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: isSmallScreen ? 100 : 120,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(FrenchTranslations.translations['favorites']!),
                  background: Container(
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
              if (_isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_favoriteConcerts.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: AppTheme.primaryColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          FrenchTranslations.translations['noFavorites']!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          FrenchTranslations.translations['addFavorites']!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.subtitleColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final concert = _favoriteConcerts[index];
                      return FadeAnimation(
                        delay: index * 0.1,
                        child: Hero(
                          tag: 'concert-${concert.id}',
                          child: Card(
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConcertDetailScreen(concert: concert),
                                ),
                              ),
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                concert.title,
                                                style: Theme.of(context).textTheme.titleLarge,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                concert.artists.join(', '),
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: AppTheme.subtitleColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.favorite,
                                            color: AppTheme.primaryColor,
                                          ),
                                          onPressed: () {
                                            favoritesProvider.toggleFavorite(concert);
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 16,
                                          color: AppTheme.subtitleColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            '${concert.sceneName} - ${concert.location}',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: AppTheme.subtitleColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: AppTheme.subtitleColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${concert.date.hour}:${concert.date.minute.toString().padLeft(2, '0')}',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppTheme.subtitleColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: _favoriteConcerts.length,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
} 