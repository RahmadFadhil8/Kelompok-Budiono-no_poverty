import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:no_poverty/Permission/handler.dart';
import 'package:no_poverty/models/job_model_fix_firestore.dart';
import 'package:no_poverty/services/job_services_firestore.dart';
import 'package:no_poverty/services/notification_services.dart';
import 'package:no_poverty/widgets/custom_Button.dart';
import 'package:no_poverty/widgets/title1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormaddJob extends StatefulWidget {
  const FormaddJob({super.key});

  @override
  State<FormaddJob> createState() => _FormaddJobState();
}

class _FormaddJobState extends State<FormaddJob> {
  String coordinate = "Belum ada";
  String address = "Belum ada";
  GeoPoint? geoPoint;
  String? userId;

  final permission = Handler_Permission();

  // <============Iklan Interstitial============>

  InterstitialAd? _interstitialAd;
  String Interstitialid = "ca-app-pub-3940256099942544/1033173712";

  void _loadInterstitialAd() {
    InterstitialAd.load( 
      adUnitId: Interstitialid, 
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd();
              
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadInterstitialAd();
            },
          );
        }, 
        onAdFailedToLoad: (error) {
          print("Filed to load ad:${error.message}");
        }),
      request: AdRequest(),
    );
  }
  // <================================================>

  void getMylocation() async {
    try {
      Position? pos = await permission.getLocation();
      geoPoint = GeoPoint(pos!.latitude, pos.longitude);
      String addresstext = await permission.getaddress(pos!);

      setState(() {
        coordinate = "lat: ${pos.latitude}, lng: ${pos.longitude}";
        address = addresstext;
      });
    } catch (e) {
      setState(() {
        coordinate = "Error: $e";
        address = "Tidak ada alamat";
      });
    }
  }

  @override
  void initState() { 
    _loadInterstitialAd();
    super.initState();
    takeId();
    getMylocation();
  }
  Future takeId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString("userId");
    if (storedId != null) {
      setState(() {
        userId = storedId;
      });
    } else {
    }
  }

  // JobAPIServices jobs = JobAPIServices();
  JobService job = JobService();

  String jobId = FirebaseFirestore.instance.collection("jobs").doc().id;


  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _BudgetController = TextEditingController();
  final TextEditingController _skillcontroler = TextEditingController();

  

  String? _kategori;
  DateTime? _selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int Count = 0;
  bool isActive = false;
  List<String> workerApply = [];

  final List<String> _kategoriList = [
    'Kebersihan',
    'Perbaikan',
    'Perawatan',
    'Lainnya'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != startTime) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> selectendTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != endTime) {
      setState(() {
        endTime = picked;
      });
    }
  }

  void addHelper () {
    setState(() {
      Count ++;
    });
  }

  void minHelper () {
    if (Count >0) {
      setState(() {
        Count --;
      });
    }
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Title1(title: "Informasi Dasar",),
        
                        const SizedBox(height: 18),
                        Title1(title: "Judul pekerjaan",),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _judulController,
                          decoration: const InputDecoration(
                            labelText: "Judul pekerjaan",
                            hintText: "Misal: Pembersihan rumah 2 lantai",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value!.isEmpty ? 'judul pekerjaan wajib diisi' : null
                        ),
                    
                        const SizedBox(height: 12),
                        Title1(title: "Kategori *",),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Kategori *',
                            border: OutlineInputBorder(),
                          ),
                          value: _kategori,
                          items: _kategoriList
                              .map((kategori) => DropdownMenuItem(
                                    value: kategori,
                                    child: Text(kategori),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _kategori = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Pilih kategori terlebih dahulu' : null,
                        ),
                    
                        const SizedBox(height: 12),
                        Title1(title: "Deskripsi",),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _deskripsiController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: "Deskripsi",
                            hintText: "Jelaskan detail pekerjaan yang dibutuhkan....",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value!.isEmpty ? 'Deskripsi wajib diisi' : null
                        ),
                    
                        
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Title1(title: "Lokasi & Jadwal"),
                        const SizedBox(height: 18),
                        Title1(title: "Alamat"),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _alamatController,
                          decoration: const InputDecoration(
                            labelText: 'Alamat *',
                            hintText: 'Masukkan alamat lengkap',
                            prefixIcon: Icon(Icons.location_on_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                            value!.isEmpty ? 'Alamat wajib diisi' : null,
                        ),
        
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Title1(title: "Tanggal"),
                                  SizedBox(height: 12,),
                                  TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Tanggal *',
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.calendar_today),
                                        onPressed: () => _selectDate(context),
                                      ),
                                      hintText: _selectedDate == null
                                          ? 'mm/dd/yyyy'
                                          : DateFormat('dd/MM/yyyy')
                                              .format(_selectedDate!),
                                    ),
                                    validator: (_) =>
                                        _selectedDate == null ? 'Pilih tanggal' : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ), 
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Title1(title: "waktu mulai"),
                                  SizedBox(height: 12,),
                                  TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Waktu *',
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.access_time),
                                        onPressed: () => selectStartTime(context),
                                      ),
                                      hintText: startTime == null
                                          ? '--:--'
                                          : startTime!.format(context),
                                    ),
                                    validator: (_) =>
                                        startTime == null ? 'Pilih waktu' : null,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Title1(title: "waktu selesai"),
                                  SizedBox(height: 12,),
                                  TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Waktu *',
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.access_time),
                                        onPressed: () => selectendTime(context),
                                      ),
                                      hintText: endTime == null
                                          ? '--:--'
                                          : endTime!.format(context),
                                    ),
                                    validator: (_) =>
                                        endTime == null ? 'Pilih waktu' : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ) 
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Title1(title: "Skill yang di butuhkan"),
                        SizedBox(height: 18,),
                        TextFormField(
                          controller: _skillcontroler,
                          decoration: const InputDecoration(
                            hintText: 'skil yang di butuhkan',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                            value!.isEmpty ? 'Budget wajib di isi' : null,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Title1(title: "Kebutuhan dan Harga"),
                        SizedBox(height: 18,),
        
                        Title1(title: "Jumlah Helper yang dibutuhkan"),
                        SizedBox(height: 12,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(onPressed: minHelper, child: Text("-", style: TextStyle(color: Colors.black),)),
                            Row(
                              children: [
                                Icon(Icons.people),
                                SizedBox(width: 8,),
                                Text("${Count} Orang"),
                              ],
                            ),
                            ElevatedButton(onPressed: addHelper, child: Text("+", style: TextStyle(color: Colors.black),))
                          ],
                        ),
        
                        SizedBox(height: 18,),
                        Title1(title: "Budget(Rp)"),
                        SizedBox(height: 12,),
                        TextFormField(
                          controller: _BudgetController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            hintText: '0',
                            prefixIcon: Icon(Icons.monetization_on_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Budget wajib diisi';
                              }

                              final parsed = int.tryParse(value);
                              if (parsed == null) {
                                return 'Budget harus berupa angka';
                              }

                              if (parsed <= 0) {
                                return 'Budget harus lebih dari 0';
                              }

                              return null;
                          }
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Title1(title: "Izinkan Tawar-Manawar"),
                        //     Switch(
                        //       value: isActive, 
                        //       onChanged: (value) {
                        //         setState(() {
                        //           isActive = value;
                        //         });
                        //       },
                        //     )
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                
                CustomButton(
                  onPress: ()async{

                    if (geoPoint == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Lokasi belum tersedia, tunggu sebentar")),
  );
  return;
}


                    if (_judulController.text.isEmpty || _kategori == null || _deskripsiController.text.isEmpty || _alamatController.text.isEmpty || _BudgetController.text.isEmpty || _selectedDate == null || startTime == null || endTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lengkapi semua field terlebih dahulu!"))
                      );
                      return;
                    }
                    
                    final gaji = double.tryParse(_BudgetController.text) ?? 0.0;

                    if (gaji == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Budget harus berupa angka")),
                      );
                      return;
                    }

                    if (gaji <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Budget harus lebih dari 0")),
                      );
                      return;
                    }

                    final DateTime tanggalStr = _selectedDate!;
                    // final waktuStr = _selectedTime!.format(context);

                    final waktuMulai = Timestamp.fromDate(DateTime(
                      _selectedDate!.year,
                      _selectedDate!.month,
                      _selectedDate!.day,
                      startTime!.hour,
                      startTime!.minute
                    ));

                    final waktuSelesai = Timestamp.fromDate(DateTime(
                      _selectedDate!.year,
                      _selectedDate!.month,
                      _selectedDate!.day,
                      endTime!.hour,
                      endTime!.minute
                    ));

                    final pekerjaan = JobModelFix(
                      job_id: jobId, 
                      employer_id: userId.toString(), 
                      title: _judulController.text, 
                      description: _deskripsiController.text, 
                      category: _kategori!, 
                      location: geoPoint!, 
                      city : address,
                      address: _alamatController.text, 
                      wage: gaji, 
                      max_applicants: Count,
                      date_time: Timestamp.fromDate(tanggalStr),
                      start_time: waktuMulai, 
                      end_time: waktuSelesai, 
                      requiredSkills: _skillcontroler.text.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toList(), 
                      status: "open", 
                      worker_id_apply: workerApply, 
                      selected_worker_id: null,
                      createdAt: Timestamp.now(), 
                      updatedAt: Timestamp.now()
                    );

                    try {  
                      await job.createJob(pekerjaan);

                      await NotificationServices.showNotification(
                        title: "Job Berhasil dibuat",
                        body: "Pekerjaan ${ _judulController.text} telah dipublikasi",
                        payload: {
                          "navigate":  "true",
                        },
                      );

                      if (!mounted) return;

                      _interstitialAd?.show();
                      Navigator.pop(context);

                    } catch (e, s) {
                      debugPrint("Error Create JOB: $e");
                      debugPrintStack(stackTrace: s);  
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Gagal membuat job")),
                      );                    
                    }

                    // jobs.create(userId!, _judulController.text, _kategori!, _deskripsiController.text, _alamatController.text, _BudgetController.text, Count, tanggalStr, waktuStr, isActive);
                  }, 
                  child: Text("Publish Job")
                ),
                SizedBox(height: 20,),
              ],
            ),
      ),
    );
  }
}