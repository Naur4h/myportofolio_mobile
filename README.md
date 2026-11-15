# MyPortfolio Mobile

Aplikasi mobile portofolio pribadi berbasis Flutter

## Deskripsi Proyek

Melanjutkan Tutorial 08, saya membangun versi mobile dari portofolio pribadi saya dengan Flutter. Halaman utama (`MyHomePage`) berupa `StatelessWidget` yang dipisahkan ke `lib/menu.dart`, sedangkan `lib/main.dart` hanya berisi titik masuk aplikasi dan tema.

Halaman utama menampilkan tiga kartu identitas (`InfoCard`: NPM, Name, Class) dengan data saya sendiri, lalu kisi tombol aksi portofolio (`ItemCard`). Data tombol disimpan pada model `ItemHomepage` yang memuat nama, ikon, dan warna, sehingga warna tiap tombol tidak memakai percabangan `if-else`. Saat tombol ditekan, muncul `SnackBar` bertuliskan "Kamu telah menekan tombol [Nama Tombol]!" dengan warna mengikuti tombol tersebut.

Tambahan di luar instruksi minggu ini:
- Lima tombol aksi (Lihat Proyek, Tambah Proyek, Lihat Skills, Lihat Education, Logout), masing-masing dengan ikon dan warna unik.
- SnackBar bergaya `floating` dengan warna yang sama seperti tombolnya.
- Layout responsif: halaman dapat digulir dan lebarnya dibatasi 600 px, sehingga tidak overflow di layar lebar (Chrome) dan tetap rapi seperti layar ponsel.

## Struktur Aplikasi

| Berkas | Isi |
|---|---|
| `lib/main.dart` | `main()` dan `MyApp` (`MaterialApp`, tema indigo berbasis `ColorScheme.fromSeed`) |
| `lib/menu.dart` | `MyHomePage`, `InfoCard`, `ItemHomepage` (model), `ItemCard` |

[ISI: kalau nanti kamu memecah file ke `models/` dan `widgets/`, perbarui tabel ini]

## Cara Menjalankan

Prasyarat: Flutter SDK (stable) dan Google Chrome. Android Studio bersifat opsional.

```bash
git clone https://github.com/Naur4h/myportofolio_mobile.git
cd myportofolio_mobile
flutter pub get
flutter run -d chrome
```

Pemeriksaan kode:

```bash
flutter analyze
```

Hasil terakhir: `No issues found!`

Saat aplikasi berjalan di terminal: `r` untuk hot reload, `R` untuk hot restart, `q` untuk berhenti.

## Weekly Progress

**10 November 2026 (Tutorial 08)**
- Memasang Flutter SDK di Windows (ekstrak ke `C:\src\flutter`, menambahkan `C:\src\flutter\bin` ke PATH) dan memverifikasi dengan `flutter --version` dan `flutter doctor`.
- Membuat proyek `myportofolio_mobile`, menjalankannya di Chrome, memisahkan `menu.dart` dari `main.dart`, dan mengubah `MyHomePage` menjadi `StatelessWidget`.
- Membuat `InfoCard`, `ItemHomepage`, dan `ItemCard`, lalu merakitnya di `MyHomePage`.

**11 November 2026 (Tutorial 08)**
- Menjalankan `flutter analyze` (bersih), membuat repositori GitHub publik, dan push commit pertama.

**13 November 2026 (Tugas 7)**
- Mengganti data contoh dengan identitas saya sendiri pada tiga `InfoCard`.
- Menambahkan atribut `color` pada `ItemHomepage` dan memakainya di `ItemCard`.

**15 November 2026 (Tugas 7)**
- Memperbaiki overflow dengan `SingleChildScrollView`, `Center`, dan `ConstrainedBox`, serta mengubah `InfoCard` agar lebarnya diatur `Expanded`.
- Menambahkan tombol Lihat Skills dan Lihat Education, serta SnackBar berwarna.
- Menulis README dan menjawab pertanyaan reflektif.

## AI Disclosure & Usage

**Tools:** Claude 

**Bagian yang dibantu AI:**
- Setup Flutter di Windows: memilih file yang tepat, mengekstrak dengan `tar` karena drag-and-drop dari zip terlalu lambat, dan mengatur PATH lewat PowerShell.
- Membaca pesan di terminal (`flutter doctor`, log debug Chrome, notifikasi Java/Gradle di VS Code) dan menentukan mana yang perlu ditangani.

Contoh prompt dan hasilnya:
- Prompt: "kan tdi awal2 udh flutter run trs input 2 nah skrng tinggal referesh aja kli or emg selalu hrus gt?"
  Claude: Menjelaskan bahwa refresh di browser tidak meng-compile ulang kode; yang melakukannya adalah sesi `flutter run` di terminal. Tombol `r` (hot reload) memasukkan perubahan tanpa mengulang aplikasi, `R` (hot restart) mengulang dari `main()`, dan `flutter run` perlu dijalankan lagi hanya jika sesinya sudah berhenti. (Terkait pertanyaan reflektif no. 6.)
- Prompt: "ok udh tampilan g ad yg berubah"
  Claude: Menyebutkan kemungkinan penyebabnya: hot reload bisa menolak perubahan jenis kelas dari Stateful ke Stateless sehingga perlu hot restart, atau ada error kode yang membuat tampilan lama tetap tampil

**Analisis keterbatasan AI dan perbaikan manual:**
- **Tidak melihat lingkungan saya.** Layout dari tutorial ternyata overflow di Chrome berukuran desktop ("BOTTOM OVERFLOWED BY 85 PIXELS"). Hal ini baru diketahui setelah saya mengirim screenshot, bukan diprediksi di awal. Saya yang menguji hasilnya di browser dan melaporkan masalahnya.
- Perbaikan manual yang saya kerjakan sendiri: menentukan lokasi instalasi dan PATH, menjalankan ulang `flutter run -d chrome` ketika hot reload tidak merespons, mengganti data contoh dengan identitas saya, memilih tombol yang sesuai portofolio, serta memverifikasi tampilan dan `flutter analyze` sebelum commit.

## Pertanyaan Reflektif

### Tugas 7

1. **Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan induk-anak (parent-child) bekerja antar-widget!**

   Widget tree adalah susunan widget bersarang yang membentuk seluruh tampilan, mirip pohon DOM pada HTML. Setiap widget (induk) dapat memiliki satu atau banyak widget di dalamnya (anak). Induk meneruskan batasan ukuran (constraints) ke anaknya, anak menentukan ukurannya sendiri dalam batasan itu, lalu induk menentukan posisinya. Pada proyek ini: `MaterialApp` → `MyHomePage` → `Scaffold` → `AppBar` dan `body` → `Column` → `Row` (berisi tiga `InfoCard`) dan `GridView` (berisi `ItemCard`). Contoh pengaruh induk ke anak: `ConstrainedBox` membatasi lebar 600 px sehingga semua widget di dalamnya mengikuti batas itu.

2. **Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!**

   | Widget | Fungsi |
   |---|---|
   | `MaterialApp` | Root aplikasi: tema, judul, dan halaman awal |
   | `Scaffold` | Kerangka halaman (AppBar, body, tempat SnackBar) |
   | `AppBar` | Bar judul di bagian atas |
   | `Text` | Menampilkan teks |
   | `SingleChildScrollView` | Membuat konten dapat digulir |
   | `Center` | Memusatkan anaknya |
   | `ConstrainedBox` | Membatasi ukuran maksimum anaknya |
   | `Padding` | Memberi jarak di sekeliling anak |
   | `Column` / `Row` | Menyusun anak secara vertikal / horizontal |
   | `Expanded` | Membagi sisa ruang pada `Row`/`Column` |
   | `SizedBox` | Memberi jarak atau ukuran tetap |
   | `Card` | Kotak dengan bayangan (kartu `InfoCard`) |
   | `Container` | Pembungkus untuk padding, ukuran, dan dekorasi |
   | `GridView.count` | Menyusun anak dalam kisi dengan jumlah kolom tetap |
   | `Material` | Permukaan berwarna dengan sudut membulat untuk `ItemCard` |
   | `InkWell` | Membuat area dapat ditekan dengan efek riak |
   | `Icon` | Menampilkan ikon |
   | `SnackBar` | Pesan singkat di bawah layar |
   | `ScaffoldMessenger` | Mengelola dan menampilkan `SnackBar` |

   Selain itu ada widget buatan sendiri: `MyApp`, `MyHomePage`, `InfoCard`, dan `ItemCard`.

3. **Apa fungsi dari widget `MaterialApp`? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter!**

   `MaterialApp` membungkus aplikasi dengan fondasi Material Design: menyediakan tema (`ThemeData`, termasuk `ColorScheme.fromSeed` yang saya pakai), judul aplikasi, halaman awal (`home`), serta sistem navigasi dan rute antarhalaman. Widget turunan bisa mengakses semua itu lewat `Theme.of(context)`. Karena hampir semua widget Material (`Scaffold`, `AppBar`, `SnackBar`) membutuhkan konteks Material di atasnya, `MaterialApp` dipakai sebagai root agar semua widget itu berfungsi dan konsisten.

4. **Jelaskan perbedaan antara `StatelessWidget` dan `StatefulWidget`! Kapan kita sebaiknya memilih `StatelessWidget` dan kapan harus menggunakan `StatefulWidget`?**

   `StatelessWidget` tidak menyimpan data yang berubah selama hidupnya: tampilannya hanya ditentukan oleh parameter yang diberikan saat dibuat. `StatefulWidget` memiliki objek `State` terpisah yang menyimpan data berubah, dan pemanggilan `setState()` membuat widget digambar ulang. Pilih `StatelessWidget` bila tampilan statis atau hanya bergantung pada data yang dikirim induk, seperti `MyHomePage`, `InfoCard`, dan `ItemCard` di proyek ini. Pilih `StatefulWidget` bila tampilan berubah akibat interaksi atau waktu, misalnya counter pada template bawaan, input formulir, atau tombol toggle. Di Tutorial 08, `MyHomePage` saya ubah dari Stateful menjadi Stateless karena counter bawaannya tidak dipakai lagi.

5. **Apa itu `BuildContext` dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode `build`?**

   `BuildContext` adalah penanda posisi sebuah widget di dalam widget tree. Dengan posisi itu, widget dapat mencari informasi dari induk-induk di atasnya, seperti tema, ukuran layar, atau `Scaffold`. Di metode `build(BuildContext context)`, context dipakai pada pemanggilan `Theme.of(context)` (misalnya `Theme.of(context).colorScheme.primary` untuk warna AppBar) dan `ScaffoldMessenger.of(context)` (untuk menampilkan `SnackBar` di `ItemCard`). Tanpa context yang benar, pencarian itu bisa gagal, misalnya mencari `Scaffold` dari context yang berada di atasnya.

6. **Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart?**

   Hot reload memasukkan kode Dart yang baru ke aplikasi yang sedang berjalan lalu membangun ulang widget tree, **tanpa menghilangkan state** (di terminal: tombol `r`). Hot restart memulai ulang aplikasi dari `main()` sehingga **semua state kembali ke awal** (tombol `R`), tetapi lebih cepat daripada menjalankan ulang dari nol. Hot reload tidak cukup bila: mengubah `main()` atau nilai awal variabel global/statis, mengubah jenis kelas widget (misalnya `StatefulWidget` menjadi `StatelessWidget`, seperti saat saya merombak `MyHomePage`), atau mengubah logika inisialisasi. Full restart (hentikan lalu `flutter run` lagi) diperlukan saat mengubah `pubspec.yaml` (dependensi atau aset), konfigurasi native seperti folder `android/`, atau menambah plugin.