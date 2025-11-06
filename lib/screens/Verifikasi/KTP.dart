import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:no_poverty/models/verification_data_model.dart';
import 'package:no_poverty/screens/Verifikasi/SKCK.dart';
import 'package:no_poverty/screens/Verifikasi/widget/widget_UploadCard.dart';

class VerifikasiKTP extends StatefulWidget {
  final VerifikasiData verifikasiData;
  const VerifikasiKTP({super.key, required this.verifikasiData});

  @override
  State<VerifikasiKTP> createState() => _VerifikasiKTPState();
}

class _VerifikasiKTPState extends State<VerifikasiKTP> {
  late VerifikasiData data;
  double _progress = 0.25;
  final ImagePicker _picker = ImagePicker();

  @override
 void initState(){
  super.initState();
  data = widget.verifikasiData;
 }

  Future<void> _pickImage(bool isKTP) async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      setState(() {
        if (isKTP){
        data.ktpImage = File(pickedFile.path);
      } else {
        data.selfieImage = File(pickedFile.path);
      }
      });
    }
  }

  void _nextStep(){
    if (data.isKTPcomplete){
      Navigator.push(context, 
    MaterialPageRoute(
      builder: (context)=> VerifikasiSKCK(progress: _progress + 0.25, verifikasiData: widget.verifikasiData,)));
    }
    
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Verifikasi Akun", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Padding(padding: EdgeInsets.only(right: 12),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text("Step 1/4", style: TextStyle(color: Colors.blue, fontWeight:FontWeight.bold, fontSize: 12),),
            ),
          ),)
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: _progress,
              color: Colors.blue,
              backgroundColor: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              minHeight: 8,
            ),
            const SizedBox(height: 8,),
            Text("${(_progress * 100).toInt()}% Selesai",
            style: TextStyle(fontSize: 12, color: Colors.grey),),

            SizedBox(height: 25,),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.blue, size: 30,),
                  ),
                  const SizedBox(height: 8,),
                  Text("KTP & Identitas",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 4,),
                  Text("Upload KTP dan foto selfie",
                  style: TextStyle(fontSize: 13, color: Colors.grey),),
                  const SizedBox(height: 16,),

                  UploadCard(
                    title: "Upload KTP", 
                    file: data.ktpImage,
                    onTap: (){_pickImage(true);}, 
                    successText: "KTP berhasil diupload",
                    iconData: Icons.file_upload_outlined,
                    hintText: "Pilih foto KTP",),
                  const SizedBox(height: 16,),

                  UploadCard(
                    title: "Foto Selfie dengan KTP", 
                    file: data.selfieImage,
                    onTap: (){_pickImage(false);}, 
                    successText: "Selfie berhasil diupload",
                    iconData: Icons.camera_alt_outlined,
                    hintText: "Ambil foto selfie",),
                    
                  const SizedBox(height: 16,),

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.yellow[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border(left: BorderSide(color: Colors.orange, width: 4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: Colors.orangeAccent,),
                        SizedBox(width: 5,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Tips Foto yang Baik", style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("• Pastikan foto jelas dan tidak blur",style: TextStyle(fontSize: 12 )),
                            Text("• KTP terlihat jelas di foto selfie",style: TextStyle(fontSize: 12 )),
                            Text("• Wajah tidak tertutup masker/kacamata",style: TextStyle(fontSize: 12 )),
                          ],)
                    ],)
                  ),

                ],
              ),),
            ),
            const SizedBox(height: 16,),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (data.isKTPcomplete)? Colors.blue : Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Lanjut", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)),
                  ),
          ],
        ),
      ),
    );
  }
}