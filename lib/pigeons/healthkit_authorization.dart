import 'package:pigeon/pigeon.dart';

// Pigeon API to handle iOS HealthKit authorization requests
@HostApi()
abstract class HealthKitAuthorization {
  // Ask the user for HealthKit permission; resolves to true if granted
  @async
  bool requestAuthorization();
}
