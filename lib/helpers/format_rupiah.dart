// Helper format rupiah
String formatRupiah(String nominal) {
  if (nominal.isEmpty) return '-';
  final angka = int.tryParse(nominal.replaceAll('.', '')) ?? 0;
  return angka.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
}
