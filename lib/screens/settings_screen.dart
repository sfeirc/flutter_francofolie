import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final Function(ThemeMode) onThemeModeChanged;

  const SettingsScreen({
    Key? key,
    required this.onThemeModeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Préférences',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8),
          _buildThemeTile(context),
        ],
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.palette),
        title: Text('Thème'),
        subtitle: Text(_getThemeModeText(context)),
        trailing: Icon(_getThemeModeIcon(context)),
        onTap: () => _showThemeModeDialog(context),
      ),
    );
  }

  String _getThemeModeText(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.light) {
      return 'Clair';
    } else if (brightness == Brightness.dark) {
      return 'Sombre';
    } else {
      return 'Système';
    }
  }

  IconData _getThemeModeIcon(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.light) {
      return Icons.light_mode;
    } else if (brightness == Brightness.dark) {
      return Icons.dark_mode;
    } else {
      return Icons.brightness_auto;
    }
  }

  void _showThemeModeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.light_mode),
            title: Text('Clair'),
            onTap: () {
              onThemeModeChanged(ThemeMode.light);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Sombre'),
            onTap: () {
              onThemeModeChanged(ThemeMode.dark);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.brightness_auto),
            title: Text('Système'),
            onTap: () {
              onThemeModeChanged(ThemeMode.system);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
} 