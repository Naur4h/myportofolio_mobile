/// Default untuk emulator Android.
/// Untuk Chrome, gunakan --dart-define=API_BASE_URL=http://localhost:8000.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);
