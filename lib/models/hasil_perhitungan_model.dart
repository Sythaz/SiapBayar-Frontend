import 'dart:convert';

class HasilPerhitunganModel {
  final int? totalPengumpulan;
  final List<Berhutang>? berhutang;
  final List<Pembagian>? pembagian;

  HasilPerhitunganModel({
    this.totalPengumpulan,
    this.berhutang,
    this.pembagian,
  });

  factory HasilPerhitunganModel.fromJson(String str) =>
      HasilPerhitunganModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HasilPerhitunganModel.fromMap(Map<String, dynamic> json) =>
      HasilPerhitunganModel(
        totalPengumpulan: json["totalPengumpulan"],
        berhutang: json["berhutang"] == null
            ? []
            : List<Berhutang>.from(
                json["berhutang"]!.map((x) => Berhutang.fromMap(x)),
              ),
        pembagian: json["pembagian"] == null
            ? []
            : List<Pembagian>.from(
                json["pembagian"]!.map((x) => Pembagian.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "totalPengumpulan": totalPengumpulan,
    "berhutang": berhutang == null
        ? []
        : List<dynamic>.from(berhutang!.map((x) => x.toMap())),
    "pembagian": pembagian == null
        ? []
        : List<dynamic>.from(pembagian!.map((x) => x.toMap())),
  };
}

class Berhutang {
  final String? nama;
  final int? hutang;
  final String? bayarKe;

  Berhutang({this.nama, this.hutang, this.bayarKe});

  factory Berhutang.fromJson(String str) => Berhutang.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Berhutang.fromMap(Map<String, dynamic> json) => Berhutang(
    nama: json["nama"],
    hutang: json["hutang"],
    bayarKe: json["bayarKe"],
  );

  Map<String, dynamic> toMap() => {
    "nama": nama,
    "hutang": hutang,
    "bayarKe": bayarKe,
  };
}

class Pembagian {
  final String? nama;
  final int? kelebihan;

  Pembagian({this.nama, this.kelebihan});

  factory Pembagian.fromJson(String str) => Pembagian.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pembagian.fromMap(Map<String, dynamic> json) =>
      Pembagian(nama: json["nama"], kelebihan: json["kelebihan"]);

  Map<String, dynamic> toMap() => {"nama": nama, "kelebihan": kelebihan};
}
