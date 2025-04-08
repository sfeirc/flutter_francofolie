import 'package:flutter/material.dart';
import '../models/concert.dart';

class ConcertDetailScreen extends StatelessWidget {
  final Concert concert;

  const ConcertDetailScreen({super.key, required this.concert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(concert.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              concert.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            _buildInfoSection(
              context,
              'Artists',
              concert.artists.join(', '),
              Icons.person,
            ),
            _buildInfoSection(
              context,
              'Scene',
              '${concert.sceneName} - ${concert.location}',
              Icons.location_on,
            ),
            _buildInfoSection(
              context,
              'Date & Time',
              '${concert.date.day}/${concert.date.month}/${concert.date.year} ${concert.date.hour}:${concert.date.minute.toString().padLeft(2, '0')}',
              Icons.calendar_today,
            ),
            _buildInfoSection(
              context,
              'Duration',
              concert.duration,
              Icons.timer,
            ),
            _buildInfoSection(
              context,
              'Status',
              concert.status,
              Icons.info,
            ),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(concert.description),
            const SizedBox(height: 16),
            Text(
              'Pricing',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...concert.prices.entries.map(
              (entry) => ListTile(
                title: Text(entry.key),
                trailing: Text('€${entry.value.toStringAsFixed(2)}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(content),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 