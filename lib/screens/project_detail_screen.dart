import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';

/// Menampilkan detail satu proyek.
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final thumbnail = project.thumbnail.trim();
    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (thumbnail.isNotEmpty)
            Image.network(
              thumbnail,
              errorBuilder: (_, _, _) =>
                  const Text('Thumbnail tidak dapat dimuat.'),
            ),
          const SizedBox(height: 16),
          Text(project.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Tech stack: ${project.techStack}'),
          const SizedBox(height: 8),
          Text(project.description),
          if (project.codeUrl.isNotEmpty) ...[
            const SizedBox(height: 12),
            SelectableText('Code: ${project.codeUrl}'),
          ],
          if (project.demoUrl.isNotEmpty) ...[
            const SizedBox(height: 8),
            SelectableText('Demo: ${project.demoUrl}'),
          ],
        ],
      ),
    );
  }
}
