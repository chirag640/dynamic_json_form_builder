import 'package:flutter/material.dart';
import '../../models/form_config.dart';
import 'package:flutter/services.dart';
import '../../themes/form_theme.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';

class JsonTextField extends StatefulWidget {
  final FieldConfig config;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String?>? onValidation;
  final String? initialValue;
  final FormTheme? theme;

  const JsonTextField({Key? key, required this.config, this.onChanged, this.onValidation, this.initialValue, this.theme}) : super(key: key);

  @override
  State<JsonTextField> createState() => _JsonTextFieldState();
}

class _JsonTextFieldState extends State<JsonTextField> {
  late TextEditingController _controller;
  bool _isPasswordVisible = false;
  String? _errorText;
  String? _asyncErrorText;
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final value = _controller.text;
    final error = _validateInput(value);
    setState(() {
      _errorText = error;
      _asyncErrorText = null;
    });
    widget.onChanged?.call(value);
    widget.onValidation?.call(error);
    _debounce?.cancel();
    if (widget.config.extra['asyncValidation'] != null && error == null) {
      _debounce = Timer(const Duration(milliseconds: 500), () => _runAsyncValidation(value));
    }
  }

  Future<void> _runAsyncValidation(String value) async {
    setState(() { _isLoading = true; });
    final asyncValidation = widget.config.extra['asyncValidation'];
    String? asyncError;
    try {
      if (asyncValidation is Future<bool> Function(String)) {
        final valid = await asyncValidation(value);
        if (!valid) {
          asyncError = widget.config.extra['asyncValidationError'] ?? 'Invalid value (async)';
        }
      } else if (asyncValidation is String) {
        // Treat as endpoint URL, simulate API call
        await Future.delayed(const Duration(milliseconds: 800));
        if (value == 'taken') {
          asyncError = widget.config.extra['asyncValidationError'] ?? 'Value is already taken';
        }
      }
    } catch (e) {
      asyncError = 'Validation error';
    }
    setState(() {
      _asyncErrorText = asyncError;
      _isLoading = false;
    });
    widget.onValidation?.call(_errorText ?? asyncError);
  }

  String? _validateInput(String value) {
    final config = widget.config;
    final extra = config.extra;
    final isRequired = config.required;
    final minLength = extra['minLength'];
    final maxLength = extra['maxLength'];
    final pattern = extra['pattern'];
    final fieldType = config.type;

    // Required validation
    if (isRequired && value.isEmpty) {
      return (config.label ?? config.key) + ' is required';
    }
    if (value.isEmpty) return null;

    // Length validations
    if (minLength != null && value.length < minLength) {
      return 'Minimum $minLength characters required';
    }
    if (maxLength != null && value.length > maxLength) {
      return 'Maximum $maxLength characters allowed';
    }

    // Pattern validation
    if (pattern != null) {
      final regex = RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return extra['patternError'] ?? 'Invalid format';
      }
    }

    // Type-specific validations
    switch (fieldType) {
      case 'email':
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4} $');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        break;
      case 'phone':
        final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,} $');
        if (!phoneRegex.hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        break;
      case 'number':
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        break;
    }
    return null;
  }

  TextInputType _getKeyboardType(String fieldType) {
    switch (fieldType) {
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      case 'number':
        return TextInputType.number;
      case 'multiline':
        return TextInputType.multiline;
      case 'url':
        return TextInputType.url;
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter> _getInputFormatters(Map<String, dynamic> extra, String fieldType) {
    final formatters = <TextInputFormatter>[];
    if (extra['maxLength'] != null) {
      formatters.add(LengthLimitingTextInputFormatter(extra['maxLength']));
    }
    switch (fieldType) {
      case 'number':
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')));
        break;
      case 'phone':
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[\d\+\-\s\(\)]')));
        break;
      case 'alphanumeric':
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')));
        break;
      case 'alphabetic':
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')));
        break;
    }
    if (extra['allowedCharacters'] != null) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp(extra['allowedCharacters'])));
    }
    return formatters;
  }

  Widget? _buildSuffixIcon(String fieldType, Map<String, dynamic> extra) {
    final suffixIcon = extra['suffixIcon'];
    List<Widget> icons = [];
    if (fieldType == 'password') {
      icons.add(IconButton(
        icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      ));
    }
    if (suffixIcon != null) {
      icons.add(Icon(Icons.text_fields)); // Placeholder, map string to icon if needed
    }
    if (icons.isEmpty) return null;
    if (icons.length == 1) return icons.first;
    return Row(mainAxisSize: MainAxisSize.min, children: icons);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final config = widget.config;
    final extra = config.extra;
    final label = config.label ?? config.key;
    final helperText = extra['helperText'];
    final placeholder = extra['placeholder'] ?? '';
    final isPassword = config.type == 'password';
    final size = MediaQuery.of(context).size;
    final iconSize = size.width < 500 ? 18.0 : 24.0;
    final verticalPad = size.width < 500 ? 8.0 : 12.0;
    final horizontalPad = size.width < 500 ? 10.0 : 16.0;
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
          child: TextField(
            controller: _controller,
            obscureText: isPassword && !_isPasswordVisible,
            keyboardType: _getKeyboardType(config.type),
            inputFormatters: _getInputFormatters(extra, config.type),
            style: theme?.inputStyle,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: verticalPad, horizontal: horizontalPad),
              border: theme?.inputBorder ?? const OutlineInputBorder(),
              filled: true,
              fillColor: theme?.backgroundColor ?? Colors.white,
              hintText: placeholder.isNotEmpty ? placeholder : null,
              hintStyle: theme?.inputStyle?.copyWith(color: Colors.grey),
              suffixIcon: _buildSuffixIcon(config.type, extra) != null
                  ? IconTheme(
                      data: IconThemeData(size: iconSize),
                      child: _buildSuffixIcon(config.type, extra)!,
                    )
                  : null,
              errorText: _errorText ?? _asyncErrorText,
              errorStyle: theme?.errorStyle,
            ),
            minLines: config.type == 'multiline' ? 3 : 1,
            maxLines: config.type == 'multiline' ? null : 1,
          ),
        ),
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        if (_errorText != null || _asyncErrorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: AutoSizeText(
              _errorText ?? _asyncErrorText ?? '',
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