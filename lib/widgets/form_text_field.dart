import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Reusable text field with optional password mode and built-in date picker support

class FormTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final String obscuringCharacter;
  final bool isDateField;
  final Color color;
  final Color fillColor;

  const FormTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.obscuringCharacter = '*',
    this.isDateField = false,
    this.color = Colors.white,
    this.fillColor = Colors.white12,
  });

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      // Core input field; styling and behavior come from widget props and FormInputDecoration
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        // Enable password-style obscuring when requested
        obscureText: widget.obscureText,
        obscuringCharacter: widget.obscuringCharacter,
        style: TextStyle(color: widget.color),
        decoration: FormInputDecoration(
          label: widget.label,
          fillColor: widget.fillColor,
        ).build(),
        validator: (value) {
          // Basic required-field validation (message is in French and uses the provided label)
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer ${widget.label}';
          }
          return null;
        },
        // If this field represents a date, open a date picker and write the selected value in ISO (yyyy-MM-dd)
        onTap: widget.isDateField
            ? () async {
                // Native date picker bounded between 1900 and today
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  String formattedDate = DateFormat(
                    'yyyy-MM-dd',
                  ).format(pickedDate);
                  // Persist the formatted date into the controller so the form shows the selection
                  setState(() {
                    widget.controller.text = formattedDate;
                  });
                }
              }
            : null,
      ),
    );
  }
}

// Centralized decoration builder to keep all text fields visually consistent
class FormInputDecoration {
  final String label;
  final Color fillColor;

  FormInputDecoration({required this.label, this.fillColor = Colors.white12});

  InputDecoration build() {
    return InputDecoration(
      label: Text(label),
      // Ensure label remains readable over colored backgrounds
      labelStyle: const TextStyle(color: Colors.white),
      // Filled style with custom background color for contrast on dark UIs
      filled: true,
      fillColor: fillColor,
      // Rounded 30px corners and consistent white borders
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(30),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
