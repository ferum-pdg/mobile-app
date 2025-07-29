import 'package:flutter/material.dart';
import 'package:health/health.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? steps = 0;
  double active_energy_burned = 0;
  double distance_walking_running = 0;
  int heart_rate_resting = 0;
  late final Health _health;

  @override
  void initState() {
    super.initState();
    _health = Health();
    getAppleHealth();
  }

  Future<void> getAppleHealth() async {
    //Récupère les valeurs que l'on souhaite on ne prend pas les pas ici
    List<HealthDataType> types = <HealthDataType>[
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.DISTANCE_WALKING_RUNNING,
      HealthDataType.RESTING_HEART_RATE,
    ];

    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day);

    // Demande d'autorisation
    final authorized = await _health.requestAuthorization(types);

    if (authorized) {
      final result = await _health.getHealthDataFromTypes(
        types: types,
        startTime: midnight,
        endTime: now,
      );

      //Récupère le total dédupliqué
      //int? totalSteps = await _health.getTotalStepsInInterval(midnight, now);
      double totalActive_energy_burned = 0;
      double totalDistance_walking_running = 0.0;
      int totalHeart_rate_resting = 0;

      //Récupère toutes les valeurs et les mets dans le bon format type.
      for (var point in result) {
        //Debug info
        /*print(
          '${point.type}-${point.value}-${point.dateFrom}-${point.dateTo}-${point.sourceName}',
        );*/
        if (point.value is NumericHealthValue) {
          //On additionne toutes les valeurs que l'on récupère afin d'avoir les totaux.
          switch (point.type) {
            case HealthDataType.ACTIVE_ENERGY_BURNED:
              totalActive_energy_burned +=
                  (point.value as NumericHealthValue).numericValue
                      ?.toDouble() ??
                  0;
              break;
            case HealthDataType.DISTANCE_WALKING_RUNNING:
              totalDistance_walking_running +=
                  (point.value as NumericHealthValue).numericValue
                      ?.toDouble() ??
                  0.0;
              break;
            case HealthDataType.RESTING_HEART_RATE:
              totalHeart_rate_resting +=
                  (point.value as NumericHealthValue).numericValue?.toInt() ??
                  0;
              break;
            default:
              break;
          }
        }
      }
      //on met les valeurs disponible pour le reste de l'application
      setState(() {
        //steps = totalSteps;
        active_energy_burned = totalActive_energy_burned;
        //distance récupérée en mêtre on le passe en km
        distance_walking_running = totalDistance_walking_running / 1000;
        heart_rate_resting = totalHeart_rate_resting;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Bonjour Alex',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Votre activité aujourd'hui",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              // Les 4 "carrés"
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2, // 2 colonnes
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    InfoCard(title: '$steps', subtitle: "Pas aujourd'hui"),
                    InfoCard(
                      //Convertit les calories en Int afin de pas avoir de chiffre après la virgule.
                      title: '${active_energy_burned.toInt()}',
                      subtitle: "Calories",
                    ),
                    InfoCard(
                      //On affiche 1 digit après la virgule
                      title: distance_walking_running.toStringAsFixed(1),
                      subtitle: "Kilomètres",
                    ),
                    InfoCard(
                      title: '$heart_rate_resting',
                      subtitle: "BPM repos",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const InfoCard({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
