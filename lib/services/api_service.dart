import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/concert.dart';

class ApiService {
  static const String baseUrl = 'http://172.26.240.243:3000';

  static Future<List<Concert>> fetchConcerts() async {
    final response = await http.get(Uri.parse('$baseUrl/concerts'));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((data) => Concert.fromJson(data))
          .toList();
    } else {
      throw Exception('Erreur lors du chargement des concerts');
    }
  }
} 