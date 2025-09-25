import 'package:flutter/material.dart';
import 'package:siapbayar/colors.dart';
import 'package:siapbayar/datasources/remote_datasource.dart'
    show RemoteDataSource;
import 'package:siapbayar/models/patungan_model.dart';

class TambahPengeluaranPage extends StatefulWidget {
  final bool isEdit;
  final String namaKelompok;
  final List<AnggotaRelasi> anggota;
  final String dibuatPada;
  final List<Pengeluaran> pengeluaran;

  const TambahPengeluaranPage({
    super.key,
    required this.isEdit,
    required this.namaKelompok,
    required this.dibuatPada,
    required this.anggota,
    required this.pengeluaran,
  });

  @override
  State<TambahPengeluaranPage> createState() => _TambahPengeluaranPageState();
}

class _TambahPengeluaranPageState extends State<TambahPengeluaranPage> {
  // Untuk dropdown pembayar dan pembeli
  List<String> get _daftarNamaAnggota {
    return widget.anggota
        .map((relasi) => relasi.anggota?.namaLengkap ?? 'Tanpa Nama')
        .toList();
  }

  List<String> get _daftarPembayar {
    return widget.anggota
        .map((relasi) => relasi.anggota?.namaLengkap ?? 'Tanpa Nama')
        .toList();
  }

  List<String> get _daftarPembeli {
    return widget.anggota
        .map((relasi) => relasi.anggota?.namaLengkap ?? 'Tanpa Nama')
        .toList();
  }

  // Untuk nama acara
  final TextEditingController _namaAcaraController = TextEditingController();

  // Untuk tanggal dan waktu
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Untuk pembayar terpilih
  List<String?> pembayarController = [];
  List<TextEditingController> nominalController = [TextEditingController()];

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

  Future<void> _simpanPengeluaran() async {
    // Validasi input
    if (_namaAcaraController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama acara wajib diisi')));
      return;
    }

    if (pembayarController.isEmpty ||
        pembayarController.any((p) => p == null)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih pembayar')));
      return;
    }

    // Validasi nominal
    int total = 0;
    for (var controller in nominalController) {
      if (controller.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Nominal wajib diisi')));
        return;
      }
      // Hapus titik ribuan jika ada (misal: "1.000.000" -> "1000000")
      String cleanNominal = controller.text.replaceAll('.', '');
      total += int.tryParse(cleanNominal) ?? 0;
    }

    // Mapping nama ke ID
    Map<String, int> namaToId = {};
    for (var relasi in widget.anggota) {
      if (relasi.anggota?.namaLengkap != null) {
        namaToId[relasi.anggota!.namaLengkap!] = relasi.anggotaId!;
      }
    }

    // Siapkan data pembayaran
    List<Map<String, dynamic>> pembayaran = [];
    for (int i = 0; i < pembayarController.length; i++) {
      String? nama = pembayarController[i];
      if (nama != null && namaToId.containsKey(nama)) {
        pembayaran.add({
          'anggotaId': namaToId[nama],
          'jumlahBayar': nominalController[i].text.replaceAll('.', ''),
        });
      }
    }

    // Siapkan data jatah urunan
    List<Map<String, dynamic>> jatahUrunan = [];
    for (String? nama in pembeliController) {
      if (nama != null && namaToId.containsKey(nama)) {
        jatahUrunan.add({
          'penanggungId': namaToId[nama],
          'jumlahJatah': (total / pembeliController.length).toStringAsFixed(0),
        });
      }
    }

    // Format tanggal yang benar (ISO 8601)
    String formatTanggal() {
      return '${_selectedDate!.year}-'
          '${_selectedDate!.month.toString().padLeft(2, '0')}-'
          '${_selectedDate!.day.toString().padLeft(2, '0')}T'
          '${_selectedTime!.hour.toString().padLeft(2, '0')}:'
          '${_selectedTime!.minute.toString().padLeft(2, '0')}:00.000Z';
    }

    // Siapkan data untuk dikirim
    Map<String, dynamic> dataKirim = {
      'deskripsi': _namaAcaraController.text,
      'jumlahTotal': total.toString(),
      'tanggalPengeluaran': formatTanggal(),
      'pembayaran': pembayaran,
      'jatahUrunan': jatahUrunan,
    };

    // Untuk mode EDIT, tambahkan ID di body
    if (widget.isEdit) {
      dataKirim['id'] = widget.pengeluaran[0].id;
    }
    // Untuk mode TAMBAH, tambahkan kelompokId
    else {
      dataKirim['kelompokId'] = widget.anggota[0].kelompokId;
    }

    // DEBUG: Print data lengkap
    print('Data yang dikirim ke API:');
    print(dataKirim);

    try {
      final dataSource = RemoteDataSource();

      if (widget.isEdit) {
        await dataSource.editPengeluaran(
          id: widget.pengeluaran[0].id!,
          deskripsi: _namaAcaraController.text,
          jumlahTotal: total.toString(),
          tanggalPengeluaran: formatTanggal(),
          pembayaran: pembayaran,
          jatahUrunan: jatahUrunan,
        );
      } else {
        await dataSource.createPengeluaran(
          kelompokId: widget.anggota[0].kelompokId!,
          deskripsi: _namaAcaraController.text,
          jumlahTotal: total.toString(),
          tanggalPengeluaran: formatTanggal(),
          pembayaran: pembayaran,
          jatahUrunan: jatahUrunan,
        );
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan...')));
      print('Error detail: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.parse(widget.dibuatPada);
    final dateTime = DateTime.parse(widget.dibuatPada).toLocal();
    _selectedTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);

    if (widget.isEdit && widget.pengeluaran.isNotEmpty) {
      // Mode EDIT: isi dari data pengeluaran
      Pengeluaran pengeluaran = widget.pengeluaran[0];

      // Isi pembayar
      pembayarController = pengeluaran.pembayaran!
          .map((p) => p.anggota?.namaLengkap)
          .toList();
      nominalController = pengeluaran.pembayaran!
          .map((p) => TextEditingController(text: p.jumlahBayar))
          .toList();

      // Isi pembeli
      pembeliController = pengeluaran.jatahUrunan!
          .map((j) => j.penanggung?.namaLengkap)
          .toList();
    } else {
      if (widget.anggota.isNotEmpty) {
        String namaPertama =
            widget.anggota[0].anggota?.namaLengkap ?? 'Tanpa Nama';
        pembayarController = [namaPertama];
        pembeliController = [namaPertama];
        nominalController = [TextEditingController()];
      } else {
        pembayarController = [null];
        pembeliController = [null];
        nominalController = [TextEditingController()];
      }
    }

    if (widget.namaKelompok.isNotEmpty) {
      _namaAcaraController.text = widget.namaKelompok;
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
              onTap: () => _simpanPengeluaran(),
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
                'Nama Acara',
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
                    flex: 2,
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
                    flex: 1,
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
                          if (pembayarController.length <
                              _daftarNamaAnggota.length) {
                            setState(() {
                              pembayarController.add(null);
                              nominalController.add(TextEditingController());
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
                                items: _daftarNamaAnggota
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
                          if (pembeliController.length <
                              _daftarNamaAnggota.length) {
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
                                items: _daftarNamaAnggota
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
}
