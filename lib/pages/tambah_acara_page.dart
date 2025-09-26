import 'package:flutter/material.dart';
import '../colors.dart';

class TambahAcaraPage extends StatefulWidget {
  const TambahAcaraPage({super.key});

  @override
  State<TambahAcaraPage> createState() => _TambahAcaraPageState();
}

class _TambahAcaraPageState extends State<TambahAcaraPage> {
  final TextEditingController _namaAcaraController = TextEditingController();
  List<TextEditingController> controllers = [TextEditingController()];

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addTextField() {
    setState(() {
      controllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.modalBackground,
      body: SafeArea(
        top: false,
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.modalBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(46),
                topRight: Radius.circular(46),
              ),
            ),
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Batal',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Tambah Acara',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            final nama = _namaAcaraController.text.trim();
                            if (nama.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Nama acara tidak boleh kosong',
                                  ),
                                ),
                              );
                              return;
                            }

                            final List<Map<String, dynamic>> anggota =
                                controllers
                                    .map(
                                      (ctrl) => {
                                        'anggota': {
                                          'namaLengkap': ctrl.text.trim(),
                                        },
                                      },
                                    )
                                    .where(
                                      (obj) =>
                                          (obj['anggota']?['namaLengkap'] ?? '')
                                              .toString()
                                              .isNotEmpty,
                                    )
                                    .toList();

                            if (anggota.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Minimal tambahkan 1 anggota'),
                                ),
                              );
                              return;
                            }

                            try {
                              // Panggil RemoteDataSource sesuai model
                              // final kelompok = await RemoteDataSource()
                              //     .createKelompok(
                              //       namaKelompok: nama,
                              //       anggota: anggota,
                              //     );
                              if (mounted) {
                                Navigator.pop(context, true);
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Gagal menyimpan: $e'),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Simpan',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // const Divider(height: 1, color: Colors.grey),

                // Konten form yang bisa discroll
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Nama Acara',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
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
                          child: TextField(
                            controller: _namaAcaraController,
                            decoration: const InputDecoration(
                              hintText: 'Masukan Nama Acara',
                              hintStyle: TextStyle(
                                color: AppColors.grey,
                                fontSize: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: AppColors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Dropdown Mata Uang
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Mata Uang',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
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
                              child: DropdownMenu<String>(
                                width: 160,
                                inputDecorationTheme: InputDecorationTheme(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.white,
                                ),
                                trailingIcon: const Icon(Icons.arrow_drop_down),
                                onSelected: (value) {
                                  // TODO: handle selection
                                },
                                initialSelection: 'rupiah',
                                menuStyle: MenuStyle(
                                  padding: const WidgetStatePropertyAll(
                                    EdgeInsets.zero,
                                  ),
                                  backgroundColor: const WidgetStatePropertyAll(
                                    AppColors.white,
                                  ),
                                  fixedSize: const WidgetStatePropertyAll(
                                    Size(160, double.infinity),
                                  ),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                dropdownMenuEntries: const [
                                  DropdownMenuEntry<String>(
                                    value: 'rupiah',
                                    label: 'IDR',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Anggota",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        for (int i = 0; i < controllers.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
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
                                      controller: controllers[i],
                                      decoration: InputDecoration(
                                        labelText: "Anggota ke-${i + 1}",
                                        labelStyle: const TextStyle(
                                          fontSize: 12,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: AppColors.primary,
                                    size: 42,
                                  ),
                                  onPressed: () {
                                    final ctrl = controllers.removeAt(i);
                                    ctrl.dispose();
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 16),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: AppColors.primary),
                          ),
                          onPressed: addTextField,
                          child: const Text(
                            "Tambah Anggota",
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
