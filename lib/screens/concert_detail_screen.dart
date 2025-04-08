import 'package:flutter/material.dart';
import '../models/concert.dart';
import '../theme/app_theme.dart';
import '../animations/fade_animation.dart';

class ConcertDetailScreen extends StatelessWidget {
  final Concert concert;

  const ConcertDetailScreen({super.key, required this.concert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(concert.title),
              background: Hero(
                tag: 'concert-${concert.id}',
                child: Container(
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
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeAnimation(
                    delay: 0.2,
                    child: Container(
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
                  ),
                  const SizedBox(height: 16),
                  FadeAnimation(
                    delay: 0.3,
                    child: Text(
                      'Artists',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeAnimation(
                    delay: 0.4,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: concert.artists.map((artist) => Chip(
                        label: Text(artist),
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        labelStyle: TextStyle(color: AppTheme.primaryColor),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeAnimation(
                    delay: 0.5,
                    child: _buildInfoRow(
                      context,
                      Icons.location_on,
                      'Location',
                      '${concert.sceneName} - ${concert.location}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeAnimation(
                    delay: 0.6,
                    child: _buildInfoRow(
                      context,
                      Icons.calendar_today,
                      'Date & Time',
                      '${concert.date.day}/${concert.date.month}/${concert.date.year} at ${concert.date.hour}:${concert.date.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeAnimation(
                    delay: 0.7,
                    child: _buildInfoRow(
                      context,
                      Icons.timer,
                      'Duration',
                      concert.duration,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeAnimation(
                    delay: 0.8,
                    child: _buildInfoRow(
                      context,
                      Icons.people,
                      'Capacity',
                      concert.capacity.toString(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeAnimation(
                    delay: 0.9,
                    child: Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeAnimation(
                    delay: 1.0,
                    child: Text(
                      concert.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeAnimation(
                    delay: 1.1,
                    child: Text(
                      'Pricing',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...concert.prices.entries.map(
                    (entry) => FadeAnimation(
                      delay: 1.2 + concert.prices.keys.toList().indexOf(entry.key) * 0.1,
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            entry.key,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '€${entry.value.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppTheme.secondaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement booking functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking functionality coming soon!'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.calendar_today),
        label: const Text('Book Now'),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String title, String content) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.subtitleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
} 