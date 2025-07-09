import 'package:flutter/material.dart';
import '../../models/form_config.dart';
import '../../themes/form_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';

class JsonMultiSelectField extends StatefulWidget {
  final FieldConfig config;
  final ValueChanged<List<String>>? onChanged;
  final ValueChanged<String?>? onValidation;
  final List<String>? initialValue;
  final FormTheme? theme;

  const JsonMultiSelectField({Key? key, required this.config, this.onChanged, this.onValidation, this.initialValue, this.theme}) : super(key: key);

  @override
  State<JsonMultiSelectField> createState() => _JsonMultiSelectFieldState();
}

class _JsonMultiSelectFieldState extends State<JsonMultiSelectField> {
  late List<String> _selected;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue ?? [];
  }

  void _onChanged(bool? checked, String value) {
    setState(() {
      if (checked == true) {
        _selected.add(value);
      } else {
        _selected.remove(value);
      }
      _errorText = _validate(_selected);
    });
    widget.onChanged?.call(_selected);
    widget.onValidation?.call(_errorText);
  }

  String? _validate(List<String> value) {
    final isRequired = widget.config.required;
    if (isRequired && value.isEmpty) {
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
              if (_selected.isEmpty && placeholder.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: verticalPad),
                  child: AutoSizeText(
                    placeholder,
                    style: theme?.inputStyle?.copyWith(color: Colors.grey),
                    maxLines: 1,
                    minFontSize: 12,
                  ),
                ),
              ...options.map((option) => CheckboxListTile(
                value: _selected.contains(option),
                onChanged: (checked) => _onChanged(checked, option),
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