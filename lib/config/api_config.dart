class ApiConfig {
  /// Change this to point at your backend.
  static const String baseUrl = 'https://breach-fog-list.ngrok-free.dev';

  static const Map<String, String> headers = {
    'ngrok-skip-browser-warning': 'true',
    'Content-Type': 'application/json',
  };
}
