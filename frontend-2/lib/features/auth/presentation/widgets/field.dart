import 'package:flutter/material.dart';

typedef OnChanged = void Function(String value);

class Field extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final OnChanged onChanged;
  const Field(
      {super.key,
      required this.hint,
      required this.controller,
      required this.onChanged});

  @override
  _FieldState createState() => _FieldState();
}

class _FieldState extends State<Field> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextFormField(
        controller: widget.controller,
        cursorColor: Theme.of(context).colorScheme.primary,
        style: TextStyle(
          fontSize: 24,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          label: Text(
            widget.hint,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 24,
                ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2,
            ),
          ),
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
        ),
        onChanged: (value) {
          setState(() {
            widget.onChanged(value);
          });
        },
      ),
    );
  }
}
