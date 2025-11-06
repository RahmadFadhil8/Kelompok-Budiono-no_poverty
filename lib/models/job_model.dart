class JobModel {
  final String id;
  final UserId userId;
  final String judulPekerjaan;
  final String kategori;
  final String deskripsi;
  final String alamat;
  final String tanggal;
  final String waktu;
  final int jumlahHelper;
  final String budget;
  final bool izinkanTawarMenawar;

  JobModel({
    required this.id,
    required this.userId,
    required this.judulPekerjaan,
    required this.kategori,
    required this.deskripsi,
    required this.alamat,
    required this.tanggal,
    required this.waktu,
    required this.jumlahHelper,
    required this.budget,
    required this.izinkanTawarMenawar
  });


  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json["_id"]?.toString() ?? "",
      userId: json["userId"] != null ? UserId.fromJson(json["userId"]) : UserId(id: "", email: "", username: "", nama: ""),
      judulPekerjaan: json["judulPekerjaan"] ?? "",
      kategori: json["kategori"] ?? "",
      deskripsi: json["deskripsi"] ?? "",
      alamat: json["alamat"] ?? "",
      tanggal: json["tanggal"] ?? "",
      waktu: json["waktu"]??"",
      jumlahHelper: json["jumlahHelper"] is int
          ? json["jumlahHelper"] : int.tryParse(json["jumlahHelper"].toString()) ?? 0,
      budget: json["budget"] ?? "",
      izinkanTawarMenawar:
          json["izinkanTawarMenawar"] is int ? json["izinkanTawarMenawar"] == 1 : json["izinkanTawarMenawar"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "judulPekerjaan": judulPekerjaan,
        "kategori": kategori,
        "deskripsi": deskripsi,
        "alamat": alamat,
        "tanggal": tanggal,
        "waktu": waktu,
        "jumlahHelper": jumlahHelper,
        "budget": budget,
        "izinkanTawarMenawar": izinkanTawarMenawar ? 1 : 0,
      };
}

class UserId {
  String id;
  String email;
  String username;
  String nama;

  UserId({
    required this.id,
    required this.email,
    required this.username,
    required this.nama,
  });

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      id: json["_id"]?.toString() ?? "",
      email: json["email"] ?? "", 
      username: json["username"] ?? "", 
      nama: json["nama"] ?? ""
    );
  } 

  Map<String, dynamic> toJson() => {
    "id": id,
    "email" : email,
    "username" : username,
    "nama": nama 
  };
}
