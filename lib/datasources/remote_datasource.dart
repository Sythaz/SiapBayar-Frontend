import 'dart:convert';

import 'package:http/http.dart' as http;

class RemoteDataSource {
  // Base URL API untuk android emulator
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Base URL API untuk IOS emulator
  // static const String baseUrl = 'http://localhost:3000/api';

  // Fungsi GET untuk ambil data acara
  Future<List<Map<String, dynamic>>> getData() async {
    final response = await http.get(Uri.parse('$baseUrl/kelompok'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else if (data is Map && data['data'] != null) {
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception("Format response tidak sesuai");
      }
    } else {
      throw Exception("Gagal mengambil data: ${response.statusCode}");
    }
  }
}
