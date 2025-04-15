import 'package:flutter/material.dart';
import '../models/concert.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteConcertIds = {};

  Set<String> get favoriteConcertIds => _favoriteConcertIds;

  bool isFavorite(String concertId) {
    return _favoriteConcertIds.contains(concertId);
  }

  void toggleFavorite(Concert concert) {
    if (_favoriteConcertIds.contains(concert.id)) {
      _favoriteConcertIds.remove(concert.id);
    } else {
      _favoriteConcertIds.add(concert.id);
    }
    notifyListeners();
  }

  List<Concert> filterFavorites(List<Concert> allConcerts) {
    return allConcerts.where((concert) => _favoriteConcertIds.contains(concert.id)).toList();
  }
} 