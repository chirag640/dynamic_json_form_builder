import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
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

/// A widget that builds a dynamic form from a JSON configuration.
///
/// Supports all major field types, custom theming, validation, conditional logic, sections, and custom fields.
class JsonFormBuilder extends StatefulWidget {
  /// The JSON config for the form. Can be a Map or a FormConfig.
  final dynamic config;
  /// Callback when any field value changes. Returns the current form data.
  final ValueChanged<Map<String, dynamic>>? onChanged;
  /// Callback when any field validation changes. Returns the current error map.
  final ValueChanged<Map<String, String?>>? onValidation;
  /// Callback when the form is submitted and valid. Returns the form data.
  final ValueChanged<Map<String, dynamic>>? onSubmit;
  /// The theme to use for the form and fields.
  final FormTheme? theme;
  /// Whether to auto-save form data (not implemented).
  final bool autoSave;
  /// Optional key for persisting form data (not implemented).
  final String? persistenceKey;
  /// Map of custom field builders for user-defined field types.
  final Map<String, FieldWidgetBuilder>? customFieldBuilders;

  /// Creates a [JsonFormBuilder] widget.
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

  /// Creates a [JsonFormBuilder] from a JSON string.
  factory JsonFormBuilder.fromJsonString(
    String jsonString, {
    Key? key,
    ValueChanged<Map<String, dynamic>>? onChanged,
    ValueChanged<Map<String, String?>>? onValidation,
    ValueChanged<Map<String, dynamic>>? onSubmit,
    FormTheme? theme,
    bool autoSave = false,
    String? persistenceKey,
    Map<String, FieldWidgetBuilder>? customFieldBuilders,
  }) {
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    return JsonFormBuilder(
      key: key,
      config: jsonMap,
      onChanged: onChanged,
      onValidation: onValidation,
      onSubmit: onSubmit,
      theme: theme,
      autoSave: autoSave,
      persistenceKey: persistenceKey,
      customFieldBuilders: customFieldBuilders,
    );
  }

  /// Creates a [JsonFormBuilder] from an asset file.
  static Future<JsonFormBuilder> fromAsset(
    String assetPath, {
    Key? key,
    ValueChanged<Map<String, dynamic>>? onChanged,
    ValueChanged<Map<String, String?>>? onValidation,
    ValueChanged<Map<String, dynamic>>? onSubmit,
    FormTheme? theme,
    bool autoSave = false,
    String? persistenceKey,
    Map<String, FieldWidgetBuilder>? customFieldBuilders,
  }) async {
    final jsonString = await rootBundle.loadString(assetPath);
    return JsonFormBuilder.fromJsonString(
      jsonString,
      key: key,
      onChanged: onChanged,
      onValidation: onValidation,
      onSubmit: onSubmit,
      theme: theme,
      autoSave: autoSave,
      persistenceKey: persistenceKey,
      customFieldBuilders: customFieldBuilders,
    );
  }

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
    _initializeFormData();
  }

  void _initializeFormData() {
    for (final item in _formConfig.sections) {
      if (item is SectionConfig) {
        for (final field in item.fields) {
          _formData[field.key] = null;
          _errors[field.key] = null;
        }
      } else if (item is FieldConfig) {
        _formData[item.key] = null;
        _errors[item.key] = null;
      }
    }
  }

  void _handleFieldChanged(String key, dynamic value) {
    setState(() {
      _formData[key] = value;
    });
    widget.onChanged?.call(_formData);
  }

  Widget _buildSection(SectionConfig section) {
    final theme = widget.theme ?? FormTheme.light();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    List<Widget> fieldWidgets = [];
    
    for (final field in section.fields) {
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
            theme: theme,
            customFieldBuilders: widget.customFieldBuilders,
          ),
        ),
      );
    }

    Widget sectionContent = Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (section.title != null && !section.collapsible)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  section.title!,
                  style: theme.labelStyle?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ) ?? TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            if (section.description != null && !section.collapsible)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  section.description!,
                  style: theme.helperStyle ?? TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ...fieldWidgets,
          ],
        ),
      ),
    );

    if (section.collapsible) {
      return Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            title: Text(
              section.title ?? '',
              style: theme.labelStyle?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ) ?? TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            subtitle: section.description != null
                ? Text(
                    section.description!,
                    style: theme.helperStyle ?? TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 12,
                    ),
                  )
                : null,
            initiallyExpanded: section.initiallyExpanded,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: fieldWidgets,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: sectionContent,
      );
    }
  }

  Widget _buildField(FieldConfig field) {
    final theme = widget.theme ?? FormTheme.light();
    
    final visibleIf = field.extra['visibleIf'] as Map<String, dynamic>?;
    bool isVisible = true;
    if (visibleIf != null) {
      isVisible = visibleIf.entries.every((entry) {
        final depValue = _formData[entry.key];
        return depValue == entry.value;
      });
    }
    if (!isVisible) return const SizedBox.shrink();

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

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FieldFactory.build(
        field,
        onChanged: (value) => _handleFieldChanged(field.key, value),
        onValidation: onValidation,
        initialValue: _formData[field.key],
        theme: theme,
        customFieldBuilders: widget.customFieldBuilders,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? FormTheme.light();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    List<Widget> widgets = [];
    
    // Add form title and description
    if (_formConfig.title != null) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            _formConfig.title!,
            style: theme.labelStyle?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ) ?? TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      );
    }
    
    if (_formConfig.description != null) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Text(
            _formConfig.description!,
            style: theme.helperStyle ?? TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    // Add sections and fields
    for (final item in _formConfig.sections) {
      if (item is SectionConfig) {
        widgets.add(_buildSection(item));
      } else if (item is FieldConfig) {
        widgets.add(_buildField(item));
      }
    }

    // Use Column for single field, ListView for multiple items
    if (widgets.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widgets,
      );
    } else {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0),
        children: widgets,
      );
    }
  }
} 