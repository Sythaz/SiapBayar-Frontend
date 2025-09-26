import 'package:flutter/material.dart';
import 'package:siapbayar/colors.dart';

import '../models/patungan_model.dart';

class TambahPengeluaranPage extends StatefulWidget {
  final bool isEdit;
  final List<dynamic> anggotaList;
  final String? namaKelompok;
  final String? dibuatPada;
  final Pengeluaran? pengeluaran;

  const TambahPengeluaranPage({
    super.key,
    required this.isEdit,
    required this.anggotaList,
    this.namaKelompok,
    this.dibuatPada,
    this.pengeluaran,
  });

  @override
  State<TambahPengeluaranPage> createState() => _TambahPengeluaranPageState();
}

class _TambahPengeluaranPageState extends State<TambahPengeluaranPage> {
  // Untuk nama acara
  final TextEditingController _namaAcaraController = TextEditingController();

  Pengeluaran? pengeluaran;

  List<String>? anggotaList;

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

  @override
  void initState() {
    super.initState();

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
                // _simpanPengeluaran(),
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
}
