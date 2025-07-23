import 'package:flutter/material.dart';
import 'package:health/health.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steps Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Steps Counter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _steps = 0;
  late final Health _health;

  @override
  void initState() {
    super.initState();
    _health = Health();
    fetchSteps();
  }

  Future<void> fetchSteps() async {
    List<HealthDataType> types = <HealthDataType>[HealthDataType.STEPS];

    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day);

    // Demande d'autorisation (plus besoin du Map)
    final authorized = await _health.requestAuthorization(types);

    if (authorized) {
      final result = await _health.getHealthDataFromTypes(
        types: types,
        startTime: midnight,
        endTime: now,
      );

      int totalSteps = 0;
      for (var point in result) {
        if (point.value is NumericHealthValue) {
          totalSteps +=
              (point.value as NumericHealthValue).numericValue?.toInt() ?? 0;
        }
      }

      setState(() {
        _steps = totalSteps;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Nombre de pas aujourd'hui :"),
            Text('$_steps', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
