import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/hasil_perhitungan_model.dart';
import '../models/patungan_model.dart';

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

  Future<String> createAnggota({
    required String nama,
    required int kelompokId,
  }) async {
    final url = Uri.parse('$baseUrl/kelompok/$kelompokId/anggota');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'namaLengkap': nama}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['namaLengkap'] ?? '';
    } else {
      throw Exception('Gagal membuat anggota: ${response.statusCode}');
    }
  }

  // Fungsi POST untuk membuat pengeluaran
  Future<Pengeluaran> createPengeluaran({
    required int kelompokId,
    required String deskripsi,
    required String jumlahTotal,
    required DateTime tanggalPengeluaran,
    required List<Map<String, dynamic>> pembayaran,
    required List<Map<String, dynamic>> jatahUrunan,
  }) async {
    final url = Uri.parse('$baseUrl/pengeluaran');

    final requestBody = jsonEncode({
      'deskripsi': deskripsi,
      'jumlahTotal': jumlahTotal,
      'tanggalPengeluaran': tanggalPengeluaran.toIso8601String(),
      'pembayaran': pembayaran,
      'jatahUrunan': jatahUrunan,
    });

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBody,
    );

    // print('Cek Request Body Create: $requestBody');

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return Pengeluaran.fromMap(responseData);
    } else {
      // print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Gagal menyimpan pengeluaran: ${response.statusCode}');
    }
  }

  // Fungsi PUT untuk mengupdate pengeluaran
  Future<Pengeluaran> updatePengeluaran({
    required int pengeluaranId,
    required int kelompokId,
    required String deskripsi,
    required String jumlahTotal,
    required DateTime tanggalPengeluaran,
    required List<Map<String, dynamic>> pembayaran,
    required List<Map<String, dynamic>> jatahUrunan,
  }) async {
    final url = Uri.parse('$baseUrl/pengeluaran/$pengeluaranId');

    final requestBody = jsonEncode({
      'deskripsi': deskripsi,
      'jumlahTotal': jumlahTotal,
      'tanggalPengeluaran': tanggalPengeluaran.toIso8601String(),
      'pembayaran': pembayaran,
      'jatahUrunan': jatahUrunan,
    });

    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBody,
    );

    // print('CEk Request Body Update: $requestBody');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return Pengeluaran.fromMap(responseData);
    } else {
      // print('Error Update: ${response.statusCode} - ${response.body}');
      throw Exception('Gagal mengupdate pengeluaran: ${response.statusCode}');
    }
  }

  // Fungsi GET hasil perhitungan pengeluaran
  Future<HasilPerhitunganModel> getHasilPerhitungan(int idAcara) async {
    final url = Uri.parse('$baseUrl/pengeluaran/hitung/$idAcara');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return HasilPerhitunganModel.fromMap(data);
    } else {
      throw Exception(
        'Gagal mengambil hasil perhitungan: ${response.statusCode}',
      );
    }
  }
}
