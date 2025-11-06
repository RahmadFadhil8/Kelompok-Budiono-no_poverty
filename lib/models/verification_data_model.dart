import 'dart:io';

class VerifikasiData {
  final int? userId;
  File? ktpImage;
  File? selfieImage;
  File? skckImage;
  File? stnkImage;
  final DateTime? createdAt;

  VerifikasiData({
    this.userId,
    this.ktpImage,
    this.selfieImage,
    this.skckImage,
    this.stnkImage,
    this.createdAt,
  });

  bool get isKTPcomplete {
    return ktpImage != null && selfieImage != null;
  }
  bool get isSKCKcomplete {
    return skckImage != null;
  }
  bool get isSTNKcomplete {
    return stnkImage != null ;
  }

  factory VerifikasiData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return VerifikasiData();
    return VerifikasiData(
      userId: json["userId"],
      ktpImage: json["ktpFile"],
      selfieImage: json["selfieFile"],
      skckImage: json["skckFile"],
      stnkImage: json["stnkFile"],
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "ktpFile": ktpImage,
        "selfieFile": selfieImage,
        "skckFile": skckImage,
        "stnkFile": stnkImage,
        "createdAt": createdAt?.toIso8601String(),
      };
}
