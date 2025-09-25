class Anggota {
  int? id;
  String? namaLengkap;
  String? dibuatPada;

  Anggota({this.id, this.namaLengkap, this.dibuatPada});

  Anggota.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaLengkap = json['namaLengkap'];
    dibuatPada = json['dibuatPada'];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'namaLengkap': namaLengkap, 'dibuatPada': dibuatPada};
  }
}

class AnggotaRelasi {
  int? kelompokId;
  int? anggotaId;
  String? bergabungPada;
  Anggota? anggota;

  AnggotaRelasi({
    this.kelompokId,
    this.anggotaId,
    this.bergabungPada,
    this.anggota,
  });

  AnggotaRelasi.fromJson(Map<String, dynamic> json) {
    kelompokId = json['kelompokId'];
    anggotaId = json['anggotaId'];
    bergabungPada = json['bergabungPada'];
    anggota = json['anggota'] != null
        ? Anggota.fromJson(json['anggota'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'kelompokId': kelompokId,
      'anggotaId': anggotaId,
      'bergabungPada': bergabungPada,
      'anggota': anggota?.toJson(),
    };
  }
}

class Kelompok {
  int? id;
  String? namaKelompok;
  String? deskripsi;
  String? dibuatPada;
  List<AnggotaRelasi>? anggota;
  List<Pengeluaran>? pengeluaran;

  Kelompok({
    this.id,
    this.namaKelompok,
    this.deskripsi,
    this.dibuatPada,
    this.anggota,
    this.pengeluaran,
  });

  Kelompok.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaKelompok = json['namaKelompok'];
    deskripsi = json['deskripsi'];
    dibuatPada = json['dibuatPada'];
    if (json['anggota'] != null) {
      anggota = (json['anggota'] as List)
          .map((v) => AnggotaRelasi.fromJson(v))
          .toList();
    }
    if (json['pengeluaran'] != null) {
      pengeluaran = (json['pengeluaran'] as List)
          .map((v) => Pengeluaran.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'namaKelompok': namaKelompok,
      'deskripsi': deskripsi,
      'dibuatPada': dibuatPada,
      'anggota': anggota?.map((v) => v.toJson()).toList(),
      'pengeluaran': pengeluaran?.map((v) => v.toJson()).toList(),
    };
  }
}

class Pengeluaran {
  int? id;
  String? deskripsi;
  String? jumlahTotal;
  String? tanggalPengeluaran;
  String? dibuatPada;
  int? kelompokId;
  List<Pembayaran>? pembayaran;
  List<JatahUrunan>? jatahUrunan;

  Pengeluaran({
    this.id,
    this.deskripsi,
    this.jumlahTotal,
    this.tanggalPengeluaran,
    this.dibuatPada,
    this.kelompokId,
    this.pembayaran,
    this.jatahUrunan,
  });

  Pengeluaran.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deskripsi = json['deskripsi'];
    jumlahTotal = json['jumlahTotal'];
    tanggalPengeluaran = json['tanggalPengeluaran'];
    dibuatPada = json['dibuatPada'];
    kelompokId = json['kelompokId'];
    if (json['pembayaran'] != null) {
      pembayaran = (json['pembayaran'] as List)
          .map((e) => Pembayaran.fromJson(e))
          .toList();
    }
    if (json['jatahUrunan'] != null) {
      jatahUrunan = (json['jatahUrunan'] as List)
          .map((e) => JatahUrunan.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deskripsi': deskripsi,
      'jumlahTotal': jumlahTotal,
      'tanggalPengeluaran': tanggalPengeluaran,
      'dibuatPada': dibuatPada,
      'kelompokId': kelompokId,
      'pembayaran': pembayaran?.map((e) => e.toJson()).toList(),
      'jatahUrunan': jatahUrunan?.map((e) => e.toJson()).toList(),
    };
  }
}

// aaaa
class Pembayaran {
  int? pengeluaranId;
  int? anggotaId;
  String? jumlahBayar;
  Anggota? anggota;

  Pembayaran({
    this.pengeluaranId,
    this.anggotaId,
    this.jumlahBayar,
    this.anggota,
  });

  Pembayaran.fromJson(Map<String, dynamic> json) {
    pengeluaranId = json['pengeluaranId'];
    anggotaId = json['anggotaId'];
    jumlahBayar = json['jumlahBayar'];
    anggota = json['anggota'] != null
        ? Anggota.fromJson(json['anggota'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'pengeluaranId': pengeluaranId,
      'anggotaId': anggotaId,
      'jumlahBayar': jumlahBayar,
      'anggota': anggota?.toJson(),
    };
  }
}
// aaaaaaa
class JatahUrunan {
  int? id;
  String? jumlahJatah;
  bool? sudahLunas;
  int? pengeluaranId;
  int? penanggungId;
  Anggota? penanggung;

  JatahUrunan({
    this.id,
    this.jumlahJatah,
    this.sudahLunas,
    this.pengeluaranId,
    this.penanggungId,
    this.penanggung,
  });

  JatahUrunan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jumlahJatah = json['jumlahJatah'];
    sudahLunas = json['sudahLunas'];
    pengeluaranId = json['pengeluaranId'];
    penanggungId = json['penanggungId'];
    penanggung = json['penanggung'] != null
        ? Anggota.fromJson(json['penanggung'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jumlahJatah': jumlahJatah,
      'sudahLunas': sudahLunas,
      'pengeluaranId': pengeluaranId,
      'penanggungId': penanggungId,
      'penanggung': penanggung?.toJson(),
    };
  }
}
