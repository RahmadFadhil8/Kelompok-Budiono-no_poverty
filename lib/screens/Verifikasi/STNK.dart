import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:no_poverty/models/verifikasi_data_model.dart';
import 'package:no_poverty/screens/Verifikasi/Review.dart';
import 'package:no_poverty/screens/Verifikasi/widget/widget_UploadCard.dart';

class VerifikasiSTNK extends StatefulWidget {
  final double progress;
  final VerifikasiData verifikasiData;
  const VerifikasiSTNK({super.key, required this.progress, required this.verifikasiData});

  @override
  State<VerifikasiSTNK> createState() => _VerifikasiSTNKState();
}

class _VerifikasiSTNKState extends State<VerifikasiSTNK> {
  late double _progress;
  late VerifikasiData data;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState(){
      super.initState();
      _progress = widget.progress;
      data = widget.verifikasiData;
  }

  Future<void> _pickImage() async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      setState(() {
        widget.verifikasiData.stnkFile = File(pickedFile.path);
      });
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
              child: Text("Step 3/4", style: TextStyle(color: Colors.blue, fontWeight:FontWeight.bold, fontSize: 12),),
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
                    child: Icon(Icons.shield_outlined, color: Colors.blue, size: 30,),
                  ),
                  const SizedBox(height: 8,),
                  Text("Dokumen Tambahan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 4,),
                  Text("Bukti kendaraan & background check",
                  style: TextStyle(fontSize: 13, color: Colors.grey),),
                  const SizedBox(height: 16,),

                  UploadCard(
                    title: "Bukti Kendaraan (Opsional)", 
                    file: widget.verifikasiData.stnkFile,
                    onTap: (){_pickImage();}, 
                    successText: "STNK berhasil diupload",
                    iconData: Icons.file_upload_outlined,
                    hintText: "Upload STNK (Opsional)",),
                  const SizedBox(height: 16,),

                  

                ],
              ),),
            ),
            const SizedBox(height: 10,),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8,),
                  Text("Background Check Premium",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 4,),
                  Text("Verifikasi tambahan untuk meningkatkan kepercayaan customer (Biaya: Rp 50.000)",
                  style: TextStyle(fontSize: 13, color: Colors.grey),),
                  const SizedBox(height: 16,),

                  

                  

                ],
              ),),
            ),
            const SizedBox(height: 16,),
                  Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Kembali", style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),)),
                  ),
                  SizedBox(width: 10,),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, 
                        MaterialPageRoute(
                          builder: (context)=> reviewDokumen(progress: _progress + 0.25, verifikasiData: widget.verifikasiData)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Lanjut", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)),
                  ),

                  ],
                  ),
          ],
        ),
      ),
    );
  }
}