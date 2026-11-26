import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';

/// Membuka form terlindungi, lalu menampilkan daftar baru setelah penyimpanan.
Future<void> openExperienceForm(BuildContext context) async {
  final loggedIn = await ensureLoggedIn(context);
  if (!loggedIn || !context.mounted) return;

  final created = await Navigator.push<bool>(
    context,
    MaterialPageRoute<bool>(builder: (_) => const ExperienceFormPage()),
  );
  if (created != true || !context.mounted) return;

  Navigator.push(
    context,
    MaterialPageRoute<void>(builder: (_) => const ExperienceListScreen()),
  );
}
