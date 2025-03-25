// Import des packages nécessaires
import 'package:flutter/material.dart';
import '../models/concert.dart';

// Widget principal pour l'écran des favoris
class FavoritesScreen extends StatelessWidget {
  // Propriétés du widget
  final Set<int> favoris;
  final List<Concert> concerts;
  final Function(Concert) onToggleFavori;

  // Constructeur avec paramètres nommés requis
  const FavoritesScreen({
    Key? key,
    required this.favoris,
    required this.concerts,
    required this.onToggleFavori,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filtrer les concerts favoris
    final concertsFavoris = concerts.where((concert) => favoris.contains(concert.id)).toList();

    // Afficher un message si aucun favori
    if (concertsFavoris.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'Aucun concert favori',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ajoutez des concerts à vos favoris pour les retrouver ici',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Liste des concerts favoris
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: concertsFavoris.length,
      itemBuilder: (context, index) {
        final concert = concertsFavoris[index];
        // Carte pour chaque concert favori
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            // Icône de musique à gauche
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
            // Nom de l'artiste
            title: Text(
              concert.artiste,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            // Informations complémentaires
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                // Date du concert
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
                // Lieu du concert
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
            // Bouton favori
            trailing: IconButton(
              icon: Icon(Icons.favorite, color: Theme.of(context).primaryColor),
              onPressed: () => onToggleFavori(concert),
            ),
          ),
        );
      },
    );
  }
} 