import 'package:http/http.dart' as http;
import 'package:no_poverty/models/verification_data_model.dart';

class VerifikasiService {
  final String baseUrl = 'http://localhost:5000';

  Future<bool> uploadDocuments(VerifikasiData data) async {
    try{
      var uri = Uri.parse('$baseUrl/users/verification');
      var request = http.MultipartRequest('POST', uri);

      request.fields['userId'] = data.userId.toString();

      if (data.ktpImage != null) {
        request.files.add(await http.MultipartFile.fromPath('ktpFile', data.ktpImage!.path));
      }

      if (data.selfieImage != null) {
        request.files.add(await http.MultipartFile.fromPath('selfieFile', data.selfieImage!.path));
      }

      if (data.skckImage != null) {
        request.files.add(await http.MultipartFile.fromPath('skckFile', data.skckImage!.path));
      }

      if (data.stnkImage != null) {
        request.files.add(await http.MultipartFile.fromPath('stnkFile', data.stnkImage!.path));
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