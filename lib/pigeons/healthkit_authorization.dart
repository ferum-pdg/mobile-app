import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class HealthKitAuthorization {
  /// Demande explicitement l'autorisation HealthKit.
  /// Retourne un Future<bool> en Dart.
  @async
  bool requestAuthorization();
}
