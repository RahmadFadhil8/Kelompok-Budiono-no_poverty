import 'dart:io';
import 'package:no_poverty/models/user_model.dart';

class VerifikasiData {
  File? ktpImage;
  File? selfieImage;
  File? skckFile;
  File? stnkFile;
  final UserModel user;

  VerifikasiData({
    required this.user,
    this.ktpImage,
    this.selfieImage,
    this.skckFile,
    this.stnkFile,
  });

  bool get isKTPcomplete {
    return ktpImage != null && selfieImage != null;
  }
  bool get isSKCKcomplete {
    return skckFile != null;
  }
  bool get isSTNKcomplete {
    return stnkFile != null;
  }
  bool get isReadyTosubmit {
    return isKTPcomplete && isSKCKcomplete;
  }
}
