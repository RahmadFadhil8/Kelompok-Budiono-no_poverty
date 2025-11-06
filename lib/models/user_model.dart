import 'package:no_poverty/models/verification_data_model.dart';

class UserModel {
    final String id;
    final String email;
    final String username;
    final String password;
    final String nama;
    final String nomorHp;
    final String lokasi;
    final String pekerjaan;
    final String salary;
    final bool isVerif;
    final VerifikasiData? verifikasi;

    UserModel({
        required this.id,
        required this.email,
        required this.nomorHp,
        required this.username,
        required this.password,
        required this.nama,
        required this.lokasi,
        required this.pekerjaan,
        required this.salary,
        this.isVerif = false,
        this.verifikasi,
    });


    factory UserModel.fromJson(Map<String, dynamic> json){ 
        return UserModel(
            id: json["id"]?.toString() ?? "",
            email: json["email"] ?? "",
            username: json["username"] ?? "",
            password: json["password"] ?? "",
            nama: json["nama"] ?? "",
            nomorHp: json["nomorHp"] ?? "",
            lokasi: json["lokasi"] ?? "",
            pekerjaan: json["pekerjaan"] ?? "",
            salary: json["salary"] ?? "",
            isVerif: json["isVerif"] ?? false,
            verifikasi: json["verifikasi"] != null ? VerifikasiData.fromJson(json["verifikasi"]) : null,
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "password": password,
        "nama": nama,
        "nomorHp": nomorHp,
        "lokasi": lokasi,
        "pekerjaan": pekerjaan,
        "salary": salary,
        "isVerif": isVerif,
        "verifikasi": verifikasi?.toJson(),
    };

}
