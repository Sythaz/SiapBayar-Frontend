import 'dart:convert';

class PatunganModel {
    final int? id;
    final String? namaKelompok;
    final String? deskripsi;
    final DateTime? dibuatPada;
    final List<AnggotaElement>? anggota;
    final List<Pengeluaran>? pengeluaran;

    PatunganModel({
        this.id,
        this.namaKelompok,
        this.deskripsi,
        this.dibuatPada,
        this.anggota,
        this.pengeluaran,
    });

    factory PatunganModel.fromJson(String str) => PatunganModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PatunganModel.fromMap(Map<String, dynamic> json) => PatunganModel(
        id: json["id"],
        namaKelompok: json["namaKelompok"],
        deskripsi: json["deskripsi"],
        dibuatPada: json["dibuatPada"] == null ? null : DateTime.parse(json["dibuatPada"]),
        anggota: json["anggota"] == null ? [] : List<AnggotaElement>.from(json["anggota"]!.map((x) => AnggotaElement.fromMap(x))),
        pengeluaran: json["pengeluaran"] == null ? [] : List<Pengeluaran>.from(json["pengeluaran"]!.map((x) => Pengeluaran.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "namaKelompok": namaKelompok,
        "deskripsi": deskripsi,
        "dibuatPada": dibuatPada?.toIso8601String(),
        "anggota": anggota == null ? [] : List<dynamic>.from(anggota!.map((x) => x.toMap())),
        "pengeluaran": pengeluaran == null ? [] : List<dynamic>.from(pengeluaran!.map((x) => x.toMap())),
    };
}

class AnggotaElement {
    final PenanggungClass? anggota;

    AnggotaElement({
        this.anggota,
    });

    factory AnggotaElement.fromJson(String str) => AnggotaElement.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AnggotaElement.fromMap(Map<String, dynamic> json) => AnggotaElement(
        anggota: json["anggota"] == null ? null : PenanggungClass.fromMap(json["anggota"]),
    );

    Map<String, dynamic> toMap() => {
        "anggota": anggota?.toMap(),
    };
}

class PenanggungClass {
    final String? namaLengkap;
    final DateTime? dibuatPada;

    PenanggungClass({
        this.namaLengkap,
        this.dibuatPada,
    });

    factory PenanggungClass.fromJson(String str) => PenanggungClass.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PenanggungClass.fromMap(Map<String, dynamic> json) => PenanggungClass(
        namaLengkap: json["namaLengkap"],
        dibuatPada: json["dibuatPada"] == null ? null : DateTime.parse(json["dibuatPada"]),
    );

    Map<String, dynamic> toMap() => {
        "namaLengkap": namaLengkap,
        "dibuatPada": dibuatPada?.toIso8601String(),
    };
}

class Pengeluaran {
    final int? id;
    final String? deskripsi;
    final String? jumlahTotal;
    final DateTime? dibuatPada;
    final List<Pembayaran>? pembayaran;
    final List<JatahUrunan>? jatahUrunan;

    Pengeluaran({
        this.id,
        this.deskripsi,
        this.jumlahTotal,
        this.dibuatPada,
        this.pembayaran,
        this.jatahUrunan,
    });

    factory Pengeluaran.fromJson(String str) => Pengeluaran.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Pengeluaran.fromMap(Map<String, dynamic> json) => Pengeluaran(
        id: json["id"],
        deskripsi: json["deskripsi"],
        jumlahTotal: json["jumlahTotal"],
        dibuatPada: json["dibuatPada"] == null ? null : DateTime.parse(json["dibuatPada"]),
        pembayaran: json["pembayaran"] == null ? [] : List<Pembayaran>.from(json["pembayaran"]!.map((x) => Pembayaran.fromMap(x))),
        jatahUrunan: json["jatahUrunan"] == null ? [] : List<JatahUrunan>.from(json["jatahUrunan"]!.map((x) => JatahUrunan.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "deskripsi": deskripsi,
        "jumlahTotal": jumlahTotal,
        "dibuatPada": dibuatPada?.toIso8601String(),
        "pembayaran": pembayaran == null ? [] : List<dynamic>.from(pembayaran!.map((x) => x.toMap())),
        "jatahUrunan": jatahUrunan == null ? [] : List<dynamic>.from(jatahUrunan!.map((x) => x.toMap())),
    };
}

class JatahUrunan {
    final String? jumlahJatah;
    final PenanggungClass? penanggung;

    JatahUrunan({
        this.jumlahJatah,
        this.penanggung,
    });

    factory JatahUrunan.fromJson(String str) => JatahUrunan.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory JatahUrunan.fromMap(Map<String, dynamic> json) => JatahUrunan(
        jumlahJatah: json["jumlahJatah"],
        penanggung: json["penanggung"] == null ? null : PenanggungClass.fromMap(json["penanggung"]),
    );

    Map<String, dynamic> toMap() => {
        "jumlahJatah": jumlahJatah,
        "penanggung": penanggung?.toMap(),
    };
}

class Pembayaran {
    final String? jumlahBayar;
    final PenanggungClass? anggota;

    Pembayaran({
        this.jumlahBayar,
        this.anggota,
    });

    factory Pembayaran.fromJson(String str) => Pembayaran.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Pembayaran.fromMap(Map<String, dynamic> json) => Pembayaran(
        jumlahBayar: json["jumlahBayar"],
        anggota: json["anggota"] == null ? null : PenanggungClass.fromMap(json["anggota"]),
    );

    Map<String, dynamic> toMap() => {
        "jumlahBayar": jumlahBayar,
        "anggota": anggota?.toMap(),
    };
}
