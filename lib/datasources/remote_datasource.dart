import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/patungan_model.dart';

class RemoteDataSource {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Mengambil semua data dari endpoint utama (/)
  Future<RootResponse> getSiapBayarData() async {
    final response = await http.get(Uri.parse('$baseUrl/all-data'));

    if (response.statusCode == 200) {
      return RootResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Gagal mengambil data. Kode status: ${response.statusCode}',
      );
    }
  }

  // Mengambil daftar kelompok
  Future<List<Kelompok>> getKelompokList() async {
    final response = await http.get(Uri.parse('$baseUrl/kelompok'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((item) => Kelompok.fromJson(item)).toList();
    } else {
      throw Exception(
        'Gagal mengambil daftar kelompok. Kode status: ${response.statusCode}',
      );
    }
  }

  // Mengambil kelompok berdasarkan ID
  Future<Kelompok> getKelompokById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/kelompok/$id'));

    if (response.statusCode == 200) {
      return Kelompok.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Gagal mengambil kelompok dengan ID $id. Kode status: ${response.statusCode}',
      );
    }
  }

  Future<Kelompok> createKelompok({
    required String namaKelompok,
    List<String> anggota = const [],
  }) async {
    final url = Uri.parse('$baseUrl/kelompok');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'namaKelompok': namaKelompok,
        'deskripsi':
            '', // atau biarkan user isi, tapi di form kamu belum ada field deskripsi
        'anggota': anggota,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Kelompok.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Gagal membuat kelompok: ${response.statusCode}, ${response.body}',
      );
    }
  }

  Future<Kelompok> editKelompok({
    required int id,
    required String namaKelompok,
    required String deskripsi,
    required List<int> anggotaIds, // ID anggota yang dipilih
  }) async {
    final url = Uri.parse('$baseUrl/kelompok/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'namaKelompok': namaKelompok,
        'deskripsi': deskripsi,
        'anggota': anggotaIds, // Kirim hanya ID anggota
      }),
    );

    if (response.statusCode == 200) {
      return Kelompok.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Gagal mengedit kelompok: ${response.statusCode}, ${response.body}',
      );
    }
  }

  Future<Pengeluaran> createPengeluaran({
    required int kelompokId,
    required String deskripsi,
    required String jumlahTotal,
    required String tanggalPengeluaran,
    required List<Map<String, dynamic>>
    pembayaran, // [{anggotaId: 1, jumlahBayar: "100000"}]
    required List<Map<String, dynamic>>
    jatahUrunan, // [{penanggungId: 2, jumlahJatah: "50000"}]
  }) async {
    final url = Uri.parse('$baseUrl/pengeluaran');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'deskripsi': deskripsi,
        'jumlahTotal': jumlahTotal,
        'tanggalPengeluaran': tanggalPengeluaran,
        'kelompokId': kelompokId,
        'pembayaran': pembayaran,
        'jatahUrunan': jatahUrunan,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Pengeluaran.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal membuat pengeluaran: ${response.statusCode}');
    }
  }

  // Untuk EDIT pengeluaran existing
  Future<Pengeluaran> editPengeluaran({
    required int id,
    required String deskripsi,
    required String jumlahTotal,
    required String tanggalPengeluaran,
    required List<Map<String, dynamic>> pembayaran,
    required List<Map<String, dynamic>> jatahUrunan,
  }) async {
    final url = Uri.parse('$baseUrl/pengeluaran/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'deskripsi': deskripsi,
        'jumlahTotal': jumlahTotal,
        'tanggalPengeluaran': tanggalPengeluaran,
        'pembayaran': pembayaran,
        'jatahUrunan': jatahUrunan,
      }),
    );

    if (response.statusCode == 200) {
      return Pengeluaran.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengedit pengeluaran: ${response.statusCode}');
    }
  }
}

/// Model untuk respons root (endpoint utama)
class RootResponse {
  List<Anggota>? anggota;
  List<Kelompok>? kelompok;
  List<Pengeluaran>? pengeluaran;
  List<JatahUrunan>? jatahUrunan;
  List<Pembayaran>? pembayaranPengeluaran;

  RootResponse({
    this.anggota,
    this.kelompok,
    this.pengeluaran,
    this.jatahUrunan,
    this.pembayaranPengeluaran,
  });

  factory RootResponse.fromJson(Map<String, dynamic> json) {
    return RootResponse(
      anggota: (json['anggota'] as List?)
          ?.map((e) => Anggota.fromJson(e))
          .toList(),
      kelompok: (json['kelompok'] as List?)
          ?.map((e) => Kelompok.fromJson(e))
          .toList(),
      pengeluaran: (json['pengeluaran'] as List?)
          ?.map((e) => Pengeluaran.fromJson(e))
          .toList(),
      jatahUrunan: (json['jatahUrunan'] as List?)
          ?.map((e) => JatahUrunan.fromJson(e))
          .toList(),
      pembayaranPengeluaran: (json['pembayaranPengeluaran'] as List?)
          ?.map((e) => Pembayaran.fromJson(e))
          .toList(),
    );
  }
}
