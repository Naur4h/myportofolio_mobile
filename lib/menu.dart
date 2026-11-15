import 'package:flutter/material.dart';

/// Halaman utama portofolio: kartu identitas dan kisi tombol aksi.
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = "2506657163";
  final String nama = "Naurah Claradinda";
  final String kelas = "PBP A";

  final List<ItemHomepage> items = [
    ItemHomepage("Lihat Proyek", Icons.folder, Colors.blue),
    ItemHomepage("Tambah Proyek", Icons.add_circle, Colors.green),
    ItemHomepage("Lihat Skills", Icons.star, Colors.purple),
    ItemHomepage("Lihat Education", Icons.school, Colors.teal),
    ItemHomepage("Logout", Icons.logout, Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur visual dasar halaman (AppBar, Body, SnackBar).
    return Scaffold(
      // AppBar menampilkan bar bagian atas halaman aplikasi.
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      // Body halaman utama: dapat digulir, lebarnya dibatasi, dan diberi padding.
      body: SingleChildScrollView(
        // Membuat halaman dapat digulir agar tidak overflow pada layar yang pendek.
        child: Center(
          // Memusatkan konten secara horizontal pada layar lebar.
          child: ConstrainedBox(
            // Membatasi lebar maksimum agar tampilan menyerupai layar ponsel.
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Baris horizontal untuk menampilkan 3 InfoCard secara sejajar.
                  // Expanded membagi lebar baris secara rata ke tiga kartu.
                  Row(
                    children: [
                      Expanded(child: InfoCard(title: 'NPM', content: npm)),
                      Expanded(child: InfoCard(title: 'Name', content: nama)),
                      Expanded(child: InfoCard(title: 'Class', content: kelas)),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Bagian tengah: pesan sambutan dan kisi tombol menu portofolio.
                  Center(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Selamat datang di MyPortfolio Mobile!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        // GridView menampilkan kartu tombol dalam kisi 3 kolom.
                        GridView.count(
                          padding: const EdgeInsets.all(20),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 3,
                          // shrinkWrap agar tinggi kisi menyesuaikan isi anak.
                          shrinkWrap: true,
                          // Kisi tidak menggulir sendiri; yang menggulir halaman luar.
                          physics: const NeverScrollableScrollPhysics(),
                          children: items.map((ItemHomepage item) {
                            return ItemCard(item);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Kartu kecil yang menampilkan satu pasang judul dan isi, misalnya NPM.
class InfoCard extends StatelessWidget {
  // Kartu informasi yang menampilkan judul (title) dan isi (content).
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Memberikan efek bayangan kartu elevasi 2 unit.
      elevation: 2.0,
      child: Container(
        // Lebar kartu ditentukan oleh Expanded pada Row induknya.
        padding: const EdgeInsets.all(16.0),
        // Menyusun teks title dan content secara vertikal.
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(content),
          ],
        ),
      ),
    );
  }
}

/// Model data satu tombol menu: nama, ikon, dan warna latarnya.
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}

/// Kartu tombol yang dapat ditekan; menampilkan SnackBar sesuai nama item.
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // Warna latar kartu diambil dari atribut color pada item.
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        // Aksi ketika kartu ditekan oleh pengguna.
        onTap: () {
          // Menampilkan SnackBar dengan pesan interaktif.
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!"),
                backgroundColor: item.color,
                behavior: SnackBarBehavior.floating,
              ),
            );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}