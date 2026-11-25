/// URL backend. Chrome memakai localhost melalui --dart-define.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8000',
);
