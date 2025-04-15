import 'package:flutter/material.dart';
import 'concert_list_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';
import '../l10n/fr.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ConcertListScreen(),
          FavoritesScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.music_note),
            label: FrenchTranslations.translations['concerts'] ?? 'Concerts',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: FrenchTranslations.translations['favorites'] ?? 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: FrenchTranslations.translations['settings'] ?? 'Réglages',
          ),
        ],
      ),
    );
  }
} 