import 'package:flutter/material.dart';

import '../colors.dart';

enum HasilCategory { hutang, pembagian }

class HasilPerhitunganPage extends StatefulWidget {
  const HasilPerhitunganPage({super.key});

  @override
  State<HasilPerhitunganPage> createState() => _HasilPerhitunganPageState();
}

class _HasilPerhitunganPageState extends State<HasilPerhitunganPage> {
  HasilCategory _currentHasilCategory = HasilCategory.hutang;

  final List<Map<String, String>> hutangList = [
    {"nama": "Orang 1", "jumlah": "Rp. 10.000"},
    {"nama": "Orang 2", "jumlah": "Rp. 20.000"},
    {"nama": "Orang 3", "jumlah": "Rp. 15.000"},
    {"nama": "Orang 4", "jumlah": "Rp. 30.000"},
  ];

  final List<Map<String, String>> pembagianList = [
    {"nama": "Orang 1", "jumlah": "Rp. 0"},
    {"nama": "Orang 2", "jumlah": "Rp. 0"},
    {"nama": "Orang 3", "jumlah": "Rp. 0"},
    {"nama": "Orang 4", "jumlah": "Rp. 90.000"},
  ];

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
        title: const Text(
          'Hasil Perhitungan',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Pengeluaran:',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Rp. 90.000',
              style: TextStyle(
                fontSize: 24,
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _currentHasilCategory = HasilCategory.hutang;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _currentHasilCategory == HasilCategory.hutang
                                ? AppColors.primary
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Hutang',
                              style: TextStyle(
                                color:
                                    _currentHasilCategory ==
                                        HasilCategory.hutang
                                    ? AppColors.white
                                    : AppColors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _currentHasilCategory = HasilCategory.pembagian;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                _currentHasilCategory == HasilCategory.pembagian
                                ? AppColors.primary
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Pembagian',
                              style: TextStyle(
                                color:
                                    _currentHasilCategory ==
                                        HasilCategory.pembagian
                                    ? AppColors.white
                                    : AppColors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            _currentHasilCategory == HasilCategory.hutang
                ? Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '- Berhutang -',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...hutangList.map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item["nama"]!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    Text(
                                      item["jumlah"]!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '- Berhutang -',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...pembagianList.map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item["nama"]!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    Text(
                                      item["jumlah"]!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
