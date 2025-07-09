import 'package:flutter/material.dart';
import '../../models/form_config.dart';
import '../../themes/form_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';

class JsonRadioField extends StatefulWidget {
  final FieldConfig config;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String?>? onValidation;
  final String? initialValue;
  final FormTheme? theme;

  const JsonRadioField({Key? key, required this.config, this.onChanged, this.onValidation, this.initialValue, this.theme}) : super(key: key);

  @override
  State<JsonRadioField> createState() => _JsonRadioFieldState();
}

class _JsonRadioFieldState extends State<JsonRadioField> {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selected == null && placeholder.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: verticalPad),
                  child: AutoSizeText(
                    placeholder,
                    style: theme?.inputStyle?.copyWith(color: Colors.grey),
                    maxLines: 1,
                    minFontSize: 12,
                  ),
                ),
              ...options.map((option) => RadioListTile<String>(
                value: option,
                groupValue: _selected,
                onChanged: _onChanged,
                title: AutoSizeText(option, style: theme?.inputStyle, maxLines: 1, minFontSize: 12),
                activeColor: theme?.primaryColor,
                contentPadding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 0),
                dense: isSmallScreen,
              )),
            ],
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: AutoSizeText(
              _errorText!,
              style: theme?.errorStyle ?? Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              minFontSize: 10,
            ),
          ),
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: AutoSizeText(
              helperText,
              style: theme?.helperStyle ?? Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              minFontSize: 10,
            ),
          ),
      ],
    );
  }
} 