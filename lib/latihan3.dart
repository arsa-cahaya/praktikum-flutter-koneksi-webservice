import 'package:flutter/material.dart'; // Melakukan import library material.dart
import 'package:http/http.dart' as http; // Melakukan import library http.dart
import 'dart:convert'; // Melakukan import library convert.dart

// Fungsi utama yang akan dijalankan
void main() {
  runApp(const MyApp());
}

// Class University berfungsi merepresentasikan entitas universitas dengan nama dan website.
class University {
  String name;
  String website;

  University({required this.name, required this.website});

  // Factory method berfungsi untuk mengonversi JSON menjadi objek University.
  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      website: json['web_pages'][0],
    );
  }
}

// Class UniversitiesList berfungsi merepresentasikan daftar universitas.
class UniversitiesList {
  List<University> universities;

  UniversitiesList({required this.universities});

  // Factory method berfungsi untuk mengonversi JSON menjadi objek UniversitiesList.
  factory UniversitiesList.fromJson(List<dynamic> json) {
    List<University> universities = [];
    universities = json.map((uni) => University.fromJson(uni)).toList();
    return UniversitiesList(universities: universities);
  }
}

// Class MyApp merupakan sebuah stateful widget yang merupakan entri utama dari aplikasi.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

// Class _MyAppState merupakan state dari MyApp yang mengelola keadaan (state) dari aplikasi.
class _MyAppState extends State<MyApp> {
  late Future<UniversitiesList> futureUniversities;
  final String url = "http://universities.hipolabs.com/search?country=Indonesia";

  @override
  void initState() {
    super.initState();
    futureUniversities = fetchUniversities();
  }

  // Fungsi untuk mengambil daftar universitas dari web service.
  Future<UniversitiesList> fetchUniversities() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return UniversitiesList.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load universities');
    }
  }

  // Method build() berfungsi membangun UI aplikasi menggunakan Material Design.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Universitas di Indonesia'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: FutureBuilder<UniversitiesList>(
            future: futureUniversities,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika terdapat data yang diterima dari future, tampilkan daftar universitas.
                return ListView.builder(
                  itemCount: snapshot.data!.universities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data!.universities[index].name),
                      subtitle: Text(snapshot.data!.universities[index].website),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                // Jika terjadi kesalahan, tampilkan pesan kesalahan.
                return Text("${snapshot.error}");
              }
              // Jika belum ada data, tampilkan indikator loading (circular progress indicator).
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
