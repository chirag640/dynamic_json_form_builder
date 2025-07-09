import 'package:flutter/material.dart';
import 'package:dynamic_json_form_builder/dynamic_json_form_builder.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final fields = [
      {
        "key": "email",
        "type": "email",
        "label": "Email",
        "placeholder": "Enter your email",
        "required": true,
      },
      {
        "key": "gender",
        "type": "dropdown",
        "label": "Gender",
        "options": ["Male", "Female", "Other"],
        "placeholder": "Select your gender",
      },
    ];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Form Example')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: JsonFormBuilder(
            config: {"fields": fields},
            onChanged: (data) => print(data),
          ),
        ),
      ),
    );
  }
}
