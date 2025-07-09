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
  // Collect all field values here
  final Map<String, dynamic> _formData = {};

  // Custom FormTheme for light/dark
  FormTheme getFormTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FormTheme(
      primaryColor: isDark ? Colors.deepPurple[200] : Colors.deepPurple,
      backgroundColor: isDark ? const Color(0xFF23232B) : Colors.white,
      errorColor: isDark ? Colors.red[200] : Colors.red,
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
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
          color: isDark ? Colors.deepPurple[200]! : const Color(0xFFBDBDF6),
          width: 1,
        ),
      ),
      inputShadow: [
        BoxShadow(
          color:  Colors.deepPurple,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
      labelSpacing: 8,
      labelAboveField: true,
    );
  }

  // Helper to build a single field config
  Map<String, dynamic> fieldConfig(Map<String, dynamic> field) => {
    "id": "row",
    "fields": [field],
  };

  // Helper to update a field value
  void _updateField(String key, dynamic value) {
    setState(() {
      _formData[key] = value;
    });
  }

  // Helper to build a single field
  Widget buildField(Map<String, dynamic> field) {
    return JsonFormBuilder(
      config: fieldConfig(field),
      theme: getFormTheme(context),
      onChanged: (data) {
        final key = field['key'];
        _updateField(key, data[key]);
      },
    );
  }

  // Helper to build a row of two fields
  Widget buildRow(Map<String, dynamic> left, Map<String, dynamic> right) {
    return Row(
      children: [
        Expanded(child: buildField(left)),
        const SizedBox(width: 16),
        Expanded(child: buildField(right)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 500;
    final horizontalPadding = size.width * 0.04;
    final verticalPadding = size.height * 0.01;
    final avatarRadius = isSmallScreen ? 50.0 : 70.0;
    final iconSize = isSmallScreen ? 60.0 : 90.0;
    final cameraIconRadius = isSmallScreen ? 14.0 : 20.0;
    final cameraIconSize = isSmallScreen ? 18.0 : 24.0;
    final fieldSpacing = size.height * 0.015;

    // All fields as a list
    final fields = [
      {
        "key": "title",
        "type": "dropdown",
        "label": "Title",
        "placeholder": "Enter Title...",
        "options": ["Mr.", "Ms.", "Mrs.", "Dr."],
      },
      {
        "key": "firstName",
        "type": "text",
        "label": "First Name",
        "placeholder": "Enter First name here...",
      },
      {
        "key": "middleName",
        "type": "text",
        "label": "Middle Name",
        "placeholder": "Enter Middle name...",
      },
      {
        "key": "lastName",
        "type": "text",
        "label": "Last Name",
        "placeholder": "Enter last name here...",
      },
      {
        "key": "primaryNumber",
        "type": "text",
        "label": "Primary Number",
        "placeholder": "+91 XXXXX XXXXX",
      },
      {
        "key": "alternateNumber",
        "type": "text",
        "label": "Alternate Number",
        "placeholder": "+91 XXXXX XXXXX",
      },
      {
        "key": "whatsappNumber",
        "type": "text",
        "label": "Whatsapp Number",
        "placeholder": "+91 XXXXX XXXXX",
      },
      {
        "key": "email",
        "type": "email",
        "label": "Email Address",
        "placeholder": "abc123@gmail.com",
      },
      {
        "key": "birthDate",
        "type": "date",
        "label": "Birth Date",
        "placeholder": "DD/MM/YYYY",
      },
      {
        "key": "gender",
        "type": "dropdown",
        "label": "Gender",
        "options": ["Male", "Female", "Other"],
        "placeholder": "Select your gender",
      },
      {
        "key": "bloodGroup",
        "type": "dropdown",
        "label": "Blood Group",
        "options": ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"],
        "placeholder": "Select your blood group",
      },
      {
        "key": "maritalStatus",
        "type": "dropdown",
        "label": "Marital Status",
        "options": ["Single", "Married", "Divorced", "Widowed"],
        "placeholder": "Select your Status",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText('Profile', maxLines: 1, minFontSize: 18, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: getFormTheme(context).backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
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
                        backgroundColor: Colors.white,
                        child: Icon(Icons.camera_alt, color: Colors.grey[700], size: cameraIconSize),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: fieldSpacing * 2),

              // Title & First Name
              buildRow(fields[0], fields[1]),

              // Middle Name & Last Name
              buildRow(fields[2], fields[3]),

              // Primary Number (full width)
              Padding(
                padding: EdgeInsets.only(bottom: fieldSpacing),
                child: buildField(fields[4]),
              ),

              // Alternate Number (full width)
              Padding(
                padding: EdgeInsets.only(bottom: fieldSpacing),
                child: buildField(fields[5]),
              ),

              // Whatsapp Number (full width)
              Padding(
                padding: EdgeInsets.only(bottom: fieldSpacing),
                child: buildField(fields[6]),
              ),

              // Email Address (full width)
              Padding(
                padding: EdgeInsets.only(bottom: fieldSpacing),
                child: buildField(fields[7]),
              ),

              // Birth Date & Gender
              buildRow(fields[8], fields[9]),

              // Blood Group & Marital Status
              buildRow(fields[10], fields[11]),

              // Submit Button
              Padding(
                padding: EdgeInsets.symmetric(vertical: fieldSpacing),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 18),
                  ),
                  onPressed: () {
                    // Show all collected form data
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const AutoSizeText('Form Data', maxLines: 1, minFontSize: 16, style: TextStyle(fontWeight: FontWeight.bold)),
                            content: SingleChildScrollView(
                              child: AutoSizeText(_formData.toString(), minFontSize: 12, maxLines: 20),
                            ),
                          ),
                    );
                  },
                  child: const AutoSizeText(
                    'Submit',
                    maxLines: 1,
                    minFontSize: 16,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
