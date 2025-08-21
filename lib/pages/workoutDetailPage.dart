import 'package:ferum/models/enum.dart';
import 'package:flutter/material.dart';

import '../models/workout.dart';

const kBlue = Color(0xFF3B82F6); // App primary blue
const kPurple = Color(0xFF8B5CF6); // App accent purple

class WorkoutDetailPage extends StatelessWidget {
  final WorkoutClass workout;
  const WorkoutDetailPage({super.key, required this.workout});

  String _formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0 && m > 0) return '${h}h ${m}min';
    if (h > 0) return '${h}h';
    return '${m}min';
  }

  String _formatDistance(num? value, workoutSport sport) {
    if (value == null) return '-';
    // Heuristic: swimming shown in meters, others in km
    if (sport == workoutSport.SWIMMING) {
      return '${value.toStringAsFixed(0)} m';
    }
    final km = value.toDouble();
    if (km >= 20) return '${km.toStringAsFixed(0)} km';
    return '${km.toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    // Assume durationSec is expressed in minutes for display
    final durationMinutes = (workout.durationSec is int)
        ? workout.durationSec as int
        : (workout.durationSec ?? 0).toInt();

    return Scaffold(
      appBar: AppBar(title: Text(workout.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.fitness_center, color: kBlue),
                        const SizedBox(width: 8),
                        Text(
                          workout.workoutType.toString().split('.').last,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Chip(
                          label: Text(
                            workout.workoutSport.toString().split('.').last,
                          ),
                          backgroundColor: kPurple.withOpacity(0.1),
                          labelStyle: const TextStyle(color: kPurple),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          workout.day != null
                              ? 'Jour: ${workout.day}'
                              : 'Jour: —',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Durée: ' + _formatDuration(durationMinutes),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.directions_run,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Distance: ' +
                              _formatDistance(
                                workout.distanceMeters,
                                workout.workoutSport,
                              ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              // --- Étapes (aperçu statique) ---
              _WorkoutStepsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutStepsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _StepBlock(
          number: 1,
          children: [
            _MiniCard(
              title: '15 min à 6:34 - 7:04\'/km',
              tag: 'Allure EF',
              tagColor: kBlue,
            ),
          ],
        ),
        SizedBox(height: 16),
        _StepBlock(
          number: 2,
          sideBadges: [
            _SideBadge(text: '7x', color: kPurple),
            _SideBadge(icon: Icons.autorenew, color: kPurple),
          ],
          children: [
            _MiniCard(
              title: '3 min à 5:09/km',
              tag: 'Allure Seuil 60',
              tagColor: kPurple,
            ),
            SizedBox(height: 8),
            _MiniCard(
              title: '1:30 min de récup.',
              tag: 'Allure Lent',
              tagColor: kPurple,
            ),
          ],
        ),
        SizedBox(height: 16),
        _StepBlock(
          number: 3,
          children: [
            _MiniCard(
              title: '5 min de récup. à 6:34 - 7:04\'/km',
              tag: 'Allure EF',
              tagColor: kBlue,
            ),
          ],
        ),
      ],
    );
  }
}

class _StepBlock extends StatelessWidget {
  final int number;
  final List<Widget> children;
  final List<_SideBadge>? sideBadges;
  const _StepBlock({
    required this.number,
    required this.children,
    this.sideBadges,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CircleNumber(number: number),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
        if (sideBadges != null && sideBadges!.isNotEmpty) ...[
          const SizedBox(width: 12),
          Column(children: sideBadges!),
        ],
      ],
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String title;
  final String tag;
  final Color tagColor;
  const _MiniCard({
    required this.title,
    required this.tag,
    required this.tagColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          _TagBadge(text: tag, color: tagColor),
        ],
      ),
    );
  }
}

class _TagBadge extends StatelessWidget {
  final String text;
  final Color color;
  const _TagBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.55)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _CircleNumber extends StatelessWidget {
  final int number;
  const _CircleNumber({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(color: kBlue, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SideBadge extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Color color;
  const _SideBadge({this.text, this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: text != null
          ? Text(
              text!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            )
          : Icon(icon, color: Colors.white, size: 18),
    );
  }
}
