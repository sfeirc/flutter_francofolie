import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/concert.dart';

class ApiService {
  static const String baseUrl = 'http://172.26.240.243:3000/api';

  Future<List<Concert>> getConcerts() async {
    final response = await http.get(Uri.parse('$baseUrl/concerts'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Concert.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load concerts');
    }
  }

  Future<List<Concert>> getConcertsByScene(String sceneId) async {
    final response = await http.get(Uri.parse('$baseUrl/concerts/scene/$sceneId'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Concert.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load concerts by scene');
    }
  }

  Future<List<Concert>> getConcertsByDate(String date) async {
    final response = await http.get(Uri.parse('$baseUrl/concerts/date/$date'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Concert.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load concerts by date');
    }
  }

  Future<List<Concert>> getConcertsByArtist(String artistId) async {
    final response = await http.get(Uri.parse('$baseUrl/concerts/artist/$artistId'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Concert.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load concerts by artist');
    }
  }

  Future<List<dynamic>> getScenes() async {
    final response = await http.get(Uri.parse('$baseUrl/scenes'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load scenes');
    }
  }

  Future<List<dynamic>> getArtists() async {
    final response = await http.get(Uri.parse('$baseUrl/artists'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load artists');
    }
  }
} 