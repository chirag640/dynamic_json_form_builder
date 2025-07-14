import 'package:flutter/material.dart';
import '../../models/form_config.dart';
import '../../themes/form_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';

class JsonColorField extends StatefulWidget {
  final FieldConfig config;
  final ValueChanged<Color>? onChanged;
  final ValueChanged<String?>? onValidation;
  final Color? initialValue;
  final FormTheme? theme;

  const JsonColorField({
    Key? key,
    required this.config,
    this.onChanged,
    this.onValidation,
    this.initialValue,
    this.theme,
  }) : super(key: key);

  @override
  State<JsonColorField> createState() => _JsonColorFieldState();
}

class _JsonColorFieldState extends State<JsonColorField> {
  late Color _selectedColor;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialValue ?? Colors.blue;
  }

  void _onChanged(Color color) {
    setState(() {
      _selectedColor = color;
      _errorText = _validate(color);
    });
    widget.onChanged?.call(color);
    widget.onValidation?.call(_errorText);
  }

  String? _validate(Color value) {
    final isRequired = widget.config.required;
    if (isRequired && value == Colors.transparent) {
      return (widget.config.label ?? widget.config.key) + ' is required';
    }
    return null;
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Color'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Basic colors
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Colors.red,
                  Colors.pink,
                  Colors.purple,
                  Colors.deepPurple,
                  Colors.indigo,
                  Colors.blue,
                  Colors.lightBlue,
                  Colors.cyan,
                  Colors.teal,
                  Colors.green,
                  Colors.lightGreen,
                  Colors.lime,
                  Colors.yellow,
                  Colors.amber,
                  Colors.orange,
                  Colors.deepOrange,
                  Colors.brown,
                  Colors.grey,
                  Colors.blueGrey,
                  Colors.black,
                ].map((color) => GestureDetector(
                  onTap: () {
                    _onChanged(color);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _selectedColor == color ? Colors.white : Colors.grey[300]!,
                        width: _selectedColor == color ? 3 : 1,
                      ),
                    ),
                    child: _selectedColor == color
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
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
    
    final showHexValue = extra['showHexValue'] ?? true;
    
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
                if (showHexValue)
                  AutoSizeText(
                    '#${_selectedColor.value.toRadixString(16).substring(2).toUpperCase()}',
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
          child: InkWell(
            onTap: _showColorPicker,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
              child: Row(
                children: [
                  Container(
                    width: isSmallScreen ? 40 : 50,
                    height: isSmallScreen ? 40 : 50,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Selected Color',
                          style: theme?.inputStyle,
                          maxLines: 1,
                          minFontSize: 12,
                        ),
                        if (showHexValue)
                          AutoSizeText(
                            '#${_selectedColor.value.toRadixString(16).substring(2).toUpperCase()}',
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
                  Icon(
                    Icons.palette,
                    color: theme?.primaryColor ?? Colors.deepPurple,
                    size: isSmallScreen ? 20 : 24,
                  ),
                ],
              ),
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
