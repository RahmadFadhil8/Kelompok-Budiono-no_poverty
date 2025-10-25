import 'package:flutter/material.dart';
import 'package:no_poverty/models/verifikasi_data_model.dart';
import 'package:no_poverty/services/verifikasi_API_service.dart';
import 'package:no_poverty/screens/main_bottom_navigation.dart';


class reviewDokumen extends StatefulWidget {
  final double progress;
  final VerifikasiData verifikasiData;
  const reviewDokumen({super.key, required this.progress, required this.verifikasiData});

  @override
  State<reviewDokumen> createState() => _reviewDokumenState();
}

class _reviewDokumenState extends State<reviewDokumen> {
  late double _progress;

  @override
  void initState(){
      super.initState();
      _progress = widget.progress;
  }


  @override
  Widget build(BuildContext context) {
    final data = widget.verifikasiData;

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
              child: Text("Step 4/4", style: TextStyle(color: Colors.blue, fontWeight:FontWeight.bold, fontSize: 12),),
            ),
          ),)
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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

            SizedBox( height: 170, width: double.infinity,
            child: 
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.task_alt, color: Colors.blue, size: 30,),
                  ),
                  const SizedBox(height: 8,),
                  Text("Review",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 4,),
                  Text("Verifikasi dokumen",
                  style: TextStyle(fontSize: 13, color: Colors.grey),),
                ],
              ),),
            ),
            ),
            const SizedBox(height: 10,),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ 
                  Padding(padding: EdgeInsets.all(12),
                  child: 
                    Text("Review Dokumen", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(height: 16,),

                  _buildDocRow("KTP", data.isKTPcomplete,),
                  const SizedBox(height: 10),
                  _buildDocRow("Foto Selfie", data.isKTPcomplete),
                  const SizedBox(height: 10),
                  _buildDocRow("SKCK", data.isSKCKcomplete),
                  const SizedBox(height: 10),
                  if (data.stnkFile != null)
                  _buildDocRow("STNK", data.isSTNKcomplete),
                  const SizedBox(height: 20),


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
                        text: "Estimasi Waktu: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ), TextSpan(
                        text: "1-3 hari kerja untuk verifikasi\n lengkap. Anda akan mendapat notifikasi setelah\n proses selesai."
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
                      onPressed: () async{
                        final service = VerifikasiService();
                        final success = await service.uploadDocuments(widget.verifikasiData);

                        if (success){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> MainBottomNavigation()));
                          Future.delayed(Duration(milliseconds: 500), () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Verifikasi berhasil")));
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal upload verifikasi")),);
                        }
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Submit Verifikasi", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)),
                  ),

                  ],
                  ),
          ],
        ),
      ),
    );
  }
  Widget _buildDocRow(String title, bool isComplete) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Icon(isComplete? Icons.check_circle_outline : Icons.cancel, color: isComplete? Colors.green : Colors.red, size: 18,),
          SizedBox(width: 4,),
          Text(isComplete? "Ready" : "Belum lengkap", style: TextStyle(fontSize: 13, color: isComplete? Colors.green : Colors.red, fontWeight: FontWeight.w500),)
          ],
        )
      ],
    );
  }
}