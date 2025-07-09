/// Model representing the configuration for a form.
class FormConfig {
  /// Unique identifier for the form.
  final String id;
  /// Optional title for the form.
  final String? title;
  /// List of field configurations in the form.
  final List<FieldConfig> fields;

  /// Creates a [FormConfig] instance.
  FormConfig({
    required this.id,
    this.title,
    required this.fields,
  });

  /// Creates a [FormConfig] from a JSON map.
  factory FormConfig.fromJson(Map<String, dynamic> json) {
    return FormConfig(
      id: json['id'] ?? '',
      title: json['title'],
      fields: (json['fields'] as List<dynamic>? ?? [])
          .map((f) => FieldConfig.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Model representing the configuration for a single form field.
class FieldConfig {
  /// The unique key for the field.
  final String key;
  /// The type of the field (e.g., 'text', 'dropdown', etc.).
  final String type;
  /// Optional label for the field.
  final String? label;
  /// Whether the field is required.
  final bool required;
  /// Extra configuration for the field (options, placeholder, etc.).
  final Map<String, dynamic> extra;

  /// Creates a [FieldConfig] instance.
  FieldConfig({
    required this.key,
    required this.type,
    this.label,
    this.required = false,
    this.extra = const {},
  });

  /// Creates a [FieldConfig] from a JSON map.
  factory FieldConfig.fromJson(Map<String, dynamic> json) {
    return FieldConfig(
      key: json['key'] ?? '',
      type: json['type'] ?? 'text',
      label: json['label'],
      required: json['required'] ?? false,
      extra: Map<String, dynamic>.from(json)..removeWhere((k, _) => ['key','type','label','required'].contains(k)),
    );
  }
} 