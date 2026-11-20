# MyPortfolio Mobile

Aplikasi mobile portofolio pribadi berbasis Flutter

# Tugas 7

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

# Tugas 8

## Deskripsi Proyek

Melanjutkan Tutorial 09 dan Tugas 7, saya menambahkan navigasi, layout, dan formulir pada aplikasi MyPortfolio Mobile. Pada Tutorial 09, saya membuat drawer (`LeftDrawer`), formulir Tambah Proyek (`ProjectFormPage`), dan merapikan struktur folder menjadi `lib/screens/` dan `lib/widgets/`. Pada tugas ini, saya menerapkan pola yang sama untuk bagian **Education**: halaman formulir baru (`EducationFormPage`), kartu aksi "Tambah Education" di halaman utama, dan opsi "Add Education" di drawer.

Formulir Education memiliki enam input:
- Nama Institusi (`TextFormField`, wajib, maksimal 100 karakter)
- Jenjang (`DropdownButtonFormField`: SMA/SMK, D3, S1, S2, S3)
- Jurusan / Program Studi (`TextFormField`, wajib, maksimal 100 karakter)
- Tanggal Mulai (`showDatePicker`, wajib)
- Tanggal Selesai (`showDatePicker`, wajib kecuali masih berkuliah, tidak boleh sebelum tanggal mulai)
- IPK (`TextFormField` angka, opsional, harus 0.00 sampai 4.00)

Validasi dijalankan lewat `FormState.validate()` saat tombol Simpan ditekan. Isian yang kosong atau hanya berisi spasi ditolak (memakai `trim()`). Setelah semua input lolos, ringkasan isian ditampilkan dalam `AlertDialog` dengan tombol Tutup.

Tambahan di luar instruksi minggu ini:
- **Switch "Masih berkuliah di sini"**: jika aktif, field Tanggal Selesai dinonaktifkan dan dialog menampilkan "Sekarang".
- **Validasi langsung saat berinteraksi** (`AutovalidateMode.onUserInteraction`), sehingga pesan kesalahan muncul tanpa menekan Simpan lebih dulu.
- **Penghitung karakter** (maks. 100) pada Nama Institusi dan Jurusan.
- **Validasi ulang otomatis** pada Tanggal Selesai saat Tanggal Mulai diubah.
- Komentar dan docstring pada kode formulir.

## Struktur Aplikasi

| Berkas | Isi |
|---|---|
| `lib/main.dart` | `main()` dan `MyApp` (`MaterialApp`, tema indigo) |
| `lib/screens/menu.dart` | `MyHomePage`, `InfoCard`, `ItemHomepage` (model) |
| `lib/screens/project_form.dart` | `ProjectFormPage` (formulir Tambah Proyek, Tutorial 09) |
| `lib/screens/education_form.dart` | `EducationFormPage` (formulir Tambah Education, Tugas 8) |
| `lib/widgets/left_drawer.dart` | `LeftDrawer` (opsi Home, Add Project, Add Education), dipakai di ketiga halaman |
| `lib/widgets/project_card.dart` | `ItemCard` (kartu aksi dengan `Navigator.push` ke formulir) |

## Weekly Progress

**16 November 2026 (Tutorial 09)**
- Memasang paket `material_ui` (Flutter 3.47.9) dan mengganti import `flutter/material.dart`.
- Membuat `LeftDrawer`, `ProjectFormPage`, dan dialog ringkasan.
- Memindahkan file ke `lib/screens/` dan `lib/widgets/`, memindahkan `ItemCard` ke `project_card.dart`, lalu push ke GitHub.

**19 - 20 November 2026 (Tugas 8)**
- Membuat `EducationFormPage` dengan enam input dan validasi.
- Menambahkan kartu "Tambah Education" di halaman utama dan opsi "Add Education" di drawer.
- Menambahkan switch "Masih berkuliah", validasi langsung, dan penghitung karakter.
- Menjalankan `flutter analyze` (hasil: No issues found! (ran in 3.9s)) dan menguji alur kartu, drawer, input tidak valid, input valid, serta navigasi ke Home.
- Menulis jawaban reflektif dan AI disclosure.

## AI Disclosure & Usage

**Tools:** Claude

**Strategi prompting:**
- Meminta AI membandingkan hasil dengan rubrik sebelum menulis README, lalu memutuskan sendiri fitur tambahan yang dipakai.

**Bagian yang dibantu AI:**
- Memahami alur navigasi (`push`, `pushReplacement`, `pop`) dan struktur `Form`, `GlobalKey<FormState>`, serta `validator`.
- Menentukan aturan validasi (spasi saja, panjang maksimal, urutan tanggal, rentang IPK).
- Membaca pesan error terminal, misalnya timeout koneksi debugger Chrome dan garis merah di editor.

Contoh prompt dan hasilnya:
- Prompt: "ywdh ap update aja versi fliutterny? enakny gmn"
  Claude: Menjelaskan bahwa Flutter 3.47.9 tidak perlu di-update karena materi menyediakan jalur untuk versi itu (`flutter pub add material_ui`), dan update lewat zip berisiko di dekat tenggat.
- Prompt: "kok error" (dengan screenshot)
  Claude: Menunjukkan bahwa satu baris `ItemHomepage` yang saya tempel berada di dalam class model, bukan di dalam list `items` pada `MyHomePage`.
- Prompt: "udh kriteria 4/4 blm sebelum masuk readme"
  Claude: Membandingkan kondisi proyek dengan rubrik dan menyebut bahwa fitur ekstra, `flutter analyze`, riwayat commit, dan README masih kurang. Dari situ saya memutuskan menambahkan switch "Masih berkuliah" dan validasi langsung.

**Analisis keterbatasan AI dan perbaikan manual:**
- **AI tidak melihat berkas saya.** Pada Tutorial 09, kartu "Tambah Proyek" hanya menampilkan SnackBar karena `menu.dart` saya masih memuat `ItemCard` lama. AI baru bisa menyimpulkan penyebabnya setelah saya menempelkan isi berkas. Saya yang menelusuri berkas mana yang dipakai aplikasi dan mengganti isinya.
- **Error yang bukan dari kode.** Timeout koneksi debugger ("Failed to connect to the web debug service") ternyata masalah Chrome di Windows, bukan bug kode. Saya menutup Chrome dan menjalankan ulang `flutter run -d chrome`.
- **AI tidak bisa menjalankan aplikasi.** Kebenaran hasil saya periksa sendiri di Chrome: spasi saja di Nama Institusi, tanggal selesai sebelum tanggal mulai, IPK 5, switch "Masih berkuliah", dan tampilan dialog.

## Pertanyaan Reflektif

### Tugas 8

1. **Perbedaan `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`; metode untuk membuka formulir dari kartu aksi; dan cara opsi Home di drawer membawa pengguna kembali ke halaman utama.**

   Navigator mengatur halaman sebagai tumpukan (stack). `push()` menaruh halaman baru di atas tumpukan, sehingga halaman sebelumnya tetap ada di bawahnya dan tombol kembali bisa dipakai. `pushReplacement()` mengganti halaman paling atas dengan halaman baru, jadi halaman lama dibuang dan tidak bisa dikembali-kan lewat tombol Back. `pop()` membuang halaman paling atas dan kembali ke halaman di bawahnya. Untuk membuka formulir dari kartu aksi saya memakai `Navigator.push()` pada `ItemCard`, agar pengguna dapat kembali ke halaman utama dengan tombol kembali. Opsi Home di drawer memakai `Navigator.pushReplacement()` dengan `MaterialPageRoute` yang membangun `MyHomePage()`. Dari halaman formulir, formulir diganti dengan halaman utama sehingga pengguna sampai di halaman utama. Catatan dari pengujian: karena formulir dibuka dengan `push()`, halaman utama yang lama masih tersisa di bawah tumpukan.

2. **Peran susunan `Scaffold`, `AppBar`, dan `Drawer` dalam menjaga konsistensi, serta contoh warna tema yang dipakai di lebih dari satu halaman.**

   `Scaffold` menyediakan kerangka halaman yang sama (AppBar di atas, body di tengah, drawer di sisi kiri), `AppBar` memberi identitas halaman, dan `Drawer` memberi navigasi yang sama di mana pun pengguna berada. Karena `LeftDrawer` adalah satu widget yang dipakai di halaman utama, formulir Tambah Proyek, dan formulir Tambah Education, menu dan tampilannya selalu seragam, dan perubahan cukup dilakukan di satu berkas. Contoh warna tema: indigo dipakai pada AppBar halaman utama (lewat `colorScheme.primary` dari tema), AppBar kedua formulir (`Colors.indigo`), `DrawerHeader` di `LeftDrawer`, dan tombol Simpan di kedua formulir, sehingga semua halaman terlihat sebagai satu aplikasi.

3. **Alasan memilih tata letak formulir, serta peran widget pengatur jarak dan penggulir saat ruang layar terbatas.**

   Tiap input saya letakkan di dalam `Column` dan dibungkus `Padding` agar tersusun vertikal, mudah dibaca, dan mudah dijangkau jempol di layar ponsel. `Padding` memberi jarak antar-field supaya input tidak menempel dan pesan kesalahan tidak bertabrakan dengan field di bawahnya. `SingleChildScrollView` membuat seluruh form dapat digulir sehingga tidak terjadi overflow saat layar pendek atau saat papan ketik muncul dan menutupi sebagian layar. Padding bawah tambahan memastikan tombol Simpan tetap bisa digulir ke area yang terlihat. Pada formulir Education, ada enam field, switch, dan tombol, jadi tanpa penggulir bagian bawah mudah tidak terjangkau.

4. **Peran `GlobalKey<FormState>`, `validator`, dan `validate()` saat Simpan ditekan, serta contoh nilai yang ditolak.**

   `GlobalKey<FormState>` memberi akses ke `FormState` dari luar widget `Form`, sehingga tombol Simpan bisa memanggil `_formKey.currentState!.validate()`, dan juga `reset()` untuk mengosongkan form. `validator` adalah fungsi pada tiap field yang mengembalikan teks pesan kesalahan jika nilainya tidak valid, atau `null` jika valid. `validate()` menjalankan semua `validator` di dalam `Form`, menampilkan pesan pada field yang salah, dan mengembalikan `true` hanya jika semuanya lolos. Dialog ringkasan baru ditampilkan setelah itu. Contoh nilai yang ditolak: Nama Institusi yang hanya berisi spasi (ditolak karena `trim()` menjadikannya kosong), IPK `5` (di luar 0.00 sampai 4.00), dan Tanggal Selesai yang lebih awal dari Tanggal Mulai. Memilih jenis input atau papan ketik saja belum cukup: `numberWithOptions` pada kolom IPK hanya mengatur papan ketik dan di Chrome pengguna tetap bisa mengetik atau menempelkan teks apa saja, sedangkan date picker tidak tahu bahwa tanggal selesai harus sesudah tanggal mulai. Aturan semacam itu hanya bisa dijaga oleh `validator`.