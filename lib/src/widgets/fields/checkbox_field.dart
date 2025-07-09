import 'package:flutter/material.dart';
import '../../models/form_config.dart';
import '../../themes/form_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';

class JsonCheckboxField extends StatefulWidget {
  final FieldConfig config;
  final ValueChanged<bool>? onChanged;
  final ValueChanged<String?>? onValidation;
  final bool? initialValue;
  final FormTheme? theme;

  const JsonCheckboxField({Key? key, required this.config, this.onChanged, this.onValidation, this.initialValue, this.theme}) : super(key: key);

  @override
  State<JsonCheckboxField> createState() => _JsonCheckboxFieldState();
}

class _JsonCheckboxFieldState extends State<JsonCheckboxField> {
  bool _checked = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _checked = widget.initialValue ?? false;
  }

  void _onChanged(bool? value) {
    setState(() {
      _checked = value ?? false;
      _errorText = _validate(_checked);
    });
    widget.onChanged?.call(_checked);
    widget.onValidation?.call(_errorText);
  }

  String? _validate(bool value) {
    final isRequired = widget.config.required;
    if (isRequired && !value) {
      return (widget.config.label ?? widget.config.key) + ' is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final label = config.label ?? config.key;
    final helperText = config.extra['helperText'];
    final theme = widget.theme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 500;
    final iconSize = isSmallScreen ? 18.0 : 24.0;
    final verticalPad = isSmallScreen ? 8.0 : 12.0;
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
          child: Row(
            children: [
              Checkbox(
                value: _checked,
                onChanged: _onChanged,
                activeColor: theme?.primaryColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              Flexible(
                child: AutoSizeText(label, style: theme?.inputStyle, maxLines: 1, minFontSize: 12),
              ),
            ],
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: AutoSizeText(
              _errorText!,
              style: theme?.errorStyle ?? TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
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