import 'package:flutter/material.dart';
import '../../models/form_config.dart';
import '../../themes/form_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';

class JsonRatingField extends StatefulWidget {
  final FieldConfig config;
  final ValueChanged<double>? onChanged;
  final ValueChanged<String?>? onValidation;
  final double? initialValue;
  final FormTheme? theme;

  const JsonRatingField({
    Key? key,
    required this.config,
    this.onChanged,
    this.onValidation,
    this.initialValue,
    this.theme,
  }) : super(key: key);

  @override
  State<JsonRatingField> createState() => _JsonRatingFieldState();
}

class _JsonRatingFieldState extends State<JsonRatingField> {
  late double _rating;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialValue ?? 0.0;
  }

  void _onChanged(double rating) {
    setState(() {
      _rating = rating;
      _errorText = _validate(rating);
    });
    widget.onChanged?.call(rating);
    widget.onValidation?.call(_errorText);
  }

  String? _validate(double value) {
    final isRequired = widget.config.required;
    if (isRequired && value == 0.0) {
      return (widget.config.label ?? widget.config.key) + ' is required';
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
    
    final maxRating = (extra['maxRating'] ?? 5).toInt();
    final allowHalfRating = extra['allowHalfRating'] ?? false;
    final showLabels = extra['showLabels'] ?? false;
    final labels = extra['labels'] as List<String>? ?? [];
    final starSize = (extra['starSize'] ?? (isSmallScreen ? 30.0 : 40.0)).toDouble();
    final showValue = extra['showValue'] ?? true;
    
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
                    '${_rating.toStringAsFixed(allowHalfRating ? 1 : 0)}/$maxRating',
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
              vertical: isSmallScreen ? 8.0 : 12.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(maxRating, (index) {
                    final starIndex = index + 1;
                    final isFullStar = _rating >= starIndex;
                    final isHalfStar = allowHalfRating && _rating >= starIndex - 0.5 && _rating < starIndex;
                    
                    return GestureDetector(
                      onTap: () {
                        double newRating;
                        if (allowHalfRating) {
                          // If current rating is the same as star index, set to half
                          if (_rating == starIndex) {
                            newRating = starIndex - 0.5;
                          } else {
                            newRating = starIndex.toDouble();
                          }
                        } else {
                          newRating = starIndex.toDouble();
                        }
                        _onChanged(newRating);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(
                          isFullStar
                              ? Icons.star
                              : isHalfStar
                                  ? Icons.star_half
                                  : Icons.star_border,
                          color: (isFullStar || isHalfStar)
                              ? (theme?.primaryColor ?? Colors.amber)
                              : Colors.grey[400],
                          size: starSize,
                        ),
                      ),
                    );
                  }),
                ),
                if (showLabels && labels.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: AutoSizeText(
                      _rating > 0 && _rating <= labels.length
                          ? labels[_rating.ceil() - 1]
                          : '',
                      style: theme?.helperStyle ?? TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      textAlign: TextAlign.center,
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
