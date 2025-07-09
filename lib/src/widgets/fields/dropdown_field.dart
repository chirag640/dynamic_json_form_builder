import 'package:flutter/material.dart';
import '../../models/form_config.dart';
import '../../themes/form_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';

class JsonDropdownField extends StatefulWidget {
  final FieldConfig config;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String?>? onValidation;
  final String? initialValue;
  final FormTheme? theme;

  const JsonDropdownField({
    Key? key,
    required this.config,
    this.onChanged,
    this.onValidation,
    this.initialValue,
    this.theme,
  }) : super(key: key);

  @override
  State<JsonDropdownField> createState() => _JsonDropdownFieldState();
}

class _JsonDropdownFieldState extends State<JsonDropdownField> {
  String? _selected;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  void _onChanged(String? value) {
    setState(() {
      _selected = value;
      _errorText = _validate(value);
    });
    if (value != null) widget.onChanged?.call(value);
    widget.onValidation?.call(_errorText);
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
    final extra = config.extra;
    final label = config.label ?? config.key;
    final options = List<String>.from(extra['options'] ?? []);
    final helperText = extra['helperText'];
    final placeholder = extra['placeholder'] ?? '';
    final theme = widget.theme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 500;
    final verticalPad = isSmallScreen ? 8.0 : 12.0;
    final horizontalPad = isSmallScreen ? 10.0 : 16.0;
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
          child: DropdownButtonFormField<String>(
            value: _selected,
            isExpanded: true, // Fix overflow
            items: options
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: AutoSizeText(
                        e,
                        style: theme?.inputStyle,
                        maxLines: 1,
                        minFontSize: 12,
                        overflow: TextOverflow.ellipsis, // Prevent overflow
                      ),
                    ))
                .toList(),
            onChanged: _onChanged,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: verticalPad, horizontal: horizontalPad),
              labelText: null,
              labelStyle: null,
              helperText: helperText,
              helperStyle: theme?.helperStyle,
              errorText: _errorText,
              errorStyle: theme?.errorStyle,
              border: theme?.inputBorder ?? const OutlineInputBorder(),
              filled: true,
              fillColor: theme?.backgroundColor ?? Colors.white,
              hintText: placeholder.isNotEmpty ? placeholder : null,
              hintStyle: theme?.inputStyle?.copyWith(color: Colors.grey),
            ),
            hint: placeholder.isNotEmpty
                ? AutoSizeText(
                    placeholder,
                    style: theme?.inputStyle?.copyWith(color: Colors.grey),
                    maxLines: 1,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  )
                : null,
          ),
        ),
      ],
    );
  }
} 