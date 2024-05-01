import 'dart:convert'; // Melakukan import library untuk melakukan Decode JSON

void main() {
  // Data transkrip mahasiswa dalam bentuk JSON
  String transkripJson = '''
  {
    "nama": "Arsa Cahaya Pradipta",
    "npm": "22082010015",
    "mata_kuliah": [
      {
        "kode": "MK1101",
        "nama": "Pemrograman Desktop",
        "sks": 3,
        "nilai": "B+"
      },
      {
        "kode": "MK2102",
        "nama": "Analisis Desain Sistem Informasi",
        "sks": 3,
        "nilai": "A"
      },
      {
        "kode": "MK3103",
        "nama": "Interaksi Manusia Komputer",
        "sks": 3,
        "nilai": "A-"
      }
    ]
  }
  ''';

  // Melakukan Decode JSON menjadi Map
  Map<String, dynamic> transkrip = jsonDecode(transkripJson);

  // Melakukan cetak informasi mahasiswa
  print("Nama: ${transkrip['nama']}"); // Mencetak nama
  print("NPM: ${transkrip['npm']}"); // Mencetak NPM
  print("\nTranskrip:"); // Mencetak transkrip

  // Melakukan perhitungan IPK
  double ipk = hitungIPK(transkrip['mata_kuliah']);

  // Cetak detail transkrip
  for (var mataKuliah in transkrip['mata_kuliah']) {
    print("Kode: ${mataKuliah['kode']}"); // Mencetak kode mata kuliah
    print("Mata Kuliah: ${mataKuliah['nama']}"); // Mencetak nama mata kuliah
    print("SKS: ${mataKuliah['sks']}"); // Mencetak jumlah SKS
    print("Nilai: ${mataKuliah['nilai']}"); // Mencetak nilai mata kuliah
    print("");
  }

  // Melakukan cetak IPK
  print("IPK: ${ipk.toStringAsFixed(2)}");
}

double hitungIPK(List<dynamic> mataKuliah) {
  double totalBobot = 0; // Menyimpan total bobot nilai mata kuliah
  int totalSKS = 0; // Menyimpan total jumlah SKS mata kuliah

  // Melakukan perhitungan IPK
  for (var mk in mataKuliah) {
    double bobot = hitungBobotNilai(mk['nilai']); // Menyimpan bobot nilai mata kuliah
    totalBobot += bobot * mk['sks']; // Menambahkan total bobot nilai mata kuliah
    totalSKS += mk['sks'] as int; // Menambahkan total SKS dari mata kuliah
  }

  return totalBobot / totalSKS; // Mengembalikan total bobot nilai mata kuliah dibagi total SKS
}

// Menghitung bobot nilai berdasarkan huruf yang diberikan
double hitungBobotNilai(String nilai) {
  switch (nilai) {
    case "A":
      return 4.0;
    case "A-":
      return 3.7;
    case "B+":
      return 3.3;
    case "B":
      return 3.0;
    case "B-":
      return 2.7;
    case "C+":
      return 2.3;
    case "C":
      return 2.0;
    case "C-":
      return 1.7;
    case "D":
      return 1.0;
    default:
      return 0.0;
  }
}
