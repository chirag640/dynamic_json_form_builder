import 'package:flutter/material.dart';
import '../../models/form_config.dart';
import '../../themes/form_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';

class JsonSliderField extends StatefulWidget {
  final FieldConfig config;
  final ValueChanged<double>? onChanged;
  final ValueChanged<String?>? onValidation;
  final double? initialValue;
  final FormTheme? theme;

  const JsonSliderField({
    Key? key,
    required this.config,
    this.onChanged,
    this.onValidation,
    this.initialValue,
    this.theme,
  }) : super(key: key);

  @override
  State<JsonSliderField> createState() => _JsonSliderFieldState();
}

class _JsonSliderFieldState extends State<JsonSliderField> {
  late double _value;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final extra = widget.config.extra;
    final min = (extra['min'] ?? 0).toDouble();
    final max = (extra['max'] ?? 100).toDouble();
    _value = widget.initialValue ?? min;
    
    // Ensure value is within bounds
    if (_value < min) _value = min;
    if (_value > max) _value = max;
  }

  void _onChanged(double value) {
    setState(() {
      _value = value;
      _errorText = _validate(value);
    });
    widget.onChanged?.call(value);
    widget.onValidation?.call(_errorText);
  }

  String? _validate(double value) {
    final isRequired = widget.config.required;
    final extra = widget.config.extra;
    final min = (extra['min'] ?? 0).toDouble();
    final max = (extra['max'] ?? 100).toDouble();
    
    if (isRequired && value == min && (extra['requireNonZero'] == true)) {
      return (widget.config.label ?? widget.config.key) + ' is required';
    }
    
    if (value < min || value > max) {
      return 'Value must be between $min and $max';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final extra = config.extra;
    final label = config.label ?? config.key;
    final helperText = extra['helperText'];
    final theme = widget.theme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 500;
    
    final min = (extra['min'] ?? 0).toDouble();
    final max = (extra['max'] ?? 100).toDouble();
    final divisions = extra['divisions'] as int?;
    final showLabels = extra['showLabels'] ?? true;
    final showValue = extra['showValue'] ?? true;
    final prefix = extra['prefix'] ?? '';
    final suffix = extra['suffix'] ?? '';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (theme?.labelAboveField ?? true)
          Padding(
            padding: EdgeInsets.only(bottom: theme?.labelSpacing ?? 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: AutoSizeText(
                    label,
                    style: theme?.labelStyle,
                    maxLines: 1,
                    minFontSize: 12,
                  ),
                ),
                if (showValue)
                  AutoSizeText(
                    '$prefix${_value.toStringAsFixed(divisions != null ? 0 : 1)}$suffix',
                    style: theme?.inputStyle?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme?.primaryColor,
                    ),
                    maxLines: 1,
                    minFontSize: 12,
                  ),
              ],
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: theme?.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: theme?.inputShadow,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8.0 : 16.0,
              vertical: isSmallScreen ? 4.0 : 8.0,
            ),
            child: Column(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: theme?.primaryColor ?? Colors.deepPurple,
                    inactiveTrackColor: theme?.primaryColor?.withOpacity(0.3) ?? Colors.grey[300],
                    thumbColor: theme?.primaryColor ?? Colors.deepPurple,
                    overlayColor: theme?.primaryColor?.withOpacity(0.2) ?? Colors.deepPurple.withOpacity(0.2),
                    valueIndicatorColor: theme?.primaryColor ?? Colors.deepPurple,
                    valueIndicatorTextStyle: theme?.inputStyle?.copyWith(color: Colors.white),
                  ),
                  child: Slider(
                    value: _value,
                    min: min,
                    max: max,
                    divisions: divisions,
                    onChanged: _onChanged,
                    label: showValue ? '$prefix${_value.toStringAsFixed(divisions != null ? 0 : 1)}$suffix' : null,
                  ),
                ),
                if (showLabels)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          '$prefix${min.toStringAsFixed(divisions != null ? 0 : 1)}$suffix',
                          style: theme?.helperStyle ?? TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          minFontSize: 10,
                        ),
                        AutoSizeText(
                          '$prefix${max.toStringAsFixed(divisions != null ? 0 : 1)}$suffix',
                          style: theme?.helperStyle ?? TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          minFontSize: 10,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: AutoSizeText(
              _errorText!,
              style: theme?.errorStyle ?? TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
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
