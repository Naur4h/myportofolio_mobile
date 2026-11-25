import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Kartu tombol pada halaman utama.
class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key});

  final ItemHomepage item;

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: item.color,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _onTap(BuildContext context) async {
    switch (item.name) {
      case 'Lihat Proyek':
        _showSnack(context, 'Kamu telah menekan tombol ${item.name}!');
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const ProjectListScreen()),
        );
        break;
      case 'Tambah Proyek':
        final loggedIn = await ensureLoggedIn(context);
        if (!loggedIn || !context.mounted) return;
        _showSnack(context, 'Kamu telah menekan tombol ${item.name}!');
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const ProjectFormPage()),
        );
        break;
      case 'Tambah Education':
        _showSnack(context, 'Kamu telah menekan tombol ${item.name}!');
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const EducationFormPage()),
        );
        break;
      case 'Logout':
        final auth = context.read<AuthState>();
        if (!auth.isLoggedIn) {
          _showSnack(context, 'Kamu belum login.');
          return;
        }
        try {
          await auth.logout();
          if (!context.mounted) return;
          _showSnack(context, 'Logout berhasil.');
        } on Object {
          if (!context.mounted) return;
          _showSnack(
            context,
            'Sesi lokal dihapus, tetapi request logout gagal.',
          );
        }
        break;
      default:
        _showSnack(context, 'Kamu telah menekan tombol ${item.name}!');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _onTap(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30),
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
