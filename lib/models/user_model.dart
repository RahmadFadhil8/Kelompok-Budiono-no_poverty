class UserModel {
    UserModel({
        required this.id,
        required this.email,
        required this.nomorHp,
        required this.username,
        required this.password,
    });

    final int id;
    final String email;
    final String nomorHp;
    final String username;
    final String password;

    factory UserModel.fromJson(Map<String, dynamic> json){ 
        return UserModel(
            id: json["id"] ?? 0,
            email: json["email"] ?? "",
            nomorHp: json["nomorHp"] ?? "",
            username: json["username"] ?? "",
            password: json["password"] ?? "",
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "nomorHp": nomorHp,
        "username": username,
        "password": password,
    };

}
