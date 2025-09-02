import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final String obscuringCharacter;
  final bool isDateField;

  const FormTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.obscuringCharacter = '*',
    this.isDateField = false,
  });

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        obscuringCharacter: widget.obscuringCharacter,
        style: const TextStyle(color: Colors.white),
        decoration: FormInputDecoration(label: widget.label).build(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer ${widget.label}';
          }
          return null;
        },
        onTap: widget.isDateField
            ? () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
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

class FormInputDecoration {
  final String label;

  FormInputDecoration({required this.label});

  InputDecoration build() {
    return InputDecoration(
      label: Text(label),
      labelStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.white12,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
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