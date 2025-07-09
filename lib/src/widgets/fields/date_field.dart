import 'package:flutter/material.dart';
import '../../models/form_config.dart';
import '../../themes/form_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';

class JsonDateField extends StatefulWidget {
  final FieldConfig config;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String?>? onValidation;
  final String? initialValue;
  final FormTheme? theme;

  const JsonDateField({Key? key, required this.config, this.onChanged, this.onValidation, this.initialValue, this.theme}) : super(key: key);

  @override
  State<JsonDateField> createState() => _JsonDateFieldState();
}

class _JsonDateFieldState extends State<JsonDateField> {
  String? _selectedDate;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialValue;
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final value = picked.toIso8601String().split('T').first;
      setState(() {
        _selectedDate = value;
        _errorText = _validate(value);
      });
      widget.onChanged?.call(value);
      widget.onValidation?.call(_errorText);
    }
  }

  String? _validate(String? value) {
    final isRequired = widget.config.required;
    if (isRequired && (value == null || value.isEmpty)) {
      return (widget.config.label ?? widget.config.key) + ' is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final label = config.label ?? config.key;
    final helperText = config.extra['helperText'];
    final placeholder = config.extra['placeholder'] ?? '';
    final theme = widget.theme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 500;
    final verticalPad = isSmallScreen ? 8.0 : 12.0;
    final horizontalPad = isSmallScreen ? 10.0 : 16.0;
    final iconSize = isSmallScreen ? 18.0 : 24.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (theme?.labelAboveField ?? true)
          Padding(
            padding: EdgeInsets.only(bottom: theme?.labelSpacing ?? 8),
            child: AutoSizeText(label, style: theme?.labelStyle, maxLines: 1, minFontSize: 12),
          ),
        Container(
          decoration: BoxDecoration(
            color: theme?.backgroundColor ?? Colors.white,
            borderRadius: (theme?.inputBorder is OutlineInputBorder)
                ? (theme?.inputBorder as OutlineInputBorder).borderRadius
                : BorderRadius.circular(8),
            boxShadow: theme?.inputShadow,
          ),
          child: GestureDetector(
            onTap: _pickDate,
            child: AbsorbPointer(
              child: TextFormField(
                controller: TextEditingController(text: _selectedDate ?? ''),
                style: theme?.inputStyle,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: verticalPad, horizontal: horizontalPad),
                  labelText: null,
                  labelStyle: null,
                  helperText: helperText,
                  helperStyle: theme?.helperStyle,
                  errorText: _errorText,
                  errorStyle: theme?.errorStyle,
                  border: theme?.inputBorder ?? const OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today, size: iconSize),
                  filled: true,
                  fillColor: theme?.backgroundColor ?? Colors.white,
                  hintText: placeholder.isNotEmpty ? placeholder : null,
                  hintStyle: theme?.inputStyle?.copyWith(color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 