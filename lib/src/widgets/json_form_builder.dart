import 'package:flutter/material.dart';
import '../models/form_config.dart';
import '../themes/form_theme.dart';
import 'fields/field_factory.dart';

// Define the FieldWidgetBuilder type
typedef FieldWidgetBuilder = Widget Function(
  FieldConfig config, {
    ValueChanged<dynamic>? onChanged,
    ValueChanged<String?>? onValidation,
    dynamic initialValue,
    FormTheme? theme,
  }
);

class JsonFormBuilder extends StatefulWidget {
  final dynamic config;
  final ValueChanged<Map<String, dynamic>>? onChanged;
  final ValueChanged<Map<String, String?>>? onValidation;
  final ValueChanged<Map<String, dynamic>>? onSubmit;
  final FormTheme? theme;
  final bool autoSave;
  final String? persistenceKey;
  final Map<String, FieldWidgetBuilder>? customFieldBuilders;

  const JsonFormBuilder({
    Key? key,
    required this.config,
    this.onChanged,
    this.onValidation,
    this.onSubmit,
    this.theme,
    this.autoSave = false,
    this.persistenceKey,
    this.customFieldBuilders,
  }) : super(key: key);

  @override
  State<JsonFormBuilder> createState() => _JsonFormBuilderState();
}

class _JsonFormBuilderState extends State<JsonFormBuilder> {
  late FormConfig _formConfig;
  final Map<String, dynamic> _formData = {};
  final Map<String, String?> _errors = {};

  @override
  void initState() {
    super.initState();
    _formConfig = widget.config is Map<String, dynamic>
        ? FormConfig.fromJson(widget.config)
        : FormConfig.fromJson({});
    for (final field in _formConfig.fields) {
      _formData[field.key] = null;
      _errors[field.key] = null;
    }
  }

  void _handleFieldChanged(String key, dynamic value) {
    setState(() {
      _formData[key] = value;
    });
    widget.onChanged?.call(_formData);
  }

  void _handleValidationChanged(String key, String? error) {
    setState(() {
      _errors[key] = error;
    });
    widget.onValidation?.call(_errors);
  }

  bool get isFormValid => !_errors.values.any((e) => e != null && e.isNotEmpty);

  void _handleSubmit() {
    if (isFormValid) {
      widget.onSubmit?.call(_formData);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fieldWidgets = [];
    for (final field in _formConfig.fields) {
      final visibleIf = field.extra['visibleIf'] as Map<String, dynamic>?;
      bool isVisible = true;
      if (visibleIf != null) {
        isVisible = visibleIf.entries.every((entry) {
          final depValue = _formData[entry.key];
          return depValue == entry.value;
        });
      }
      if (!isVisible) continue;

      ValueChanged<String?>? onValidation = (error) {
        final customValidation = field.extra['customValidation'];
        String? customError;
        if (customValidation is String && _formData[field.key] != null) {
          final regex = RegExp(customValidation);
          if (!regex.hasMatch(_formData[field.key].toString())) {
            customError = field.extra['customValidationError'] ?? 'Invalid value';
          }
        }
        setState(() {
          _errors[field.key] = error ?? customError;
        });
        widget.onValidation?.call(_errors);
      };

      fieldWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FieldFactory.build(
            field,
            onChanged: (value) => _handleFieldChanged(field.key, value),
            onValidation: onValidation,
            initialValue: _formData[field.key],
            theme: widget.theme,
            customFieldBuilders: widget.customFieldBuilders,
          ),
        ),
      );
    }
    // Use Column for single field, ListView for multiple fields
    if (fieldWidgets.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: fieldWidgets,
      );
    } else {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0),
        children: [
          if (_formConfig.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                _formConfig.title!,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ...fieldWidgets,
          ElevatedButton(
            onPressed: _handleSubmit,
            child: const Text('Submit'),
          ),
        ],
      );
    }
  }
} 