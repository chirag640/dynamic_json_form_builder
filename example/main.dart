import 'package:flutter/material.dart';
import 'package:dynamic_json_form_builder/json_form_builder.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic JSON Form Builder - Complete Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple[200],
      ),
      home: const ComprehensiveFormDemo(),
    );
  }
}

class ComprehensiveFormDemo extends StatefulWidget {
  const ComprehensiveFormDemo({super.key});

  @override
  State<ComprehensiveFormDemo> createState() => _ComprehensiveFormDemoState();
}

class _ComprehensiveFormDemoState extends State<ComprehensiveFormDemo> {
  final Map<String, dynamic> _formData = {};
  final Map<String, String?> _validationErrors = {};
  bool _isDarkMode = false;

  // Comprehensive form configuration showcasing ALL features
  final Map<String, dynamic> formConfig = {
    "id": "comprehensive_demo_form",
    "title": "🚀 Dynamic JSON Form Builder - Complete Demo",
    "description": "This form demonstrates ALL field types, validation, conditional logic, theming, and features available in the dynamic JSON form builder package.",
    "sections": [
      {
        "id": "basic_text_fields",
        "title": "📝 Text Input Fields",
        "description": "Various text input types with validation",
        "collapsible": true,
        "initiallyExpanded": true,
        "fields": [
          {
            "key": "fullName",
            "type": "text",
            "label": "Full Name",
            "placeholder": "Enter your full name...",
            "required": true,
            "minLength": 2,
            "maxLength": 50,
            "helperText": "First and last name required"
          },
          {
            "key": "email",
            "type": "email",
            "label": "Email Address",
            "placeholder": "your.email@example.com",
            "required": true,
            "helperText": "We'll never share your email"
          },
          {
            "key": "phone",
            "type": "phone",
            "label": "Phone Number",
            "placeholder": "+1 (555) 123-4567",
            "required": true,
            "helperText": "Include country code"
          },
          {
            "key": "website",
            "type": "text",
            "label": "Website URL",
            "placeholder": "https://your-website.com",
            "pattern": r"^https?:\/\/.+",
            "patternError": "Please enter a valid URL starting with http:// or https://",
            "helperText": "Optional: Your personal or business website"
          },
          {
            "key": "age",
            "type": "number",
            "label": "Age",
            "placeholder": "Enter your age",
            "required": true,
            "min": 13,
            "max": 120,
            "helperText": "Must be 13 or older"
          },
          {
            "key": "password",
            "type": "password",
            "label": "Password",
            "placeholder": "Create a secure password",
            "required": true,
            "minLength": 8,
            "helperText": "Minimum 8 characters"
          },
          {
            "key": "bio",
            "type": "multiline",
            "label": "Bio / About You",
            "placeholder": "Tell us about yourself...",
            "maxLength": 500,
            "helperText": "Optional: Brief description about yourself"
          }
        ]
      },
      {
        "id": "selection_fields",
        "title": "🎯 Selection & Choice Fields",
        "description": "Dropdowns, radio buttons, checkboxes, and multi-select",
        "collapsible": true,
        "initiallyExpanded": true,
        "fields": [
          {
            "key": "country",
            "type": "dropdown",
            "label": "Country",
            "options": ["United States", "Canada", "United Kingdom", "Australia", "Germany", "France", "Japan", "India", "Brazil", "Other"],
            "placeholder": "Select your country",
            "required": true,
            "helperText": "Your country of residence"
          },
          {
            "key": "gender",
            "type": "radio",
            "label": "Gender",
            "options": ["Male", "Female", "Non-binary", "Prefer not to say"],
            "required": true,
            "helperText": "Select your gender identity"
          },
          {
            "key": "interests",
            "type": "multi_select",
            "label": "Interests & Hobbies",
            "options": ["Technology", "Sports", "Music", "Art", "Travel", "Cooking", "Reading", "Gaming", "Photography", "Fitness"],
            "helperText": "Select all that apply"
          },
          {
            "key": "newsletter",
            "type": "checkbox",
            "label": "Subscribe to Newsletter",
            "helperText": "Receive updates about new features and releases"
          },
          {
            "key": "terms",
            "type": "checkbox",
            "label": "I agree to the Terms and Conditions",
            "required": true,
            "helperText": "Required to proceed"
          }
        ]
      },
      {
        "id": "interactive_fields",
        "title": "🎛️ Interactive & Rating Fields",
        "description": "Sliders, ratings, and color pickers",
        "collapsible": true,
        "initiallyExpanded": true,
        "fields": [
          {
            "key": "satisfaction",
            "type": "rating",
            "label": "Overall Satisfaction",
            "maxRating": 5,
            "allowHalfRating": true,
            "showLabels": true,
            "labels": ["Poor", "Fair", "Good", "Very Good", "Excellent"],
            "helperText": "Rate your experience with form builders",
            "required": true
          },
          {
            "key": "experience",
            "type": "rating",
            "label": "Development Experience (Years)",
            "maxRating": 10,
            "allowHalfRating": false,
            "showValue": true,
            "starSize": 35,
            "helperText": "How many years of development experience?"
          },
          {
            "key": "priority",
            "type": "slider",
            "label": "Project Priority",
            "min": 1,
            "max": 10,
            "divisions": 9,
            "showLabels": true,
            "showValue": true,
            "suffix": "/10",
            "helperText": "How important is this project? (1=Low, 10=Critical)",
            "required": true
          },
          {
            "key": "budget",
            "type": "slider",
            "label": "Budget Range",
            "min": 0,
            "max": 10000,
            "divisions": 20,
            "showLabels": true,
            "showValue": true,
            "prefix": r"$",
            "helperText": "Project budget in USD"
          },
          {
            "key": "completion",
            "type": "slider",
            "label": "Project Completion",
            "min": 0,
            "max": 100,
            "divisions": 10,
            "showLabels": true,
            "showValue": true,
            "suffix": "%",
            "helperText": "Current project completion percentage"
          },
          {
            "key": "themeColor",
            "type": "color",
            "label": "Preferred Theme Color",
            "showHexValue": true,
            "helperText": "Choose your preferred UI theme color"
          },
          {
            "key": "accentColor",
            "type": "color",
            "label": "Accent Color",
            "showHexValue": true,
            "helperText": "Secondary color for highlights"
          }
        ]
      },
      {
        "id": "datetime_fields",
        "title": "📅 Date & Time Fields",
        "description": "Date pickers and time selection",
        "collapsible": true,
        "initiallyExpanded": true,
        "fields": [
          {
            "key": "birthDate",
            "type": "date",
            "label": "Date of Birth",
            "placeholder": "Select your birth date",
            "required": true,
            "helperText": "Used for age verification"
          },
          {
            "key": "projectStart",
            "type": "date",
            "label": "Project Start Date",
            "placeholder": "When will the project start?",
            "helperText": "Estimated project start date"
          },
          {
            "key": "deadline",
            "type": "date",
            "label": "Project Deadline",
            "placeholder": "Project completion deadline",
            "helperText": "Final delivery date"
          }
        ]
      },
      {
        "id": "file_upload",
        "title": "📎 File Upload Fields",
        "description": "File upload capabilities",
        "collapsible": true,
        "initiallyExpanded": false,
        "fields": [
          {
            "key": "profilePicture",
            "type": "file",
            "label": "Profile Picture",
            "multiple": false,
            "helperText": "Upload your profile picture (JPG, PNG)"
          },
          {
            "key": "documents",
            "type": "file",
            "label": "Project Documents",
            "multiple": true,
            "helperText": "Upload relevant project documents"
          }
        ]
      },
      {
        "id": "conditional_fields",
        "title": "🔀 Conditional Logic Demo",
        "description": "Fields that show/hide based on other field values",
        "collapsible": true,
        "initiallyExpanded": false,
        "fields": [
          {
            "key": "hasExperience",
            "type": "radio",
            "label": "Do you have development experience?",
            "options": ["Yes", "No"],
            "required": true,
            "helperText": "This will show different fields below"
          },
          {
            "key": "yearsExperience",
            "type": "number",
            "label": "Years of Experience",
            "placeholder": "Enter number of years",
            "visibleIf": {
              "hasExperience": "Yes"
            },
            "required": true,
            "helperText": "Only visible if you have experience"
          },
          {
            "key": "technologies",
            "type": "multi_select",
            "label": "Technologies You Know",
            "options": ["Flutter", "React", "Vue.js", "Angular", "Node.js", "Python", "Java", "C#", "Swift", "Kotlin"],
            "visibleIf": {
              "hasExperience": "Yes"
            },
            "helperText": "Select all technologies you're familiar with"
          },
          {
            "key": "learningGoals",
            "type": "multiline",
            "label": "What do you want to learn?",
            "placeholder": "Describe your learning goals...",
            "visibleIf": {
              "hasExperience": "No"
            },
            "helperText": "Only visible if you're new to development"
          },
          {
            "key": "contactMethod",
            "type": "dropdown",
            "label": "Preferred Contact Method",
            "options": ["Email", "Phone", "SMS", "Video Call"],
            "required": true,
            "helperText": "How would you like us to contact you?"
          },
          {
            "key": "phoneForContact",
            "type": "phone",
            "label": "Phone Number for Contact",
            "placeholder": "Enter phone number",
            "visibleIf": {
              "contactMethod": "Phone"
            },
            "required": true,
            "helperText": "Visible only if phone contact is selected"
          },
          {
            "key": "videoCallTime",
            "type": "text",
            "label": "Preferred Video Call Time",
            "placeholder": "e.g., Weekdays 2-4 PM EST",
            "visibleIf": {
              "contactMethod": "Video Call"
            },
            "helperText": "When are you available for video calls?"
          }
        ]
      },
      {
        "id": "advanced_validation",
        "title": "✅ Advanced Validation Demo",
        "description": "Custom validation patterns and rules",
        "collapsible": true,
        "initiallyExpanded": false,
        "fields": [
          {
            "key": "username",
            "type": "text",
            "label": "Username",
            "placeholder": "Enter username (letters, numbers, underscore only)",
            "required": true,
            "pattern": r"^[a-zA-Z0-9_]{3,20}$",
            "patternError": "Username must be 3-20 characters, letters/numbers/underscore only",
            "helperText": "3-20 characters, alphanumeric and underscore only"
          },
          {
            "key": "zipCode",
            "type": "text",
            "label": "ZIP/Postal Code",
            "placeholder": "Enter ZIP code",
            "pattern": r"^\d{5}(-\d{4})?$",
            "patternError": "Please enter a valid ZIP code (12345 or 12345-6789)",
            "helperText": "US ZIP code format"
          },
          {
            "key": "confirmEmail",
            "type": "email",
            "label": "Confirm Email",
            "placeholder": "Re-enter your email address",
            "required": true,
            "helperText": "Must match the email address above"
          }
        ]
      }
    ]
  };

  FormTheme getFormTheme() {
    return _isDarkMode ? FormTheme.dark() : FormTheme.light();
  }

  void _handleFormChanged(Map<String, dynamic> data) {
    setState(() {
      _formData.clear();
      _formData.addAll(data);
    });
    print('📝 Form data changed: ${data.keys.length} fields updated');
  }

  void _handleValidationChanged(Map<String, String?> errors) {
    setState(() {
      _validationErrors.clear();
      _validationErrors.addAll(errors);
    });
    final errorCount = errors.values.where((e) => e != null && e.isNotEmpty).length;
    if (errorCount > 0) {
      print('❌ Validation errors: $errorCount fields have errors');
    }
  }

  void _handleFormSubmit(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Form Submitted Successfully!'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('✅ Form submitted with ${data.keys.length} fields'),
              const SizedBox(height: 16),
              const Text('📊 Form Data Summary:', 
                style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...data.entries.take(10).map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: '${entry.key}: ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: entry.value?.toString() ?? 'null',
                      ),
                    ],
                  ),
                ),
              )),
              if (data.keys.length > 10)
                Text('... and ${data.keys.length - 10} more fields'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              print('💾 Complete form data: $data');
            },
            child: const Text('View Full Data in Console'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final errorCount = _validationErrors.values.where((e) => e != null && e.isNotEmpty).length;
    final filledFields = _formData.values.where((v) => v != null && v.toString().isNotEmpty).length;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚀 Dynamic JSON Form Builder'),
        backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            tooltip: 'Toggle theme',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('📚 Demo Information'),
                  content: const SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('This demo showcases ALL features of the Dynamic JSON Form Builder:'),
                        SizedBox(height: 8),
                        Text('✅ All field types (text, email, dropdown, rating, slider, color, etc.)'),
                        Text('✅ Sections with collapsible/expandable functionality'),
                        Text('✅ Advanced validation with custom patterns'),
                        Text('✅ Conditional logic (fields show/hide based on other values)'),
                        Text('✅ Custom theming (light/dark mode)'),
                        Text('✅ Form state management'),
                        Text('✅ File upload simulation'),
                        Text('✅ Real-time form data updates'),
                        SizedBox(height: 12),
                        Text('🎯 Try interacting with different fields to see conditional logic in action!'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it!'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Show demo info',
          ),
        ],
      ),
      body: Column(
        children: [
          // Status bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: _isDarkMode ? Colors.grey[850] : Colors.deepPurple[50],
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '📊 Status: $filledFields fields filled',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _isDarkMode ? Colors.white : Colors.deepPurple[700],
                    ),
                  ),
                ),
                if (errorCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '❌ $errorCount errors',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                if (errorCount == 0 && filledFields > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '✅ All valid',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: JsonFormBuilder(
                config: formConfig,
                theme: getFormTheme(),
                onChanged: _handleFormChanged,
                onValidation: _handleValidationChanged,
                onSubmit: _handleFormSubmit,
              ),
            ),
          ),
          // Submit button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: errorCount == 0 && filledFields > 0
                  ? () => _handleFormSubmit(_formData)
                  : null,
              child: Text(
                errorCount > 0
                    ? '❌ Fix $errorCount errors to submit'
                    : filledFields == 0
                        ? '📝 Fill out the form to submit'
                        : '🚀 Submit Form ($filledFields fields)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
