// Import des packages nécessaires
import 'package:flutter/material.dart';
import '../models/concert.dart';
import '../services/api_service.dart';
import '../widgets/loading_indicator.dart';
import '../animations/fade_animation.dart';
import '../theme/app_theme.dart';
import 'concert_detail_screen.dart';

// Widget principal pour l'écran de liste des concerts
class ConcertListScreen extends StatefulWidget {
  const ConcertListScreen({super.key});

  @override
  State<ConcertListScreen> createState() => _ConcertListScreenState();
}

// État du widget ConcertListScreen
class _ConcertListScreenState extends State<ConcertListScreen> {
  final ApiService _apiService = ApiService();
  List<Concert> _concerts = [];
  List<dynamic> _scenes = [];
  List<dynamic> _artists = [];
  String? _selectedScene;
  String? _selectedArtist;
  DateTime? _selectedDate;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final [concerts, scenes, artists] = await Future.wait([
        _apiService.getConcerts(),
        _apiService.getScenes(),
        _apiService.getArtists(),
      ]);
      setState(() {
        _concerts = concerts as List<Concert>;
        _scenes = scenes;
        _artists = artists;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _filterConcerts() async {
    setState(() => _isLoading = true);
    try {
      List<Concert> filteredConcerts;
      if (_selectedScene != null) {
        filteredConcerts = await _apiService.getConcertsByScene(_selectedScene!);
      } else if (_selectedDate != null) {
        filteredConcerts = await _apiService.getConcertsByDate(
          '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
        );
      } else if (_selectedArtist != null) {
        filteredConcerts = await _apiService.getConcertsByArtist(_selectedArtist!);
      } else {
        filteredConcerts = await _apiService.getConcerts();
      }
      setState(() {
        _concerts = filteredConcerts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error filtering concerts: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Francofolies'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.7),
                      AppTheme.primaryColor.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterDialog(),
              ),
            ],
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: LoadingIndicator(),
            )
          else if (_concerts.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('No concerts found')),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final concert = _concerts[index];
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
                            padding: const EdgeInsets.all(16.0),
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
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            concert.artists.join(', '),
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: AppTheme.subtitleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
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
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: AppTheme.subtitleColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${concert.sceneName} - ${concert.location}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.subtitleColor,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
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
                childCount: _concerts.length,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showFilterDialog() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Concerts',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedScene,
              decoration: InputDecoration(
                labelText: 'Scene',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Scenes')),
                ..._scenes.map((scene) => DropdownMenuItem(
                      value: scene['id_scenes'],
                      child: Text(scene['nom_scene']),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedScene = value;
                  _selectedArtist = null;
                  _selectedDate = null;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedArtist,
              decoration: InputDecoration(
                labelText: 'Artist',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Artists')),
                ..._artists.map((artist) => DropdownMenuItem(
                      value: artist['id_artistes'],
                      child: Text(artist['nom_artistes']),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedArtist = value;
                  _selectedScene = null;
                  _selectedDate = null;
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                      _selectedScene = null;
                      _selectedArtist = null;
                    });
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(_selectedDate == null
                    ? 'Select Date'
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedScene = null;
                        _selectedArtist = null;
                        _selectedDate = null;
                      });
                      _filterConcerts();
                      Navigator.pop(context);
                    },
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _filterConcerts();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 