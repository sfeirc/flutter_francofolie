// Import des packages nécessaires
import 'package:flutter/material.dart';
import 'screens/concert_list_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/settings_screen.dart';
import 'models/concert.dart';
import 'services/api_service.dart';

// Point d'entrée de l'application
void main() {
  runApp(MyApp());
}

// Widget principal de l'application avec gestion d'état
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// État du widget principal
class _MyAppState extends State<MyApp> {
  // Mode de thème actuel (clair/sombre/système)
  ThemeMode _themeMode = ThemeMode.system;

  // Méthode pour basculer entre les modes de thème
  void _toggleThemeMode() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.system;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Francofolies App',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      // Configuration du thème clair
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF1976D2),
          brightness: Brightness.light,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
        ),
      ),
      // Configuration du thème sombre
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF1976D2),
          brightness: Brightness.dark,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: MainScreen(onThemeModeChanged: setThemeMode),
    );
  }

  // Getters et setters pour le mode de thème
  ThemeMode get themeMode => _themeMode;
  void setThemeMode(ThemeMode mode) => setState(() => _themeMode = mode);
}

// Widget pour l'écran principal avec navigation
class MainScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeModeChanged;

  const MainScreen({
    Key? key,
    required this.onThemeModeChanged,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

// État de l'écran principal
class _MainScreenState extends State<MainScreen> {
  // Index de l'onglet sélectionné
  int _selectedIndex = 0;
  // Liste des concerts disponibles
  final List<Concert> _concerts = [];
  // Ensemble des IDs des concerts favoris
  final Set<int> _favoris = {};
  // État de chargement
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConcerts();
  }

  // Chargement des concerts depuis l'API
  Future<void> _loadConcerts() async {
    try {
      final loadedConcerts = await ApiService.fetchConcerts();
      setState(() {
        _concerts.addAll(loadedConcerts);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar(
        message: 'Erreur lors du chargement des concerts: $e',
        isError: true,
      );
    }
  }

  // Affichage des messages de notification
  void _showSnackBar({
    required String message,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Gestion du changement d'onglet
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Construction du contenu principal selon l'onglet sélectionné
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return ConcertListScreen(
          concerts: _concerts,
          favoris: _favoris,
          isLoading: _isLoading,
          onToggleFavori: (concert) {
            setState(() {
              if (_favoris.contains(concert.id)) {
                _favoris.remove(concert.id);
                _showSnackBar(message: 'Concert retiré des favoris');
              } else {
                _favoris.add(concert.id);
                _showSnackBar(message: 'Concert ajouté aux favoris');
              }
            });
          },
          onRefresh: _loadConcerts,
        );
      case 1:
        return FavoritesScreen(
          concerts: _concerts,
          favoris: _favoris,
          onToggleFavori: (concert) {
            setState(() {
              if (_favoris.contains(concert.id)) {
                _favoris.remove(concert.id);
                _showSnackBar(message: 'Concert retiré des favoris');
              } else {
                _favoris.add(concert.id);
                _showSnackBar(message: 'Concert ajouté aux favoris');
              }
            });
          },
        );
      case 2:
        return SettingsScreen(onThemeModeChanged: widget.onThemeModeChanged);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      // Barre de navigation inférieure
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Concerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
