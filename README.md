# Dynamic JSON Form Builder 🚀

> **Version 1.2.0 — Enhanced with Slider, Rating & Color Fields!**
> 
> This release adds slider/range, rating, and color picker field types, plus full support for field grouping/sections, collapsible cards, easy JSON config, and improved documentation. See CHANGELOG for details.

[![pub package](https://img.shields.io/pub/v/dynamic_json_form_builder.svg)](https://pub.dev/packages/dynamic_json_form_builder)
[![pub points](https://badges.bar/dynamic_json_form_builder/pub%20points)](https://pub.dev/packages/dynamic_json_form_builder/score)
[![likes](https://badges.bar/dynamic_json_form_builder/likes)](https://pub.dev/packages/dynamic_json_form_builder/score)
[![null safety](https://img.shields.io/badge/null%20safety-enabled-success.svg)](https://pub.dev/packages/dynamic_json_form_builder)

---

## Overview

**dynamic_json_form_builder** is a highly advanced, reusable, and extensible JSON-driven form builder for Flutter. Effortlessly build dynamic, beautiful, and responsive forms from JSON with support for collapsible sections, custom theming, validation, conditional logic, and user-defined custom fields. Perfect for app developers who want to create flexible forms without writing repetitive UI code.

---

## ✨ Features

- **🔧 JSON Configuration**: Build forms from simple JSON configurations (Map, string, or asset file)
- **📚 Sections Support**: Organize fields into collapsible/expandable sections and nested groups
- **🎨 Custom Theming**: Beautiful, customizable themes for light/dark modes
- **✅ Validation**: Built-in validation with custom regex support
- **🔄 Conditional Logic**: Show/hide fields based on other field values
- **📱 Responsive Design**: Works perfectly on all screen sizes
- **🔌 Custom Fields**: Support for custom field types
- **📁 Multiple Input Methods**: JSON string, asset files, or direct maps
- **🎯 Easy Integration**: Simple API for quick implementation
- **🗂️ Card-based UI**: Sections and fields are beautifully styled with cards and spacing
- **🛠️ Publish-ready**: Clean API, documentation, and examples for pub.dev

---

## 🚀 Quick Start

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:dynamic_json_form_builder/json_form_builder.dart';

JsonFormBuilder(
  config: {
    "id": "my_form",
    "title": "Contact Form",
    "description": "Please fill out your information",
    "sections": [
      {
        "id": "personal_info",
        "title": "Personal Information",
        "collapsible": true,
        "fields": [
          {
            "key": "name",
            "type": "text",
            "label": "Full Name",
            "placeholder": "Enter your name...",
            "required": true
          },
          {
            "key": "email",
            "type": "email",
            "label": "Email",
            "placeholder": "your.email@example.com",
            "required": true
          }
        ]
      }
    ]
  },
  theme: FormTheme.light(),
  onChanged: (data) => print('Form data: $data'),
)
```

### From JSON String

```dart
JsonFormBuilder.fromJsonString(
  jsonString,
  theme: FormTheme.dark(),
  onChanged: (data) => print('Form data: $data'),
)
```

### From Asset File

```dart
FutureBuilder<JsonFormBuilder>(
  future: JsonFormBuilder.fromAsset(
    'assets/form_config.json',
    theme: FormTheme.light(),
    onChanged: (data) => print('Form data: $data'),
  ),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return snapshot.data!;
    }
    return CircularProgressIndicator();
  },
)
```

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  dynamic_json_form_builder: ^1.0.0
```

Then run:

```sh
flutter pub get
```

---

## Usage Example

```dart
import 'package:dynamic_json_form_builder/dynamic_json_form_builder.dart';

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
  // ... more fields ...
];

class MyFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JsonFormBuilder(
      config: {"fields": fields},
      onChanged: (data) => print(data),
      // theme: FormTheme(...), // Optional: custom theming
    );
  }
}
```

---

## API Reference

### Key Widgets & Classes

- **JsonFormBuilder**  
  The main widget. Takes a JSON config and builds the form.

- **FormTheme**  
  Customizes colors, text styles, borders, spacing, and more.

- **FieldConfig**  
  Model for each field's configuration.

- **Custom Field Support**  
  Pass `customFieldBuilders` to support your own widgets.

#### Main Parameters

| Parameter            | Type                       | Description                                 |
|----------------------|----------------------------|---------------------------------------------|
| `config`             | `Map<String, dynamic>`     | JSON config for the form                    |
| `onChanged`          | `Function(Map)`            | Callback for form value changes             |
| `theme`              | `FormTheme?`               | Custom theme for the form                   |
| `customFieldBuilders`| `Map<String, FieldWidgetBuilder>?` | Add your own field types           |

---

## Customization

- **Theming**:  
  Use the `FormTheme` class to fully customize colors, fonts, borders, spacing, and more.

- **Custom Fields**:  
  Pass a `customFieldBuilders` map to add your own field widgets.

- **Validation**:  
  Add `validator` or `asyncValidator` in your field config for custom validation logic.

- **Conditional Logic**:  
  Use the `visibleIf` property in field config to show/hide fields based on other values.

---

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

---

## Screenshots

> _Add your own screenshots or GIFs here!_

![Profile Form Example](assets/screenshots/profile-form.jpg)
---

## Roadmap

- [✅] Field grouping/sections
- [✅] More built-in field types (slider, rating, color picker)
- [✅] Time and datetime field types
- [ ] Drag-and-drop form builder UI
- [ ] Localization/i18n support
- [ ] More advanced conditional logic

---

## Contributing

Contributions are welcome! To get started:

1. Fork the repo and clone it.
2. Create a new branch for your feature or bugfix.
3. Write clear, well-documented code and tests.
4. Open a pull request describing your changes.

Please see [CONTRIBUTING.md](https://github.com/chirag640/dynamic_json_form_builder/blob/main/CONTRIBUTING.md) for more details.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Contact

Maintained by [Chirag Chaudhary](mailto:chiragchaudhary640@gmail.com).  
For issues, please use the [issue tracker](https://github.com/chirag640/dynamic_json_form_builder/issues).

---
