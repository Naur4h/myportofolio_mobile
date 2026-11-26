import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';

/// Menampilkan field respons Experience.
class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({super.key, required this.experience});

  final Experience experience;

  String _formatDate(DateTime? value) {
    if (value == null) return '-';
    final date = value.toLocal();
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final thumbnail = experience.thumbnail?.trim() ?? '';
    final names = experience.starredByNames;
    return Scaffold(
      appBar: AppBar(title: Text(experience.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (thumbnail.isEmpty)
            const Text('Thumbnail: tidak tersedia')
          else
            Image.network(
              thumbnail,
              errorBuilder: (_, _, _) =>
                  const Text('Thumbnail tidak dapat dimuat.'),
            ),
          const SizedBox(height: 16),
          Text('ID: ${experience.id ?? '-'}'),
          const SizedBox(height: 8),
          Text(
            experience.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(experience.description),
          const SizedBox(height: 8),
          Text(
            'Kategori: ${experience.categoryDisplay.isEmpty ? experience.category : experience.categoryDisplay}',
          ),
          const SizedBox(height: 8),
          Text('Mulai: ${_formatDate(experience.startedAt)}'),
          const SizedBox(height: 8),
          Text(
            'Selesai: ${experience.isOngoing ? 'Sekarang' : _formatDate(experience.endedAt)}',
          ),
          const SizedBox(height: 8),
          Text(
            'Status: ${experience.isOngoing ? 'Masih berlangsung' : 'Selesai'}',
          ),
          const SizedBox(height: 8),
          Text('Jumlah bintang: ${experience.starCount}'),
          const SizedBox(height: 8),
          Text(
            'Bintang dari akun ini: ${experience.isStarred ? 'Ya' : 'Belum'}',
          ),
          const SizedBox(height: 8),
          Text(
            'Diberi bintang oleh: ${names.isEmpty ? '-' : names.join(', ')}',
          ),
        ],
      ),
    );
  }
}
