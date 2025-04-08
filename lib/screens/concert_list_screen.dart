// Import des packages nécessaires
import 'package:flutter/material.dart';
import '../models/concert.dart';
import '../services/api_service.dart';
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
          SnackBar(content: Text('Error loading data: $e')),
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
          SnackBar(content: Text('Error filtering concerts: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre d'application
      appBar: AppBar(
        title: const Text('Francofolies Concerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      // Corps de l'application
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Affichage du loader pendant le chargement
          : _concerts.isEmpty
              ? const Center(child: Text('No concerts found'))
              : RefreshIndicator(
                  onRefresh: _filterConcerts, // Permet de rafraîchir la liste en tirant vers le bas
                  child: ListView.builder(
                    itemCount: _concerts.length,
                    itemBuilder: (context, index) {
                      final concert = _concerts[index];
                      // Carte pour chaque concert
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(concert.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(concert.artists.join(', ')),
                              Text('${concert.sceneName} - ${concert.location}'),
                              Text(
                                '${concert.date.day}/${concert.date.month}/${concert.date.year} ${concert.date.hour}:${concert.date.minute.toString().padLeft(2, '0')}',
                              ),
                            ],
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConcertDetailScreen(concert: concert),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Future<void> _showFilterDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Concerts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedScene,
              decoration: const InputDecoration(labelText: 'Scene'),
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
            DropdownButtonFormField<String>(
              value: _selectedArtist,
              decoration: const InputDecoration(labelText: 'Artist'),
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
            TextButton(
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
              child: Text(_selectedDate == null
                  ? 'Select Date'
                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
            ),
          ],
        ),
        actions: [
          TextButton(
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
          TextButton(
            onPressed: () {
              _filterConcerts();
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
} 