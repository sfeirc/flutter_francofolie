import 'package:intl/intl.dart';

class Concert {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String duration;
  final String status;
  final String sceneId;
  final String sceneName;
  final String location;
  final int capacity;
  final List<String> artists;
  final Map<String, double> prices;

  Concert({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.duration,
    required this.status,
    required this.sceneId,
    required this.sceneName,
    required this.location,
    required this.capacity,
    required this.artists,
    required this.prices,
  });

  factory Concert.fromJson(Map<String, dynamic> json) {
    return Concert(
      id: json['id_concert'],
      title: json['titre_concert'],
      description: json['description_concert'],
      date: DateTime.parse(json['date_concert']),
      duration: json['duree_concert'],
      status: json['statut_concert'],
      sceneId: json['id_scenes'],
      sceneName: json['nom_scene'],
      location: json['lieu'],
      capacity: json['capacité'],
      artists: (json['artistes'] as String).split(','),
      prices: _parsePrices(json['tarifs'] as String?),
    );
  }

  static Map<String, double> _parsePrices(String? pricesString) {
    if (pricesString == null) return {};
    final prices = <String, double>{};
    final pricePairs = pricesString.split(',');
    for (final pair in pricePairs) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        prices[parts[0]] = double.parse(parts[1]);
      }
    }
    return prices;
  }

  String getFormattedDate() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }
} 