import 'package:http/http.dart' as http;
import 'package:no_poverty/models/verifikasi_data_model.dart';

class VerifikasiService {
  Future<bool> uploadDocuments(VerifikasiData data) async {
    try{
      var uri = Uri.parse('http://10.0.2.2:5000/users/verification');
      var request = http.MultipartRequest('POST', uri);

      request.fields['userId'] = data.user.id.toString();

      if (data.ktpImage != null) {
        request.files.add(await http.MultipartFile.fromPath('ktpFile', data.ktpImage!.path));
      }

      if (data.selfieImage != null) {
        request.files.add(await http.MultipartFile.fromPath('selfieFile', data.selfieImage!.path));
      }

      if (data.skckFile != null) {
        request.files.add(await http.MultipartFile.fromPath('skckFile', data.skckFile!.path));
      }

      if (data.stnkFile != null) {
        request.files.add(await http.MultipartFile.fromPath('stnkFile', data.stnkFile!.path));
      }

      
      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Upload failed : ${response.statusCode}");
        return false;
      }
      

     } catch (e) {
      print(e);
      return false;
     }
  }
}