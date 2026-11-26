import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_detail_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Menampilkan Experience publik dari API.
class ExperienceListScreen extends StatefulWidget {
  const ExperienceListScreen({super.key});

  @override
  State<ExperienceListScreen> createState() => _ExperienceListScreenState();
}

class _ExperienceListScreenState extends State<ExperienceListScreen> {
  late Future<List<Experience>> _experiencesFuture;

  @override
  void initState() {
    super.initState();
    _experiencesFuture = context.read<ApiClient>().getExperiences();
  }

  Future<void> _reload() async {
    final request = context.read<ApiClient>().getExperiences();
    setState(() => _experiencesFuture = request);
    try {
      await request;
    } on Object {
      // FutureBuilder menampilkan error beserta tombol Retry.
    }
  }

  Future<void> _openDetail(Experience experience) async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => ExperienceDetailScreen(experience: experience),
      ),
    );
    if (created == true) await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experience'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<Experience>>(
        future: _experiencesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Gagal memuat Experience: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final experiences = snapshot.data ?? const <Experience>[];
          if (experiences.isEmpty) {
            return RefreshIndicator(
              onRefresh: _reload,
              child: const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 300,
                  child: Center(child: Text('Belum ada Experience.')),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: experiences.length,
              itemBuilder: (context, index) {
                final experience = experiences[index];
                return Card(
                  child: ListTile(
                    title: Text(experience.title),
                    subtitle: Text(
                      '${experience.categoryDisplay.isEmpty ? experience.category : experience.categoryDisplay}\n${experience.description}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,
                    onTap: () => _openDetail(experience),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
