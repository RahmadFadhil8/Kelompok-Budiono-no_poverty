import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:no_poverty/Database/database_Service.dart';
import 'package:no_poverty/services/job_api_services.dart';
import 'package:no_poverty/widgets/custom_Button.dart';
import 'package:no_poverty/widgets/title1.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class FormaddJob extends StatefulWidget {
  const FormaddJob({super.key});

  @override
  State<FormaddJob> createState() => _FormaddJobState();
}

class _FormaddJobState extends State<FormaddJob> {

  String? userId;

  @override
  void initState() { 
    super.initState();
    takeId();
  }
  Future takeId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString("userId");
    if (storedId != null) {
      setState(() {
        userId = storedId;
      });
      print("User ID dari SharedPreferences: $userId");
    } else {
      print("User ID belum tersimpan di SharedPreferences");
    }
  }

  JobAPIServices jobs = JobAPIServices();

  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _BudgetController = TextEditingController();

  String? _kategori;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int Count = 0;
  bool isActive = false;

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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void addHelper () {
    setState(() {
      Count ++;
    });
  }

  void minHelper () {
    setState(() {
      Count --;
    });
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Title1(title: "waktu"),
                                  SizedBox(height: 12,),
                                  TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Waktu *',
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.access_time),
                                        onPressed: () => _selectTime(context),
                                      ),
                                      hintText: _selectedTime == null
                                          ? '--:--'
                                          : _selectedTime!.format(context),
                                    ),
                                    validator: (_) =>
                                        _selectedTime == null ? 'Pilih waktu' : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                          decoration: const InputDecoration(
                            hintText: '0',
                            prefixIcon: Icon(Icons.monetization_on_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                            value!.isEmpty ? 'Budget wajib di isi' : null,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Title1(title: "Izinkan Tawar-Manawar"),
                            Switch(
                              value: isActive, 
                              onChanged: (value) {
                                setState(() {
                                  isActive = value;
                                });
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                CustomButton(
                  onPress: (){
                    if (_judulController.text.isEmpty || _kategori == null || _deskripsiController.text.isEmpty || _alamatController.text.isEmpty || _BudgetController.text.isEmpty || _selectedDate == null || _selectedTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lengkapi semua field terlebih dahulu!"))
                      );
                      return;
                    }
                    
                    final tanggalStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                    final waktuStr = _selectedTime!.format(context);

                    jobs.create(userId!, _judulController.text, _kategori!, _deskripsiController.text, _alamatController.text, _BudgetController.text, Count, tanggalStr, waktuStr, isActive);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Job berhasil dikirim!")),
                    );
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