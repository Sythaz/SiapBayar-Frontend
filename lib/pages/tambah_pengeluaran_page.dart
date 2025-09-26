import 'package:flutter/material.dart';
import 'package:siapbayar/colors.dart';

import '../datasources/remote_datasource.dart';
import '../models/patungan_model.dart';

class TambahPengeluaranPage extends StatefulWidget {
  final bool isEdit;
  final List<dynamic> anggotaList;
  final int? kelompokId;
  final String? namaKelompok;
  final String? dibuatPada;
  final Pengeluaran? pengeluaran;

  const TambahPengeluaranPage({
    super.key,
    required this.isEdit,
    required this.anggotaList,
    this.kelompokId,
    this.namaKelompok,
    this.dibuatPada,
    this.pengeluaran,
  });

  @override
  State<TambahPengeluaranPage> createState() => _TambahPengeluaranPageState();
}

class _TambahPengeluaranPageState extends State<TambahPengeluaranPage> {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();

  // Untuk nama acara
  final TextEditingController _namaAcaraController = TextEditingController();

  Pengeluaran? pengeluaran;

  List<String>? anggotaList;

  int? kelompokId;

  // Untuk tanggal dan waktu
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Untuk pembayar terpilih
  List<String?> pembayarController = [];
  List<TextEditingController> nominalController = [];

  List<String?> pembeliController = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primary,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Inisialisasi id kelompok/acara
    kelompokId = widget.kelompokId;

    // Inisialisasi nama anggota
    anggotaList = (widget.anggotaList)
        .cast<Map<String, dynamic>>()
        .map((e) => e['anggota']['namaLengkap'] as String)
        .toList();

    // Inisialisasi pengeluaran
    pengeluaran = widget.pengeluaran;

    if (!widget.isEdit) {
      // Inisialisasi tanggal dan waktu
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();

      pembayarController.add(null);
      nominalController.add(TextEditingController());

      pembeliController.add(null);
    }

    if (widget.isEdit && widget.pengeluaran != null) {
      // Inisialisasi nama acara
      _namaAcaraController.text = widget.namaKelompok!;

      // Inisialisasi tanggal dan waktu
      if (widget.pengeluaran?.dibuatPada != null) {
        final dateTime = widget.pengeluaran!.dibuatPada!.toLocal();
        _selectedDate = dateTime;
        _selectedTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
      }

      // Isi pembayar
      pembayarController = pengeluaran!.pembayaran!
          .map((p) => p.anggota?.namaLengkap)
          .toList();
      nominalController = pengeluaran!.pembayaran!
          .map((p) => TextEditingController(text: p.jumlahBayar))
          .toList();

      // Isi pembeli
      pembeliController = pengeluaran!.jatahUrunan!
          .map((j) => j.penanggung?.namaLengkap)
          .toList();
    }
  }

  @override
  void dispose() {
    _namaAcaraController.dispose();
    for (var controller in nominalController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        title: Text(
          widget.isEdit ? 'Edit Pengeluaran' : 'Tambah Pengeluaran',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                _simpanPengeluaran();
              },
              child: const Text(
                'Simpan',
                style: TextStyle(fontSize: 14, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Deskripsi Pengeluaran',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      color: AppColors.grey.withAlpha((0.5 * 255).toInt()),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _namaAcaraController,
                  decoration: InputDecoration(
                    hintText: 'Nama barang atau keperluan..',
                    hintStyle: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Tanggal & Waktu',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 4),
                              color: AppColors.grey.withAlpha(
                                (0.5 * 255).toInt(),
                              ),
                              blurRadius: 10.0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'Pilih tanggal'
                                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                              style: TextStyle(
                                color: _selectedDate == null
                                    ? AppColors.grey
                                    : Colors.black,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => _selectTime(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 4),
                              color: AppColors.grey.withAlpha(
                                (0.5 * 255).toInt(),
                              ),
                              blurRadius: 10.0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedTime == null
                                  ? 'Pilih waktu'
                                  : '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: _selectedTime == null
                                    ? AppColors.grey
                                    : Colors.black,
                              ),
                            ),
                            const Icon(
                              Icons.access_time,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bagian Pembayar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pembayar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (widget.isEdit) {
                            if (pembayarController.length <
                                anggotaList!.length) {
                              setState(() {
                                pembayarController.add(null);
                                nominalController.add(TextEditingController());
                              });
                            }
                          } else {
                            if (pembayarController.length <
                                anggotaList!.length) {
                              setState(() {
                                pembayarController.add(null);
                                nominalController.add(TextEditingController());
                              });
                            }
                          }
                        },
                        icon: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.add, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                  for (int i = 0; i < pembayarController.length; i++)
                    Padding(
                      padding: i < pembayarController.length - 1
                          ? const EdgeInsets.only(bottom: 10)
                          : EdgeInsets.zero,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: AppColors.primary,
                              size: 32,
                            ),
                            onPressed: () {
                              if (pembayarController.length > 1) {
                                setState(() {
                                  nominalController[i].dispose();
                                  nominalController.removeAt(i);
                                  pembayarController.removeAt(i);
                                });
                              }
                            },
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.grey.withAlpha(
                                      (0.3 * 255).toInt(),
                                    ),
                                    blurRadius: 10.0,
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                initialValue: pembayarController[i],
                                decoration: InputDecoration(
                                  labelText: 'Pilih Pembayar',
                                  labelStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.white,
                                ),
                                icon: const Icon(Icons.arrow_drop_down),
                                onChanged: (String? value) {
                                  setState(() {
                                    pembayarController[i] = value;
                                  });
                                },
                                items: anggotaList!
                                    .where(
                                      (nama) =>
                                          !pembayarController.contains(nama) ||
                                          pembayarController[i] == nama,
                                    )
                                    .map(
                                      (String nama) => DropdownMenuItem<String>(
                                        value: nama,
                                        child: Text(
                                          nama,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.grey.withAlpha(
                                      (0.3 * 255).toInt(),
                                    ),
                                    blurRadius: 10.0,
                                  ),
                                ],
                              ),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: nominalController[i],
                                decoration: InputDecoration(
                                  labelStyle: const TextStyle(fontSize: 12),
                                  labelText: "Nominal (Rp)",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 15),

                  // Bagian Pembeli
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pembeli',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (pembeliController.length < anggotaList!.length) {
                            setState(() {
                              pembeliController.add(null);
                            });
                          }
                        },
                        icon: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.add, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                  for (int i = 0; i < pembeliController.length; i++)
                    Padding(
                      padding: i < pembeliController.length - 1
                          ? const EdgeInsets.only(bottom: 10)
                          : EdgeInsets.zero,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: AppColors.primary,
                              size: 32,
                            ),
                            onPressed: () {
                              if (pembeliController.length > 1) {
                                setState(() {
                                  pembeliController.removeAt(i);
                                });
                              }
                            },
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.grey.withAlpha(
                                      (0.3 * 255).toInt(),
                                    ),
                                    blurRadius: 10.0,
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                initialValue: pembeliController[i],
                                decoration: InputDecoration(
                                  labelText: 'Pilih Pembeli',
                                  labelStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.white,
                                ),
                                icon: const Icon(Icons.arrow_drop_down),
                                onChanged: (String? value) {
                                  setState(() {
                                    pembeliController[i] = value;
                                  });
                                },
                                items: anggotaList!
                                    .where(
                                      (nama) =>
                                          !pembeliController.contains(nama) ||
                                          pembeliController[i] == nama,
                                    )
                                    .map(
                                      (String nama) => DropdownMenuItem<String>(
                                        value: nama,
                                        child: Text(
                                          nama,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _simpanPengeluaran() async {
    // Validasi input lainnya (nama acara, tanggal, dll.) tetap seperti sebelumnya
    if (_namaAcaraController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deskripsi pengeluaran tidak boleh kosong.'),
        ),
      );
      return;
    }
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal dan waktu harus dipilih.')),
      );
      return;
    }
    if (pembayarController.isEmpty ||
        pembayarController.every((element) => element == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal satu pembayar harus dipilih.')),
      );
      return;
    }
    if (pembeliController.isEmpty ||
        pembeliController.every((element) => element == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal satu pembeli harus dipilih.')),
      );
      return;
    }

    // Gabungkan tanggal dan waktu
    final selectedDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    // Validasi nominal
    double totalInput = 0.0;
    for (int i = 0; i < nominalController.length; i++) {
      final nominalText = nominalController[i].text.trim();
      if (nominalText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nominal pembayaran tidak boleh kosong.'),
          ),
        );
        return;
      }
      try {
        final nominal = double.parse(nominalText);
        if (nominal <= 0) {
          throw FormatException(); // Anggap nominal <= 0 sebagai format salah
        }
        totalInput += nominal;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nominal pembayaran harus berupa angka positif.'),
          ),
        );
        return;
      }
    }

    // Buat list pembayaran dan jatah urunan
    List<Map<String, dynamic>> pembayaranList = [];
    List<Map<String, dynamic>> jatahUrunanList = [];

    for (int i = 0; i < pembayarController.length; i++) {
      final namaPembayar = pembayarController[i];
      final nominal = nominalController[i].text.trim();
      if (namaPembayar != null && nominal.isNotEmpty) {
        // Pastikan nama dan nominal tidak null/empty
        // Cari ID anggota berdasarkan nama
        final anggotaMap = widget.anggotaList.firstWhere(
          (e) => e['anggota']['namaLengkap'] == namaPembayar,
          orElse: () => null, // Kembalikan null jika tidak ditemukan
        );

        // Perbaiki pengecekan dan pengambilan anggotaId dari anggota['anggotaId']
        if (anggotaMap != null &&
            anggotaMap['anggota'] != null &&
            anggotaMap['anggota']['id'] != null) {
          pembayaranList.add({
            'anggotaId': anggotaMap['anggota']['id'],
            'jumlahBayar': nominal,
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ID anggota tidak ditemukan untuk: $namaPembayar'),
            ),
          );
          return;
        }
      }
    }

    for (int i = 0; i < pembeliController.length; i++) {
      final namaPembeli = pembeliController[i];
      if (namaPembeli != null) {
        // Pastikan nama pembeli tidak null
        final anggotaMap = widget.anggotaList.firstWhere(
          (e) => e['anggota']['namaLengkap'] == namaPembeli,
          orElse: () => null, // Kembalikan null jika tidak ditemukan
        );

        // Perbaiki pengecekan dan pengambilan anggotaId dari anggota['anggotaId']
        if (anggotaMap != null &&
            anggotaMap['anggota'] != null &&
            anggotaMap['anggota']['id'] != null) {
          double jumlahJatah = totalInput / pembeliController.length;
          jatahUrunanList.add({
            'penanggungId': anggotaMap['anggota']['id'],
            'jumlahJatah': jumlahJatah.toStringAsFixed(2),
            'sudahLunas': false,
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ID anggota tidak ditemukan untuk: $namaPembeli'),
            ),
          );
          return;
        }
      }
    }

    // Pastikan ada data pembayaran dan jatah urunan setelah validasi ID
    if (pembayaranList.isEmpty || jatahUrunanList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Data pembayaran atau jatah urunan tidak lengkap setelah validasi ID anggota.',
          ),
        ),
      );
      return;
    }

    // Pastikan widget.kelompokId tidak null
    if (widget.kelompokId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID Kelompok tidak ditemukan.')),
      );
      return;
    }

    try {
      Pengeluaran savedPengeluaran;
      if (widget.isEdit && widget.pengeluaran != null) {
        // Panggil fungsi update
        savedPengeluaran = await _remoteDataSource.updatePengeluaran(
          pengeluaranId: widget.pengeluaran!.id!,
          kelompokId: widget.kelompokId!,
          deskripsi: _namaAcaraController.text,
          jumlahTotal: totalInput.toStringAsFixed(2),
          tanggalPengeluaran: selectedDateTime,
          pembayaran: pembayaranList,
          jatahUrunan: jatahUrunanList,
        );
        // Tampilkan pesan sukses update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pengeluaran "${savedPengeluaran.deskripsi}" berhasil diperbarui.',
            ),
          ),
        );
      } else {
        // Panggil fungsi create
        savedPengeluaran = await _remoteDataSource.createPengeluaran(
          kelompokId: widget.kelompokId!,
          deskripsi: _namaAcaraController.text,
          jumlahTotal: totalInput.toStringAsFixed(2),
          tanggalPengeluaran: selectedDateTime,
          pembayaran: pembayaranList,
          jatahUrunan: jatahUrunanList,
        );
        // Tampilkan pesan sukses create
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pengeluaran "${savedPengeluaran.deskripsi}" berhasil ditambahkan.',
            ),
          ),
        );
      }

      // Pop kembali ke halaman sebelumnya setelah sukses
      Navigator.pop(context, savedPengeluaran);
    } catch (e) {
      print('Error menyimpan pengeluaran: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan pengeluaran: $e')),
      );
    }
  }
}
