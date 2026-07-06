/// Central API configuration for local development and Render production.
///
/// Workflow:
/// 1. Set [useLocalBackend] = `true` → test against `npm start` on your Mac
/// 2. Set [useLocalBackend] = `false` → use Render (production / deployed APIs)
/// 3. After backend changes, deploy to Render (see backend README)
class ApiConfig {
  /// `true` = local backend, `false` = Render production
  static const bool useLocalBackend = false;

  static const String _localBaseUrl = 'http://localhost:10000/api';
  static const String _productionBaseUrl =
      'https://dental-backend-0e7e.onrender.com/api';

  static String get baseUrl =>
      useLocalBackend ? _localBaseUrl : _productionBaseUrl;

  static String get auth => '$baseUrl/auth';
  static String get patients => '$baseUrl/patients';
  static String get dentists => '$baseUrl/dentists';
  static String get appointments => '$baseUrl/appointments';
  static String get payments => '$baseUrl/payments';
  static String get attendance => '$baseUrl/attendance';
  static String get ourServices => '$baseUrl/ourservices';
  static String get packages => '$baseUrl/packages';
  static String get branches => '$baseUrl/branches';
  static String get enquiries => '$baseUrl/enquiries';
  static String get exportData => '$baseUrl/exportData';

  static String get environmentLabel =>
      useLocalBackend ? 'Local' : 'Render';
}
