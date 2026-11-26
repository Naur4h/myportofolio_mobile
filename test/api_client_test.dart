import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  group('ApiClient Experience', () {
    test('getExperiences parses a public JSON list', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/experience/');
        expect(request.url.queryParameters['title'], 'Intern');
        return http.Response(
          jsonEncode([
            {
              'id': 'f67a0c6f-6434-4afe-98d6-ec0aec0444d0',
              'title': 'Mobile Intern',
              'description': 'Built Flutter features.',
              'category': 'internship',
              'category_display': 'Internship',
              'thumbnail': null,
              'started_at': '2026-01-02T03:04:05Z',
              'ended_at': null,
              'is_ongoing': true,
              'star_count': 3,
              'is_starred': false,
              'starred_by_names': 'Ayu',
            },
          ]),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final api = ApiClient(client: mockClient, baseUrl: 'http://api.test/');

      final experiences = await api.getExperiences(title: ' Intern ');

      expect(experiences, hasLength(1));
      expect(experiences.single.id, 'f67a0c6f-6434-4afe-98d6-ec0aec0444d0');
      expect(experiences.single.categoryDisplay, 'Internship');
      expect(experiences.single.isOngoing, isTrue);
      expect(experiences.single.starredByNames, 'Ayu');
      expect(experiences.single.thumbnail, isNull);
      mockClient.close();
    });

    test('createExperience sends token authorization header', () async {
      late http.Request sentRequest;
      final mockClient = MockClient((request) async {
        sentRequest = request;
        return http.Response(
          jsonEncode({
            'id': '53d3fd25-6014-491b-bb2e-2293792c1bf8',
            'title': 'Research Assistant',
            'description': 'Studied crop recommendations.',
            'category': 'research',
            'category_display': 'Research',
            'thumbnail': null,
            'started_at': '2026-01-02T03:04:05Z',
            'ended_at': null,
            'is_ongoing': true,
            'star_count': 0,
            'is_starred': false,
            'starred_by_names': '',
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      });
      final api = ApiClient(client: mockClient, baseUrl: 'http://api.test');

      final created = await api.createExperience(
        const Experience(
          title: 'Research Assistant',
          description: 'Studied crop recommendations.',
          category: 'research',
        ),
        token: 'sample-token',
      );

      expect(sentRequest.method, 'POST');
      expect(sentRequest.headers['authorization'], 'Token sample-token');
      expect(sentRequest.headers['accept'], 'application/json');
      expect(sentRequest.url.path, '/api/v1/experience/');
      final payload = jsonDecode(sentRequest.body) as Map<String, dynamic>;
      expect(payload['title'], 'Research Assistant');
      expect(payload['category'], 'research');
      expect(payload.containsKey('id'), isFalse);
      expect(payload.containsKey('started_at'), isFalse);
      expect(created.id, '53d3fd25-6014-491b-bb2e-2293792c1bf8');
      mockClient.close();
    });

    test(
      'converts detail and field errors into readable ApiException',
      () async {
        final unauthorizedClient = MockClient(
          (_) async => http.Response(
            jsonEncode({
              'detail': 'Authentication credentials were not provided.',
            }),
            401,
          ),
        );
        final unauthorizedApi = ApiClient(
          client: unauthorizedClient,
          baseUrl: 'http://api.test',
        );

        await expectLater(
          unauthorizedApi.createExperience(
            const Experience(title: 'Work', description: 'Description'),
            token: 'expired-token',
          ),
          throwsA(
            isA<ApiException>()
                .having((error) => error.statusCode, 'statusCode', 401)
                .having(
                  (error) => error.message,
                  'message',
                  'Authentication credentials were not provided.',
                ),
          ),
        );
        unauthorizedClient.close();

        final invalidClient = MockClient(
          (_) async => http.Response(
            jsonEncode({
              'title': ['This field is required.'],
              'thumbnail': ['Enter a valid URL.'],
            }),
            400,
          ),
        );
        final invalidApi = ApiClient(
          client: invalidClient,
          baseUrl: 'http://api.test',
        );

        await expectLater(
          invalidApi.createExperience(
            const Experience(title: 'Work', description: 'Description'),
            token: 'sample-token',
          ),
          throwsA(
            isA<ApiException>()
                .having((error) => error.statusCode, 'statusCode', 400)
                .having(
                  (error) => error.message,
                  'message',
                  'title: This field is required.\n'
                      'thumbnail: Enter a valid URL.',
                ),
          ),
        );
        invalidClient.close();
      },
    );
  });
}
