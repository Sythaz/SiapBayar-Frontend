import 'package:flutter/material.dart';
import 'package:siapbayar/models/patungan_model.dart';
import 'package:siapbayar/pages/tambah_pengeluaran_page.dart';

class AcaraPage extends StatefulWidget {
  final List<Kelompok> acaraList;
  final int kelompokId;

  const AcaraPage({
    super.key,
    required this.acaraList,
    required this.kelompokId,
  });

  @override
  State<StatefulWidget> createState() {
    return _AcaraPageState();
  }
}

class _AcaraPageState extends State<AcaraPage> {
  late List<Kelompok> _acaraList;
  late int _kelompokId;
  late List<Pengeluaran> daftarPengeluaran;

  @override
  void initState() {
    super.initState();
    _acaraList = widget.acaraList;
    _kelompokId = widget.kelompokId;
    // Contoh: Ambil pengeluaran dari kelompok yang dipilih
    final kelompok = _acaraList.firstWhere(
      (kelompok) => kelompok.id == _kelompokId,
      orElse: () => Kelompok(pengeluaran: []),
    );
    daftarPengeluaran = (kelompok.pengeluaran ?? []).cast<Pengeluaran>();

    print('daftar pengeluaran: $daftarPengeluaran');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _acaraList[_kelompokId].namaKelompok ?? 'Tidak ditemukan',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
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
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: (_acaraList[_kelompokId].anggota ?? []).length,
                      itemBuilder: (context, index) {
                        final relasi = _acaraList[_kelompokId].anggota![index];
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
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
                            relasi.anggota?.namaLengkap ?? '-',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
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
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Aksi tambah pengeluaran
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TambahPengeluaranPage(
                        isEdit: true,
                        namaKelompok:
                            _acaraList[_kelompokId].namaKelompok ??
                            'Tidak ditemukan',
                        dibuatPada:
                            _acaraList[_kelompokId].dibuatPada ??
                            '2000-01-01T23:59:59.319Z',
                        anggota: _acaraList[_kelompokId].anggota ?? [],
                        pengeluaran: _acaraList[_kelompokId].pengeluaran ?? [],
                      ),
                    ),
                  );
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
              child: daftarPengeluaran.isEmpty
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
    if (pengeluaran.tanggalPengeluaran != null) {
      try {
        final dt = DateTime.parse(pengeluaran.tanggalPengeluaran!);
        tanggal =
            '${dt.day} ${_bulanIndo(dt.month)}, ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {
        tanggal = pengeluaran.tanggalPengeluaran!;
      }
    }
    // Format total
    String total = pengeluaran.jumlahTotal != null
        ? _formatRupiah(pengeluaran.jumlahTotal!)
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

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan tanggal dan total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF2D5A5A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  tanggal,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF2D5A5A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Total: $total',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            child: Text(
              namaPembayar,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          SizedBox(height: 8),

          // Informasi Untuk
          Text(
            'Untuk:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            child: Text(
              namaPenanggung,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          SizedBox(height: 16),

          // Tombol Lihat Detail
          Container(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: () {
                // Aksi lihat detail
                _showDetailDialog(pengeluaran);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[400]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Lihat detail',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ),
          ),
        ],
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
              Text('Tanggal: ${pengeluaran.tanggalPengeluaran ?? '-'}'),
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

// Helper format bulan Indonesia
String _bulanIndo(int bulan) {
  const namaBulan = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  return namaBulan[bulan];
}

// Helper format rupiah
String _formatRupiah(String nominal) {
  if (nominal.isEmpty) return '-';
  final angka = int.tryParse(nominal.replaceAll('.', '')) ?? 0;
  return angka.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
}
