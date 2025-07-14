/// Model representing the configuration for a form.
class FormConfig {
  /// Unique identifier for the form.
  final String id;
  /// Optional title for the form.
  final String? title;
  /// Optional description for the form.
  final String? description;
  /// List of sections or field configurations in the form.
  final List<dynamic> sections;

  /// Creates a [FormConfig] instance.
  FormConfig({
    required this.id,
    this.title,
    this.description,
    required this.sections,
  });

  /// Creates a [FormConfig] from a JSON map.
  factory FormConfig.fromJson(Map<String, dynamic> json) {
    return FormConfig(
      id: json['id'] ?? '',
      title: json['title'],
      description: json['description'],
      sections: (json['sections'] as List<dynamic>? ?? 
                 json['fields'] as List<dynamic>? ?? [])
          .map((item) => item is Map<String, dynamic> && item.containsKey('fields') 
              ? SectionConfig.fromJson(item) 
              : FieldConfig.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Model representing a section in the form.
class SectionConfig {
  /// Unique identifier for the section.
  final String id;
  /// Optional title for the section.
  final String? title;
  /// Optional description for the section.
  final String? description;
  /// Whether the section is collapsible.
  final bool collapsible;
  /// Whether the section is initially expanded (only for collapsible sections).
  final bool initiallyExpanded;
  /// List of field configurations in the section.
  final List<FieldConfig> fields;

  /// Creates a [SectionConfig] instance.
  SectionConfig({
    required this.id,
    this.title,
    this.description,
    this.collapsible = false,
    this.initiallyExpanded = true,
    required this.fields,
  });

  /// Creates a [SectionConfig] from a JSON map.
  factory SectionConfig.fromJson(Map<String, dynamic> json) {
    return SectionConfig(
      id: json['id'] ?? '',
      title: json['title'],
      description: json['description'],
      collapsible: json['collapsible'] ?? false,
      initiallyExpanded: json['initiallyExpanded'] ?? true,
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