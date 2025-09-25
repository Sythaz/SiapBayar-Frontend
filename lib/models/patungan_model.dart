class PatunganModel {
  int? id;
  String? namaKelompok;
  String? deskripsi;
  List<Anggota>? anggota;
  List<Pengeluaran>? pengeluaran;

  PatunganModel({
    this.id,
    this.namaKelompok,
    this.deskripsi,
    this.anggota,
    this.pengeluaran,
  });

  PatunganModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaKelompok = json['namaKelompok'];
    deskripsi = json['deskripsi'];
    if (json['anggota'] != null) {
      anggota = <Anggota>[];
      json['anggota'].forEach((v) {
        anggota!.add(Anggota.fromJson(v));
      });
    }
    if (json['pengeluaran'] != null) {
      pengeluaran = <Pengeluaran>[];
      json['pengeluaran'].forEach((v) {
        pengeluaran!.add(Pengeluaran.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['namaKelompok'] = namaKelompok;
    data['deskripsi'] = deskripsi;
    if (anggota != null) {
      data['anggota'] = anggota!.map((v) => v.toJson()).toList();
    }
    if (pengeluaran != null) {
      data['pengeluaran'] = pengeluaran!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Anggota {
  Anggota? anggota;

  Anggota({this.anggota});

  Anggota.fromJson(Map<String, dynamic> json) {
    anggota = json['anggota'] != null
        ? Anggota.fromJson(json['anggota'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (anggota != null) {
      data['anggota'] = anggota!.toJson();
    }
    return data;
  }
}

class NamaAnggota {
  String? namaLengkap;

  NamaAnggota({this.namaLengkap});

  NamaAnggota.fromJson(Map<String, dynamic> json) {
    namaLengkap = json['namaLengkap'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['namaLengkap'] = namaLengkap;
    return data;
  }
}

class Pengeluaran {
  int? id;
  String? deskripsi;
  String? jumlahTotal;
  List<Pembayaran>? pembayaran;
  List<JatahUrunan>? jatahUrunan;

  Pengeluaran({
    this.id,
    this.deskripsi,
    this.jumlahTotal,
    this.pembayaran,
    this.jatahUrunan,
  });

  Pengeluaran.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deskripsi = json['deskripsi'];
    jumlahTotal = json['jumlahTotal'];
    if (json['pembayaran'] != null) {
      pembayaran = <Pembayaran>[];
      json['pembayaran'].forEach((v) {
        pembayaran!.add(Pembayaran.fromJson(v));
      });
    }
    if (json['jatahUrunan'] != null) {
      jatahUrunan = <JatahUrunan>[];
      json['jatahUrunan'].forEach((v) {
        jatahUrunan!.add(JatahUrunan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['deskripsi'] = deskripsi;
    data['jumlahTotal'] = jumlahTotal;
    if (pembayaran != null) {
      data['pembayaran'] = pembayaran!.map((v) => v.toJson()).toList();
    }
    if (jatahUrunan != null) {
      data['jatahUrunan'] = jatahUrunan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pembayaran {
  String? jumlahBayar;
  Anggota? anggota;

  Pembayaran({this.jumlahBayar, this.anggota});

  Pembayaran.fromJson(Map<String, dynamic> json) {
    jumlahBayar = json['jumlahBayar'];
    anggota = json['anggota'] != null
        ? Anggota.fromJson(json['anggota'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jumlahBayar'] = jumlahBayar;
    if (anggota != null) {
      data['anggota'] = anggota!.toJson();
    }
    return data;
  }
}

class JatahUrunan {
  String? jumlahJatah;
  Anggota? penanggung;

  JatahUrunan({this.jumlahJatah, this.penanggung});

  JatahUrunan.fromJson(Map<String, dynamic> json) {
    jumlahJatah = json['jumlahJatah'];
    penanggung = json['penanggung'] != null
        ? Anggota.fromJson(json['penanggung'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jumlahJatah'] = jumlahJatah;
    if (penanggung != null) {
      data['penanggung'] = penanggung!.toJson();
    }
    return data;
  }
}
