/// Build-time secrets via --dart-define. Do not commit real values.
///
/// Example:
/// flutter run --dart-define=GOOGLE_MAPS_API_KEY=your_key \
///   --dart-define=FIREBASE_ANDROID_API_KEY=your_firebase_key
class EnvConfig {
  static const String googleMapsApiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  static const String firebaseAndroidApiKey = String.fromEnvironment('FIREBASE_ANDROID_API_KEY');
}
