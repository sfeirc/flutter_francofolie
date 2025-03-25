// Import des packages nécessaires
import 'package:flutter/material.dart';
import '../models/concert.dart';
import '../services/api_service.dart';

// Widget principal pour l'écran de liste des concerts
class ConcertListScreen extends StatelessWidget {
  final List<Concert> concerts;
  final Set<int> favoris;
  final bool isLoading;
  final Function(Concert) onToggleFavori;
  final Future<void> Function() onRefresh;

  const ConcertListScreen({
    Key? key,
    required this.concerts,
    required this.favoris,
    required this.isLoading,
    required this.onToggleFavori,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Concerts des Francofolies'),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Chargement des concerts...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: concerts.length,
                itemBuilder: (context, index) {
                  final concert = concerts[index];
                  final isFavori = favoris.contains(concert.id);
                  
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.music_note,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        concert.artiste,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                concert.getFormattedDate(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.grey),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  concert.lieu,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isFavori ? Icons.favorite : Icons.favorite_border,
                          color: isFavori ? Theme.of(context).primaryColor : Colors.grey,
                        ),
                        onPressed: () => onToggleFavori(concert),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
} 