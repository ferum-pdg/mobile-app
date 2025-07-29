import 'package:flutter/material.dart';

class InfoSectionCard extends StatelessWidget {

  final List<MapEntry<String, String>> fields;

  const InfoSectionCard({
    super.key,
    required this.fields
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),                                
      ),
      child: Column(
        children: fields
            .map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black)),
                      Text(entry.value,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}