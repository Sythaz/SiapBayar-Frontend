import 'package:flutter/material.dart';

import '../colors.dart';

class TambahAcaraPage extends StatefulWidget {
  const TambahAcaraPage({super.key});

  @override
  State<TambahAcaraPage> createState() => _TambahAcaraPageState();
}

class _TambahAcaraPageState extends State<TambahAcaraPage> {
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: IntrinsicHeight(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.95,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: const BoxDecoration(
            color: AppColors.modalBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(46),
              topRight: Radius.circular(46),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan tombol batal dan simpan
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 0,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                right: 15,
                                bottom: 10,
                              ),
                              child: const Text(
                                'Batal',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          'Tambah Acara',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              // TODO: Simpan
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 15,
                                bottom: 10,
                              ),
                              child: const Text(
                                'Simpan',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Field Nama Acara
              const Text(
                'Nama Acara',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      color: AppColors.grey.withAlpha((0.5 * 255).toInt()),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Masukan Nama Acara',
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
              const SizedBox(height: 20),
              // Dropdown Mata Uang
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mata Uang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          color: AppColors.grey.withAlpha((0.5 * 255).toInt()),
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
                        // TODO: implement onSelected
                      },
                      initialSelection: 'rupiah',
                      menuStyle: MenuStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        backgroundColor: WidgetStatePropertyAll(
                          AppColors.white,
                        ),
                        fixedSize: WidgetStatePropertyAll(
                          Size(160, double.infinity),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      dropdownMenuEntries: [
                        DropdownMenuEntry<String>(
                          value: 'rupiah',
                          label: 'IDR',
                          style: MenuItemButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Section Anggota
              const Text(
                "Anggota",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // Daftar TextField Anggota + Tombol Tambah
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < controllers.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
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
                                      labelStyle: const TextStyle(fontSize: 12),
                                      labelText: "Anggota ke-${i + 1}",
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
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: AppColors.primary,
                                  size: 42,
                                ),
                                onPressed: () {
                                  final controller = controllers.removeAt(i);
                                  controller.dispose();

                                  // Untuk memperbarui tampilan setelah dispose
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
                    ],
                  ),
                ),
              ),
              // Safe area
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
