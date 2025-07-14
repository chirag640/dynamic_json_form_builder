import 'package:flutter/material.dart';
import 'json_form_builder.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const ProfileFormPage(),
    );
  }
}

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key});

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final Map<String, dynamic> _formData = {};

  // Custom FormTheme for better styling
  FormTheme getFormTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FormTheme(
      primaryColor: isDark ? Colors.deepPurple[200] : Colors.deepPurple,
      backgroundColor: isDark ? const Color(0xFF23232B) : Colors.white,
      errorColor: isDark ? Colors.red[200] : Colors.red,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: isDark ? Colors.white : Colors.black87,
      ),
      inputStyle: TextStyle(
        fontSize: 15,
        color: isDark ? Colors.white : Colors.black87,
      ),
      helperStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
      errorStyle: TextStyle(
        color: isDark ? Colors.redAccent : Colors.red,
        fontSize: 13,
      ),
      inputBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? Colors.deepPurple[200]! : const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      inputShadow: [
        BoxShadow(
          color: Colors.deepPurple.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      labelSpacing: 8,
      labelAboveField: true,
    );
  }

  // Simple JSON configuration - users can provide this easily
  final Map<String, dynamic> formConfig = {
    "id": "profile_form",
    "title": "Profile Information",
    "description": "Please fill out your profile details below",
    "sections": [
      {
        "id": "personal_section",
        "title": "Personal Information",
        "description": "Enter your basic personal details",
        "collapsible": true,
        "initiallyExpanded": true,
        "fields": [
          {
            "key": "title",
            "type": "dropdown",
            "label": "Title",
            "placeholder": "Select title...",
            "options": ["Mr.", "Ms.", "Mrs.", "Dr."],
            "required": true
          },
          {
            "key": "firstName",
            "type": "text",
            "label": "First Name",
            "placeholder": "Enter first name...",
            "required": true
          },
          {
            "key": "middleName",
            "type": "text",
            "label": "Middle Name",
            "placeholder": "Enter middle name..."
          },
          {
            "key": "lastName",
            "type": "text",
            "label": "Last Name",
            "placeholder": "Enter last name...",
            "required": true
          }
        ]
      },
      {
        "id": "contact_section",
        "title": "Contact Information",
        "description": "How can we reach you?",
        "collapsible": true,
        "initiallyExpanded": true,
        "fields": [
          {
            "key": "primaryNumber",
            "type": "text",
            "label": "Primary Number",
            "placeholder": "+91 XXXXX XXXXX",
            "required": true
          },
          {
            "key": "alternateNumber",
            "type": "text",
            "label": "Alternate Number",
            "placeholder": "+91 XXXXX XXXXX"
          },
          {
            "key": "whatsappNumber",
            "type": "text",
            "label": "WhatsApp Number",
            "placeholder": "+91 XXXXX XXXXX"
          },
          {
            "key": "email",
            "type": "email",
            "label": "Email Address",
            "placeholder": "example@email.com",
            "required": true
          }
        ]
      },
      {
        "id": "other_section",
        "title": "Additional Details",
        "collapsible": false,
        "fields": [
          {
            "key": "birthDate",
            "type": "date",
            "label": "Birth Date",
            "placeholder": "DD/MM/YYYY"
          },
          {
            "key": "gender",
            "type": "dropdown",
            "label": "Gender",
            "options": ["Male", "Female", "Other"],
            "placeholder": "Select gender..."
          },
          {
            "key": "bloodGroup",
            "type": "dropdown",
            "label": "Blood Group",
            "options": ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"],
            "placeholder": "Select blood group..."
          },
          {
            "key": "maritalStatus",
            "type": "dropdown",
            "label": "Marital Status",
            "options": ["Single", "Married", "Divorced", "Widowed"],
            "placeholder": "Select status..."
          }
        ]
      },
      {
        "id": "preferences_section",
        "title": "Preferences & Ratings",
        "description": "Tell us about your preferences",
        "collapsible": true,
        "initiallyExpanded": false,
        "fields": [
          {
            "key": "satisfaction",
            "type": "rating",
            "label": "Overall Satisfaction",
            "maxRating": 5,
            "allowHalfRating": true,
            "showLabels": true,
            "labels": ["Poor", "Fair", "Good", "Very Good", "Excellent"],
            "helperText": "Rate your overall satisfaction"
          },
          {
            "key": "priority",
            "type": "slider",
            "label": "Priority Level",
            "min": 1,
            "max": 10,
            "divisions": 9,
            "showLabels": true,
            "showValue": true,
            "suffix": "/10",
            "helperText": "Set your priority level"
          },
          {
            "key": "favoriteColor",
            "type": "color",
            "label": "Favorite Color",
            "showHexValue": true,
            "helperText": "Pick your favorite color"
          }
        ]
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 500;
    final horizontalPadding = size.width * 0.05;
    final verticalPadding = size.height * 0.02;
    final avatarRadius = isSmallScreen ? 50.0 : 70.0;
    final iconSize = isSmallScreen ? 60.0 : 90.0;
    final cameraIconRadius = isSmallScreen ? 14.0 : 20.0;
    final cameraIconSize = isSmallScreen ? 18.0 : 24.0;

    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText(
          'Dynamic Form Builder',
          maxLines: 1,
          minFontSize: 18,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: getFormTheme(context).backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile avatar
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: iconSize,
                        color: Colors.grey[500],
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: CircleAvatar(
                        radius: cameraIconRadius,
                        backgroundColor: Colors.deepPurple,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: cameraIconSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Dynamic form from JSON config
              JsonFormBuilder(
                config: formConfig,
                theme: getFormTheme(context),
                onChanged: (data) {
                  setState(() {
                    _formData.clear();
                    _formData.addAll(data);
                  });
                },
                onValidation: (errors) {
                  // Handle validation errors
                  debugPrint('Validation errors: $errors');
                },
              ),

              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: isSmallScreen ? 14 : 18,
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  // Show collected form data
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        'Form Data',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: _formData.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  children: [
                                    TextSpan(
                                      text: '${entry.key}: ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: entry.value?.toString() ?? 'null',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                child: const AutoSizeText(
                  'Submit Form',
                  maxLines: 1,
                  minFontSize: 16,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
