class UserModel {
    final String id;
    final String email;
    final String username;
    final String password;
    final String nama;
    final String nomorHp;
    final String fotoKTP;
    final String lokasi;
    final String pekerjaan;
    final String salary;

    UserModel({
        required this.id,
        required this.email,
        required this.nomorHp,
        required this.username,
        required this.password,
        required this.nama,
        required this.fotoKTP,
        required this.lokasi,
        required this.pekerjaan,
        required this.salary
    });


    factory UserModel.fromJson(Map<String, dynamic> json){ 
        return UserModel(
            id: json["_id"]?.toString() ?? "",
            email: json["email"] ?? "",
            username: json["username"] ?? "",
            password: json["password"] ?? "",
            nama: json["nama"] ?? "",
            nomorHp: json["nomorHp"] ?? "",
            fotoKTP: json["fotoKTP"] ?? "",
            lokasi: json["lokasi"] ?? "",
            pekerjaan: json["pekerjaan"] ?? "",
            salary: json["salary"] ?? ""
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "password": password,
        "nama": nama,
        "nomorHp": nomorHp,
        "fotoKTP": fotoKTP,
        "lokasi": lokasi,
        "pekerjaan": pekerjaan,
        "salary": salary,
    };

}
