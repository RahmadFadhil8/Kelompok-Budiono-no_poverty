import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:no_poverty/models/verifikasi_data_model.dart';
import 'package:no_poverty/screens/Verifikasi/STNK.dart';
import 'package:no_poverty/screens/Verifikasi/widget/widget_UploadCard.dart';

class VerifikasiSKCK extends StatefulWidget {
  final double progress;
  final VerifikasiData verifikasiData;
  const VerifikasiSKCK({super.key, required this.progress, required this.verifikasiData});

  @override
  State<VerifikasiSKCK> createState() => _VerifikasiSKCKState();
}

class _VerifikasiSKCKState extends State<VerifikasiSKCK> {
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
        widget.verifikasiData.skckFile = File(pickedFile.path);
      });
    }
  }

  void _nextStep(){
    if (widget.verifikasiData.isSKCKcomplete){
      Navigator.push(context, 
    MaterialPageRoute(
      builder: (context)=> VerifikasiSTNK(progress: _progress + 0.25, verifikasiData: widget.verifikasiData)));
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
              child: Text("Step 2/4", style: TextStyle(color: Colors.blue, fontWeight:FontWeight.bold, fontSize: 12),),
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
                    child: Icon(Icons.description_outlined, color: Colors.blue, size: 30,),
                  ),
                  const SizedBox(height: 8,),
                  Text("SKCK",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 4,),
                  Text("Upload Surat Keterangan Catatan Kepolisian",
                  style: TextStyle(fontSize: 13, color: Colors.grey),),
                  const SizedBox(height: 16,),

                  UploadCard(
                    title: "Upload SKCK", 
                    file: widget.verifikasiData.skckFile,
                    onTap: (){_pickImage();}, 
                    successText: "SKCK berhasil diupload",
                    iconData: Icons.description_outlined,
                    hintText: "Upload SKCK (PDF/JPG)",),
                  const SizedBox(height: 16,),

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border(left: BorderSide(color: Colors.blue, width: 4)),
                    ),
                    child: RichText(text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      children: [TextSpan(
                        text: "Info :",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ), TextSpan(
                        text: " SKCK diperlukan untuk memastikan\n keamanan semua pengguna platform.\n Dokumen ini akan dijaga kerahasiaannya."
                      )
                      ]
                    ))
                  ),

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
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (widget.verifikasiData.isSKCKcomplete )? Colors.blue : Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: Colors.blue,
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