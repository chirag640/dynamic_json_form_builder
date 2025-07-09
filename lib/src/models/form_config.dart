class FormConfig {
  final String id;
  final String? title;
  final List<FieldConfig> fields;

  FormConfig({
    required this.id,
    this.title,
    required this.fields,
  });

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

class FieldConfig {
  final String key;
  final String type;
  final String? label;
  final bool required;
  final Map<String, dynamic> extra;

  FieldConfig({
    required this.key,
    required this.type,
    this.label,
    this.required = false,
    this.extra = const {},
  });

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