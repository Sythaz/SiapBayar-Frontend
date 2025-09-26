import 'package:flutter/material.dart';
import 'package:siapbayar/colors.dart';

class SearchPage extends StatefulWidget {
  final List<Map<String, dynamic>> acaraList;

  const SearchPage({super.key, required this.acaraList});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredAcara = [];
  bool _hasTyped = false;

  @override
  void initState() {
    super.initState();
    _filteredAcara = [];

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase().replaceAll(' ', '');

      setState(() {
        _hasTyped = query.isNotEmpty;
        if (_hasTyped) {
          _filteredAcara = widget.acaraList.where((acara) {
            final nama = (acara['namaKelompok'] ?? '').toLowerCase().replaceAll(
              ' ',
              '',
            );
            return nama.contains(query);
          }).toList();
        } else {
          _filteredAcara = [];
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: 'background-primary',
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              color: AppColors.primary,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'teksSiapBayar',
                    child: Material(
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          'SiapBayar!',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Search box
                  Material(
                    elevation: 5,
                    shadowColor: AppColors.black.withAlpha((0.2 * 255).toInt()),
                    borderRadius: BorderRadius.circular(30),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Cari",
                        hintStyle: TextStyle(color: AppColors.grey),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.grey,
                          size: 28,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: !_hasTyped
                        ? const SizedBox()
                        : _filteredAcara.isEmpty
                        ? const Center(
                            child: Text(
                              'Acara Tidak Ditemukan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredAcara.length,
                            itemBuilder: (context, index) {
                              final acara = _filteredAcara[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                                child: ListTile(
                                  title: Text(
                                    acara['namaKelompok'] ?? 'Tidak ditemukan',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Orang: ${(acara['anggota'] as List).length}, Pengeluaran: ${(acara['pengeluaran'] as List).length}',
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 20,
            bottom: 20,
            child: Material(
              color: Colors.white.withAlpha((0.9 * 255).toInt()),
              shape: const CircleBorder(),
              elevation: 5,
              child: IconButton(
                icon: const Icon(
                  Icons.home,
                  color: AppColors.primary,
                  size: 40,
                ),
                iconSize: 30,
                onPressed: _goHome,
                tooltip: 'Home',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
