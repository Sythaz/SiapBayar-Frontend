import 'package:flutter/material.dart';
import 'package:siapbayar/colors.dart';
import 'package:siapbayar/pages/searchPage.dart';
import 'package:siapbayar/pages/tambah_pengeluaran_page.dart';
import 'package:siapbayar/pages/tambah_acara_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _showContent = false;
  bool _showFloatingButtons = false;
  late ScrollController _scrollController;

  List<Map<String, dynamic>> _acaraList = [
    {'nama': 'Pantai Jogja', 'orang': 4, 'pengeluaran': 1},
    // {'nama': 'Makan Malam', 'orang': 3, 'pengeluaran': 5},
    // {'nama': 'Konser Musik', 'orang': 2, 'pengeluaran': 7},
    // {'nama': 'Meeting Kantor', 'orang': 6, 'pengeluaran': 3},
    // {'nama': 'Liburan Keluarga', 'orang': 5, 'pengeluaran': 10},
    // {'nama': 'Liburan Keluarga', 'orang': 5, 'pengeluaran': 10},
    // {'nama': 'Liburan Keluarga', 'orang': 5, 'pengeluaran': 10},
  ];

  void _navigateToTambahAcara() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const TambahAcaraPage()),
    // );

    // Karena TambahAcaraPage berupa modal sehingga perlu showModalBottomSheet
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      barrierColor: Colors.transparent,
      isDismissible: false,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.96,
          child: TambahAcaraPage(),
        );
      },
    );
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(acaraList: _acaraList),
      ),
    );
  }

  void _navigateToTambahPengeluaran(Map<String, dynamic> acara) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TambahPengeluaranPage()),
    );
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showContent = true;
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.offset > 150) {
      if (!_showFloatingButtons) {
        setState(() {
          _showFloatingButtons = true;
        });
      }
    } else {
      if (_showFloatingButtons) {
        setState(() {
          _showFloatingButtons = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Hero(
            tag: 'background-primary',
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'teksSiapBayar',
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: const Text(
                          'SiapBayar!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: _showContent ? 1.0 : 0.0,
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          // Search bar
                          Material(
                            elevation: 5,
                            shadowColor: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppColors.grey,
                                  width: 1.2,
                                ),
                              ),
                              child: TextField(
                                readOnly: true,
                                onTap: _navigateToSearch,
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.grey,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 30,
                                    color: AppColors.grey,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Judul daftar acara + tombol tambah acara
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Daftar Acara",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: _navigateToTambahAcara,
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // List acara
                          ..._acaraList.map((acara) {
                            return Column(
                              children: [
                                Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      _navigateToTambahPengeluaran(acara);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            acara['nama'],
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Jumlah Orang: ${acara['orang']}",
                                            style: const TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            "Jumlah Pengeluaran: ${acara['pengeluaran']}",
                                            style: const TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primary,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text(
                                                "Total Pengeluaran",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          }).toList(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 20,
            bottom: 20,
            child: AnimatedSlide(
              offset: _showFloatingButtons ? Offset(0, 0) : Offset(0, 1),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: _showFloatingButtons ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: Material(
                  elevation: 6,
                  shadowColor: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: _navigateToSearch,
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.grey, width: 1.2),
                      ),
                      child: Icon(
                        Icons.search,
                        size: 30,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: AnimatedSlide(
              offset: _showFloatingButtons ? Offset(0, 0) : Offset(0, 1),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: _showFloatingButtons ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: _navigateToTambahAcara,
                  child: Container(
                    height: 56,
                    width: 56,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
