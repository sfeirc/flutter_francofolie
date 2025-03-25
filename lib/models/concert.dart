import 'package:intl/intl.dart';

class Concert {
  final int id;
  final String artiste;
  final DateTime date;
  final String lieu;

  Concert({
    required this.id,
    required this.artiste,
    required this.date,
    required this.lieu,
  });

  factory Concert.fromJson(Map<String, dynamic> json) {
    return Concert(
      id: json['id'],
      artiste: json['artiste'],
      date: DateTime.parse(json['date']),
      lieu: json['lieu'],
    );
  }

  String getFormattedDate() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }
} 