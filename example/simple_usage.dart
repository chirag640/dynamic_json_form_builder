import 'package:flutter/material.dart';
import '../lib/json_form_builder.dart';

class SimpleUsageExample extends StatefulWidget {
  const SimpleUsageExample({super.key});

  @override
  State<SimpleUsageExample> createState() => _SimpleUsageExampleState();
}

class _SimpleUsageExampleState extends State<SimpleUsageExample> {
  final Map<String, dynamic> _formData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Usage Example'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Example 1: Simple JSON config
            Expanded(
              child: JsonFormBuilder(
                config: {
                  "id": "simple_form",
                  "title": "Contact Form",
                  "description": "Fill out this simple contact form",
                  "sections": [
                    {
                      "id": "contact_info",
                      "title": "Contact Information",
                      "collapsible": true,
                      "fields": [
                        {
                          "key": "name",
                          "type": "text",
                          "label": "Full Name",
                          "placeholder": "Enter your full name...",
                          "required": true
                        },
                        {
                          "key": "email",
                          "type": "email",
                          "label": "Email",
                          "placeholder": "your.email@example.com",
                          "required": true
                        },
                        {
                          "key": "phone",
                          "type": "text",
                          "label": "Phone Number",
                          "placeholder": "+1 (555) 123-4567"
                        }
                      ]
                    },
                    {
                      "id": "message_section",
                      "title": "Message",
                      "collapsible": false,
                      "fields": [
                        {
                          "key": "subject",
                          "type": "dropdown",
                          "label": "Subject",
                          "options": ["General Inquiry", "Support", "Sales", "Other"],
                          "required": true
                        },
                        {
                          "key": "message",
                          "type": "text",
                          "label": "Message",
                          "placeholder": "Enter your message here...",
                          "required": true
                        }
                      ]
                    }
                  ]
                },
                theme: FormTheme.light(),
                onChanged: (data) {
                  setState(() {
                    _formData.clear();
                    _formData.addAll(data);
                  });
                },
              ),
            ),
            
            // Submit button
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Form Submitted'),
                    content: Text('Data: $_formData'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// Example 2: Using JSON from string
class JsonStringExample extends StatelessWidget {
  const JsonStringExample({super.key});

  @override
  Widget build(BuildContext context) {
    const jsonString = '''
{
  "id": "user_profile",
  "title": "User Profile",
  "sections": [
    {
      "id": "basic_info",
      "title": "Basic Information",
      "fields": [
        {
          "key": "username",
          "type": "text",
          "label": "Username",
          "required": true
        },
        {
          "key": "age",
          "type": "text",
          "label": "Age"
        }
      ]
    }
  ]
}
''';

    return Scaffold(
      appBar: AppBar(title: const Text('JSON String Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: JsonFormBuilder.fromJsonString(
          jsonString,
          theme: FormTheme.dark(),
          onChanged: (data) {
            print('Form data changed: $data');
          },
        ),
      ),
    );
  }
}

// Example 3: Using JSON from asset file
class AssetJsonExample extends StatelessWidget {
  const AssetJsonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asset JSON Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<JsonFormBuilder>(
          future: JsonFormBuilder.fromAsset(
            'assets/profile_form.json',
            theme: FormTheme.light(),
            onChanged: (data) {
              print('Form data changed: $data');
            },
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return snapshot.data!;
            }
          },
        ),
      ),
    );
  }
}
