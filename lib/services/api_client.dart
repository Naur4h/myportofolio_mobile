import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'API $statusCode: $message';
}

/// Mengirim request HTTP ke Django REST Framework.
class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Uri _uri(String path) {
    final base = baseUrl.replaceFirst(RegExp(r'/$'), '');
    return Uri.parse('$base$path');
  }

  Map<String, String> _headers({String? token}) => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Token $token',
  };

  Never _throwFor(http.Response response) {
    var message = response.body;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final detail = decoded['detail'];
        if (detail != null) {
          message = detail.toString();
        } else {
          final fieldErrors = decoded.entries
              .map((entry) {
                final value = entry.value;
                final description = value is List
                    ? value.map((item) => item.toString()).join(' ')
                    : value.toString();
                return '${entry.key}: $description';
              })
              .join('\n');
          if (fieldErrors.isNotEmpty) message = fieldErrors;
        }
      }
    } on FormatException {
      // Gunakan response mentah bila server tidak mengirim JSON.
    }
    throw ApiException(response.statusCode, message);
  }

  Future<List<Project>> getProjects() async {
    final response = await _client.get(
      _uri('/api/v1/projects/'),
      headers: const {'Accept': 'application/json'},
    );
    if (response.statusCode != 200) _throwFor(response);

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException('Respons proyek bukan JSON array.');
    }
    return decoded
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _client.post(
      _uri('/api/v1/projects/'),
      headers: {
        ..._headers(token: token),
        'Accept': 'application/json',
      },
      body: jsonEncode(project.toJson()),
    );
    if (response.statusCode != 201) _throwFor(response);
    return Project.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<String> obtainToken(String username, String password) async {
    final response = await _client.post(
      _uri('/api/v1/auth/token/'),
      headers: _headers(),
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode != 200) _throwFor(response);
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return decoded['token'] as String;
  }

  Future<void> logout({required String token}) async {
    final response = await _client.post(
      _uri('/api/v1/auth/logout/'),
      headers: _headers(token: token),
    );
    if (response.statusCode != 204) _throwFor(response);
  }

  /// Mengambil daftar Experience publik, opsional difilter berdasarkan judul.
  Future<List<Experience>> getExperiences({String? title}) async {
    var uri = _uri('/api/v1/experience/');
    final query = title?.trim() ?? '';
    if (query.isNotEmpty) {
      uri = uri.replace(queryParameters: {'title': query});
    }

    final response = await _client.get(
      uri,
      headers: const {'Accept': 'application/json'},
    );
    if (response.statusCode != 200) _throwFor(response);

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException('Respons experience bukan JSON array.');
    }
    return decoded
        .map((item) => Experience.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Menambahkan Experience dengan token pengguna.
  Future<Experience> createExperience(
    Experience experience, {
    required String token,
  }) async {
    final response = await _client.post(
      _uri('/api/v1/experience/'),
      headers: {
        ..._headers(token: token),
        'Accept': 'application/json',
      },
      body: jsonEncode(experience.toJson()),
    );
    if (response.statusCode != 201) _throwFor(response);
    return Experience.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
