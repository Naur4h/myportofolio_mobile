import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Halaman formulir untuk menambah data pendidikan (Education).
///
/// Fitur utama:
/// - Input teks, dropdown, dan date picker untuk atribut pendidikan.
/// - Validasi tiap field (tidak boleh kosong/spasi saja, batas panjang,
///   urutan tanggal, rentang IPK).
/// - Switch "Masih berkuliah" yang menonaktifkan Tanggal Selesai.
/// - Validasi langsung saat pengguna berinteraksi (autovalidateMode).
/// - Dialog ringkasan setelah semua input lolos validasi.
class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  /// Kunci untuk mengakses state Form: validate() dan reset().
  final _formKey = GlobalKey<FormState>();

  /// Kunci khusus field Tanggal Selesai, supaya field ini bisa divalidasi
  /// ulang sendiri saat Tanggal Mulai berubah (tanpa memicu field lain).
  final _endFieldKey = GlobalKey<FormFieldState<String>>();

  /// Controller field tanggal: teksnya diisi lewat date picker, bukan diketik.
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  String _institution = "";
  String _level = "S1";
  String _major = "";
  String _gpa = "";
  DateTime? _startDate;
  DateTime? _endDate;

  /// True jika pengguna masih berkuliah (tidak ada tanggal selesai).
  bool _isOngoing = false;

  final List<String> _levels = ['SMA/SMK', 'D3', 'S1', 'S2', 'S3'];

  @override
  void dispose() {
    // Controller wajib dibuang agar tidak terjadi kebocoran memori.
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  /// Mengubah DateTime menjadi teks dd/MM/yyyy.
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  /// Menampilkan date picker untuk tanggal mulai ([isStart] true)
  /// atau tanggal selesai ([isStart] false).
  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = picked;
        _startController.text = _formatDate(picked);
      } else {
        _endDate = picked;
        _endController.text = _formatDate(picked);
      }
    });

    // Jika tanggal mulai berubah dan tanggal selesai sudah terisi,
    // cek ulang urutan tanggalnya.
    if (isStart && _endController.text.isNotEmpty) {
      _endFieldKey.currentState?.validate();
    }
  }

  /// Mengosongkan form dan semua variabel penampung.
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _institution = "";
      _level = "S1";
      _major = "";
      _gpa = "";
      _startDate = null;
      _endDate = null;
      _isOngoing = false;
      _startController.clear();
      _endController.clear();
    });
  }

  /// Menampilkan ringkasan isian dalam dialog.
  void _showSummary() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Data pendidikan berhasil disimpan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Institusi: $_institution'),
                Text('Jenjang: $_level'),
                Text('Jurusan: $_major'),
                Text('Tanggal Mulai: ${_startController.text}'),
                Text(
                  'Tanggal Selesai: '
                  '${_isOngoing ? "Sekarang" : _endController.text}',
                ),
                Text('IPK: ${_gpa.trim().isEmpty ? "-" : _gpa.trim()}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Add Education Form'),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        // Error muncul langsung setelah pengguna menyentuh sebuah field,
        // tanpa harus menekan Simpan lebih dulu.
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // SingleChildScrollView agar form bisa digulir saat layar sempit
        // atau saat papan ketik tampil.
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Nama Institusi ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: 100, // menampilkan penghitung karakter
                  decoration: InputDecoration(
                    hintText: "Contoh: Universitas Indonesia",
                    labelText: "Nama Institusi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _institution = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama institusi tidak boleh kosong!";
                    }
                    if (value.trim().length > 100) {
                      return "Nama institusi maksimal 100 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Jenjang ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Jenjang",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _level,
                  items: _levels
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _level = newValue!;
                    });
                  },
                ),
              ),

              // === Jurusan ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: 100,
                  decoration: InputDecoration(
                    hintText: "Contoh: Ilmu Komputer",
                    labelText: "Jurusan / Program Studi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _major = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Jurusan tidak boleh kosong!";
                    }
                    if (value.trim().length > 100) {
                      return "Jurusan maksimal 100 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tanggal Mulai ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _startController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Pilih tanggal mulai",
                    labelText: "Tanggal Mulai",
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onTap: () => _pickDate(isStart: true),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Tanggal mulai harus dipilih!";
                    }
                    return null;
                  },
                ),
              ),

              // === Switch: masih berkuliah ===
              SwitchListTile(
                title: const Text("Masih berkuliah di sini"),
                subtitle: const Text("Tanggal selesai tidak perlu diisi"),
                value: _isOngoing,
                activeThumbColor: Colors.indigo,
                onChanged: (bool value) {
                  setState(() {
                    _isOngoing = value;
                    if (value) {
                      // Hapus tanggal selesai lama agar tidak ikut tersimpan.
                      _endDate = null;
                      _endController.clear();
                    }
                  });
                  // Hilangkan pesan error lama pada field Tanggal Selesai.
                  _endFieldKey.currentState?.reset();
                },
              ),

              // === Tanggal Selesai ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: _endFieldKey,
                  controller: _endController,
                  readOnly: true,
                  enabled: !_isOngoing, // nonaktif jika masih berkuliah
                  decoration: InputDecoration(
                    hintText: _isOngoing ? "Sekarang" : "Pilih tanggal selesai",
                    labelText: "Tanggal Selesai",
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onTap: () => _pickDate(isStart: false),
                  validator: (String? value) {
                    // Jika masih berkuliah, tanggal selesai tidak diperlukan.
                    if (_isOngoing) return null;
                    if (value == null || value.isEmpty) {
                      return "Tanggal selesai harus dipilih!";
                    }
                    if (_startDate != null &&
                        _endDate != null &&
                        _endDate!.isBefore(_startDate!)) {
                      return "Tanggal selesai tidak boleh sebelum tanggal mulai!";
                    }
                    return null;
                  },
                ),
              ),

              // === IPK (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: "Contoh: 3.75 (opsional)",
                    labelText: "IPK",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _gpa = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return null; // IPK opsional
                    }
                    final gpa =
                        double.tryParse(value.trim().replaceAll(',', '.'));
                    if (gpa == null) {
                      return "IPK harus berupa angka!";
                    }
                    if (gpa < 0 || gpa > 4) {
                      return "IPK harus antara 0.00 dan 4.00!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      // validate() menjalankan semua validator di dalam Form.
                      if (_formKey.currentState!.validate()) {
                        _showSummary();
                      }
                    },
                    child: const Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}