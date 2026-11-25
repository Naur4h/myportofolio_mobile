import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Form tambah proyek sesuai field serializer Django.
class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _techStack = '';
  String _codeUrl = '';
  String _demoUrl = '';
  String _thumbnail = '';
  bool _isSubmitting = false;

  String? _required(String? value, String name) {
    if (value == null || value.trim().isEmpty) {
      return '$name tidak boleh kosong!';
    }
    return null;
  }

  String? _validateOptionalUrl(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    final valid =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return valid ? null : 'Masukkan URL http:// atau https:// yang valid.';
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;
    final token = context.read<AuthState>().token;
    if (token == null) return;

    setState(() => _isSubmitting = true);
    try {
      final created = await context.read<ApiClient>().createProject(
        Project(
          title: _title.trim(),
          description: _description.trim(),
          techStack: _techStack.trim(),
          codeUrl: _codeUrl.trim(),
          demoUrl: _demoUrl.trim(),
          thumbnail: _thumbnail.trim(),
        ),
        token: token,
      );
      if (!mounted) return;
      await _showSuccess(created);
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        try {
          await context.read<AuthState>().logout();
        } on Object {
          // AuthState tetap menghapus token lokal pada finally.
        }
        if (!mounted) return;
        _showSnack('Sesi berakhir. Silakan login kembali.');
        await ensureLoggedIn(context);
      } else if (error.statusCode == 403) {
        _showSnack('Akun ini tidak diizinkan menambah proyek (403).');
      } else {
        _showSnack('Gagal menyimpan proyek (${error.statusCode}).');
      }
    } on Object {
      if (!mounted) return;
      _showSnack('Tidak dapat terhubung ke server.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _showSuccess(Project created) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Proyek berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Judul: ${created.title}'),
              Text('Deskripsi: ${created.description}'),
              Text('Tech Stack: ${created.techStack}'),
              Text(
                'Code URL: ${created.codeUrl.isEmpty ? "-" : created.codeUrl}',
              ),
              Text(
                'Demo URL: ${created.demoUrl.isEmpty ? "-" : created.demoUrl}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(dialogContext);
              _formKey.currentState!.reset();
              setState(() {
                _title = '';
                _description = '';
                _techStack = '';
                _codeUrl = '';
                _demoUrl = '';
                _thumbnail = '';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _field({
    required String label,
    required String hint,
    required ValueChanged<String> onChanged,
    FormFieldValidator<String>? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Project Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(
                label: 'Title',
                hint: 'Nama proyek',
                onChanged: (value) => _title = value,
                validator: (value) => _required(value, 'Title'),
              ),
              _field(
                label: 'Description',
                hint: 'Deskripsi proyek',
                maxLines: 5,
                onChanged: (value) => _description = value,
                validator: (value) => _required(value, 'Description'),
              ),
              _field(
                label: 'Tech Stack',
                hint: 'Contoh: Flutter, Django, Figma',
                onChanged: (value) => _techStack = value,
                validator: (value) => _required(value, 'Tech Stack'),
              ),
              _field(
                label: 'Code URL (opsional)',
                hint: 'https://github.com/...',
                onChanged: (value) => _codeUrl = value,
                validator: _validateOptionalUrl,
              ),
              _field(
                label: 'Demo URL (opsional)',
                hint: 'https://...',
                onChanged: (value) => _demoUrl = value,
                validator: _validateOptionalUrl,
              ),
              _field(
                label: 'Thumbnail URL (opsional)',
                hint: 'https://... (gambar)',
                onChanged: (value) => _thumbnail = value,
                validator: _validateOptionalUrl,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save',
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
