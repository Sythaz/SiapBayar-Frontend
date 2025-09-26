import 'package:flutter/material.dart';
import 'package:siapbayar/colors.dart';
import 'package:siapbayar/datasources/remote_datasource.dart';
import 'package:siapbayar/models/patungan_model.dart';
import 'package:siapbayar/pages/tambah_pengeluaran_page.dart';

import '../helpers/format_bulan.dart';
import '../helpers/format_rupiah.dart';

class AcaraPage extends StatefulWidget {
  final Map<String, dynamic> dataAcara;

  const AcaraPage({super.key, required this.dataAcara});

  @override
  State<StatefulWidget> createState() {
    return _AcaraPageState();
  }
}

class _AcaraPageState extends State<AcaraPage> {
  late Map<String, dynamic> _dataAcara;
  late List<Pengeluaran> daftarPengeluaran;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dataAcara = widget.dataAcara;
    _fetchPengeluaran();
  }

  Future<void> _fetchPengeluaran() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await RemoteDataSource().getData();
      _dataAcara = response.firstWhere((e) => e['id'] == _dataAcara['id']);
      final dataPengeluaran = _dataAcara['pengeluaran'] ?? [];
      daftarPengeluaran = (dataPengeluaran as List)
          .map((e) => Pengeluaran.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching pengeluaran: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 25),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _dataAcara['namaKelompok'] ?? 'Tidak ditemukan',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Anggota dengan Row
            Text(
              'Anggota',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tombol Tambah Anggota
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF2D5A5A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 24),
                ),
                SizedBox(width: 12),
                // Container scrollable anggota
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: (_dataAcara['anggota'] as List).length,
                            itemBuilder: (context, index) {
                              final data = _dataAcara['anggota'];

                              return Container(
                                margin: EdgeInsets.only(
                                  right: index == data.length - 1 ? 8 : 8,
                                  left: index == 0 ? 8 : 0,
                                  top: 8,
                                  bottom: 8,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  data[index]['anggota']['namaLengkap'],
                                  style: TextStyle(color: AppColors.black),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Tombol Tambah Pengeluaran
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TambahPengeluaranPage(
                        isEdit: false,
                        anggotaList: _dataAcara['anggota'],
                      ),
                    ),
                  );
                  if (result != null) {
                    await _fetchPengeluaran();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2D5A5A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Tambah Pengeluaran',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Daftar Pengeluaran Header
            Text(
              'Daftar Pengeluaran',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),

            // Daftar Pengeluaran List
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : daftarPengeluaran.isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada pengeluaran',
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: daftarPengeluaran.length,
                      itemBuilder: (context, index) {
                        final pengeluaran = daftarPengeluaran[index];
                        return _buildPengeluaranCard(pengeluaran);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPengeluaranCard(Pengeluaran pengeluaran) {
    // Format tanggal
    String tanggal = '-';

    if (pengeluaran.dibuatPada != null) {
      try {
        final dt = pengeluaran.dibuatPada!;
        tanggal =
            '${dt.day} ${bulanIndo(dt.month)}, ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {
        tanggal = pengeluaran.dibuatPada!.toIso8601String();
      }
    }

    String deskripsiPembelian = pengeluaran.deskripsi ?? '-';

    // Format total
    String total = pengeluaran.jumlahTotal != null
        ? formatRupiah(pengeluaran.jumlahTotal!)
        : '-';

    // Nama pembayar
    String namaPembayar =
        pengeluaran.pembayaran != null && pengeluaran.pembayaran!.isNotEmpty
        ? pengeluaran.pembayaran!
              .map((p) => p.anggota?.namaLengkap ?? '-')
              .join(', ')
        : '-';
    // Nama penanggung urunan
    String namaPenanggung =
        pengeluaran.jatahUrunan != null && pengeluaran.jatahUrunan!.isNotEmpty
        ? pengeluaran.jatahUrunan!
              .map((j) => j.penanggung?.namaLengkap ?? '-')
              .join(', ')
        : '-';

    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TambahPengeluaranPage(
              isEdit: true,
              anggotaList: _dataAcara['anggota'],
              kelompokId: _dataAcara['id'],
              namaKelompok: deskripsiPembelian,
              dibuatPada: tanggal,
              pengeluaran: pengeluaran,
            ),
          ),
        );
        if (result != null) {
          await _fetchPengeluaran();
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppColors.primary),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              color: AppColors.grey.withAlpha((0.5 * 255).toInt()),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  deskripsiPembelian,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Divider(
              color: AppColors.primary,
              thickness: 1.1,
              radius: BorderRadius.circular(50),
            ),

            // Header dengan tanggal dan total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Color(0xFF2D5A5A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    tanggal,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Color(0xFF2D5A5A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Total: $total',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Informasi Pembayar
            Text(
              'Pembayar:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                namaPembayar,
                style: TextStyle(fontSize: 14, color: Color(0xFF1F1F1F)),
              ),
            ),
            SizedBox(height: 8),

            // Informasi Untuk
            Text(
              'Untuk:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                namaPenanggung,
                style: TextStyle(fontSize: 14, color: Color(0xFF1F1F1F)),
              ),
            ),
            SizedBox(height: 16),

            // Tombol Lihat Detail
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  // Aksi lihat detail
                  _showDetailDialog(pengeluaran);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Lihat detail',
                  style: TextStyle(color: AppColors.primary, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // Helper format bulan Indonesia
  }

  void _showDetailDialog(Pengeluaran pengeluaran) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detail Pengeluaran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tanggal: ${pengeluaran.dibuatPada ?? '-'}'),
              SizedBox(height: 8),
              Text('Total: ${pengeluaran.jumlahTotal ?? '-'}'),
              SizedBox(height: 8),
              Text('Pembayar:'),
              ...?pengeluaran.pembayaran?.map(
                (p) => Text(
                  '${p.anggota?.namaLengkap ?? '-'} - Rp${p.jumlahBayar ?? '-'}',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              SizedBox(height: 8),
              Text('Jatah Urunan:'),
              ...?pengeluaran.jatahUrunan?.map(
                (j) => Text(
                  '${j.penanggung?.namaLengkap ?? '-'} - Rp${j.jumlahJatah ?? '-'}',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
