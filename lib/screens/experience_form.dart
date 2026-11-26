import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Formulir untuk mengirim Experience ke backend.
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _endedAtController = TextEditingController();

  static const _categories = [
    'internship',
    'research',
    'volunteer',
    'part-time',
    'full-time',
    'freelance',
  ];

  String _title = '';
  String _description = '';
  String _category = 'full-time';
  String _thumbnail = '';
  DateTime? _endedAt;
  bool _isOngoing = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _endedAtController.dispose();
    super.dispose();
  }

  String? _required(String? value, String label, {int? maxLength}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$label tidak boleh kosong.';
    if (maxLength != null && text.length > maxLength) {
      return '$label maksimal $maxLength karakter.';
    }
    return null;
  }

  String? _validateThumbnail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    if (uri == null ||
        !{'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty) {
      return 'Masukkan URL http:// atau https:// yang valid.';
    }
    if (text.length > 200) return 'URL thumbnail maksimal 200 karakter.';
    return null;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endedAt?.toLocal() ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      _endedAt = DateTime.utc(picked.year, picked.month, picked.day);
      _endedAtController.text = _formatDate(picked);
    });
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;
    final auth = context.read<AuthState>();
    final token = auth.token;
    if (token == null) return;

    setState(() => _isSaving = true);
    try {
      final created = await context.read<ApiClient>().createExperience(
        Experience(
          title: _title.trim(),
          description: _description.trim(),
          category: _category,
          thumbnail: _thumbnail.trim().isEmpty ? null : _thumbnail.trim(),
          endedAt: _isOngoing ? null : _endedAt,
        ),
        token: token,
      );
      if (!mounted) return;

      final returnToList = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Experience berhasil ditambahkan!'),
          content: Text('${created.title} berhasil disimpan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Kembali ke daftar'),
            ),
          ],
        ),
      );
      if (returnToList == true && mounted) Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        try {
          await auth.logout();
        } on Object {
          // Token lokal tetap dihapus oleh AuthState.logout().
        }
        if (!mounted) return;
        _showSnack('Sesi berakhir. Silakan login kembali.');
        await ensureLoggedIn(context);
      } else if (error.statusCode == 403) {
        _showSnack('Akun ini tidak diizinkan menambah Experience (403).');
      } else {
        _showSnack('Gagal menyimpan Experience: ${error.message}');
      }
    } on Object {
      if (!mounted) return;
      _showSnack('Tidak dapat terhubung ke server.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Experience'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  maxLength: 255,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Contoh: Software Engineering Intern',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onChanged: (value) => _title = value,
                  validator: (value) =>
                      _required(value, 'Title', maxLength: 255),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Ceritakan pengalaman ini',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onChanged: (value) => _description = value,
                  validator: (value) => _required(value, 'Description'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  maxLength: 200,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: 'Thumbnail URL (opsional)',
                    hintText: 'https://example.com/image.jpg',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onChanged: (value) => _thumbnail = value,
                  validator: _validateThumbnail,
                ),
              ),
              SwitchListTile(
                title: const Text('Masih berlangsung'),
                subtitle: const Text('Tanggal selesai dikosongkan'),
                value: _isOngoing,
                activeThumbColor: Colors.indigo,
                onChanged: (value) {
                  setState(() {
                    _isOngoing = value;
                    if (value) {
                      _endedAt = null;
                      _endedAtController.clear();
                    }
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _endedAtController,
                  readOnly: true,
                  enabled: !_isOngoing,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Selesai',
                    hintText: _isOngoing ? 'Sekarang' : 'Pilih tanggal',
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onTap: _isOngoing ? null : _pickEndDate,
                  validator: (value) {
                    if (_isOngoing) return null;
                    if (value == null || value.trim().isEmpty) {
                      return 'Pilih tanggal selesai atau aktifkan masih berlangsung.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.indigo),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
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
