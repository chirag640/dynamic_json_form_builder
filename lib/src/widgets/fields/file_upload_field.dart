import 'package:flutter/material.dart';
import '../../models/form_config.dart';
import '../../themes/form_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';

class JsonFileUploadField extends StatefulWidget {
  final FieldConfig config;
  final ValueChanged<List<String>>? onChanged;
  final ValueChanged<String?>? onValidation;
  final List<String>? initialValue;
  final FormTheme? theme;

  const JsonFileUploadField({Key? key, required this.config, this.onChanged, this.onValidation, this.initialValue, this.theme}) : super(key: key);

  @override
  State<JsonFileUploadField> createState() => _JsonFileUploadFieldState();
}

class _JsonFileUploadFieldState extends State<JsonFileUploadField> {
  late List<String> _files;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _files = widget.initialValue ?? [];
  }

  void _pickFile() async {
    // Placeholder: In real use, integrate with file_picker/image_picker
    setState(() {
      _files.add('mock_file_${_files.length + 1}.png');
      _errorText = _validate(_files);
    });
    widget.onChanged?.call(_files);
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
    final label = config.label ?? config.key;
    final helperText = config.extra['helperText'];
    final allowMultiple = config.extra['multiple'] ?? false;
    final theme = widget.theme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 500;
    final iconSize = isSmallScreen ? 18.0 : 24.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: Icon(Icons.attach_file, size: iconSize),
              label: AutoSizeText(allowMultiple ? 'Add Files' : 'Add File', style: theme?.inputStyle, maxLines: 1, minFontSize: 12),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme?.primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            AutoSizeText(label, style: theme?.inputStyle, maxLines: 1, minFontSize: 12),
          ],
        ),
        if (_files.isNotEmpty)
          Wrap(
            spacing: 8,
            children: _files.map((file) => Chip(label: AutoSizeText(file, style: theme?.inputStyle, maxLines: 1, minFontSize: 10))).toList(),
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