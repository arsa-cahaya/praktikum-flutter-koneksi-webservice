import 'package:flutter/material.dart'; // Melakukan import library material.dart
import 'package:http/http.dart' as http; // Melakukan import library http.dart
import 'dart:convert'; // Melakukan import library convert.dart

// Fungsi utama yang akan dijalankan
void main() {
  runApp(const MyApp());
}

// Menampung data hasil pemanggilan API
class Activity {
  String aktivitas; // Mendefinisikan aktivitas dengan tipe data string
  String jenis; // Mendefinisikan jenis dengan tipe data string

  Activity({required this.aktivitas, required this.jenis}); // Constructor

  // Map dari json ke atribut
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'], // Mengembalikan JSON aktivitas
      jenis: json['type'], // Mengembalikan JSON jenis aktivitas
    );
  }
}

// Class MyApp adalah stateful widget yang merupakan entri utama dari aplikasi.
// Ini mengimplementasikan metode createState() yang mengembalikan instance dari MyAppState.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

// Class MyAppState adalah state dari MyApp yang mengelola keadaan (state) dari aplikasi.
class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity; // Menampung hasil

  // Late Future<Activity>? futureActivity;
  String url = "https://www.boredapi.com/api/activity";

  // Fungsi init() untuk menginisialisasi futureActivity dengan nilai awal.
  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: "");
  }

  // Fungsi fetchData() untuk mengambil data dari web service menggunakan HTTP GET request.
  // Data yang diterima akan di-parse menjadi objek Activity menggunakan method fromJson().
  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Jika server merespons dengan status code 200 (OK),
      // data JSON di-parse dan diubah menjadi objek Activity.
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // Jika terjadi kesalahan (status code bukan 200 OK),
      // lempar exception dengan pesan 'Gagal load'.
      throw Exception('Gagal load');
    }
  }

  // Metode initState() dipanggil ketika state MyAppState pertama kali dibuat.
  // Di sini, futureActivity diinisialisasi dengan nilai awal menggunakan fungsi init().
  @override
  void initState() {
    super.initState();
    futureActivity = init();
  }

  // Metode build() membangun UI aplikasi menggunakan Material Design.
  // Ini membangun tata letak dengan tombol dan FutureBuilder untuk menampilkan aktivitas yang diambil dari web service.
  @override
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity = fetchData(); // Memperbarui futureActivity dengan hasil pemanggilan fetchData().
                });
              },
              child: Text("Saya bosan ..."),
            ),
          ),
          FutureBuilder<Activity>(
            future: futureActivity, // Menyediakan future untuk FutureBuilder.
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika ada data yang diterima dari future, tampilkan aktivitas dan jenisnya.
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas),
                      Text("Jenis: ${snapshot.data!.jenis}")
                    ]));
              } else if (snapshot.hasError) {
                // Jika terjadi kesalahan, tampilkan pesan kesalahan.
                return Text('${snapshot.error}');
              }
              // Jika belum ada data, tampilkan indikator loading (circular progress indicator).
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}
