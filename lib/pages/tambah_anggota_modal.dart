import 'package:flutter/material.dart';

import '../colors.dart';
import '../datasources/remote_datasource.dart';

class TambahAnggotaModal extends StatefulWidget {
  final int acaraId;
  const TambahAnggotaModal({super.key, required this.acaraId});

  @override
  State<TambahAnggotaModal> createState() => _TambahAnggotaModalState();
}

class _TambahAnggotaModalState extends State<TambahAnggotaModal> {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final TextEditingController _namaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.modalBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const Text(
            "Tambah Anggota Baru",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _namaController,
            decoration: InputDecoration(
              labelText: "Nama Anggota",
              hintText: "Masukkan nama anggota",
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Simpan', style: TextStyle(color: AppColors.white)),
              onPressed: () async {
                if (_namaController.text.isEmpty) {
                  return;
                }

                String result = await _remoteDataSource.createAnggota(
                  nama: _namaController.text,
                  kelompokId: widget.acaraId,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Anggota "$result" berhasil ditambahkan.'),
                  ),
                );

                Navigator.pop(context, true);
              },
            ),
          ),
        ],
      ),
    );
  }
}
