import 'package:flutter/material.dart';
import '../../models/form_config.dart';
import 'text_field.dart';
import 'dropdown_field.dart';
import 'date_field.dart';
import 'checkbox_field.dart';
import 'radio_field.dart';
import 'multi_select_field.dart';
import 'file_upload_field.dart';
import 'slider_field.dart';
import 'rating_field.dart';
import 'color_field.dart';
import '../../themes/form_theme.dart';
import '../json_form_builder.dart';

class FieldFactory {
  static Widget build(
    FieldConfig config, {
    ValueChanged<dynamic>? onChanged,
    ValueChanged<String?>? onValidation,
    dynamic initialValue,
    FormTheme? theme,
    Map<String, FieldWidgetBuilder>? customFieldBuilders,
  }) {
    if (customFieldBuilders != null && customFieldBuilders.containsKey(config.type)) {
      return customFieldBuilders[config.type]!(
        config,
        onChanged: onChanged,
        onValidation: onValidation,
        initialValue: initialValue,
        theme: theme,
      );
    }
    switch (config.type) {
      case 'text':
      case 'email':
      case 'password':
      case 'number':
      case 'phone':
      case 'multiline':
        return JsonTextField(
          config: config,
          onChanged: onChanged as ValueChanged<String>?,
          onValidation: onValidation,
          initialValue: initialValue as String?,
          theme: theme,
        );
      case 'dropdown':
        return JsonDropdownField(
          config: config,
          onChanged: onChanged as ValueChanged<String>?,
          onValidation: onValidation,
          initialValue: initialValue as String?,
          theme: theme,
        );
      case 'date':
        return JsonDateField(
          config: config,
          onChanged: onChanged as ValueChanged<String>?,
          onValidation: onValidation,
          initialValue: initialValue as String?,
          theme: theme,
        );
      case 'checkbox':
        return JsonCheckboxField(
          config: config,
          onChanged: onChanged as ValueChanged<bool>?,
          onValidation: onValidation,
          initialValue: initialValue as bool?,
          theme: theme,
        );
      case 'radio':
        return JsonRadioField(
          config: config,
          onChanged: onChanged as ValueChanged<String>?,
          onValidation: onValidation,
          initialValue: initialValue as String?,
          theme: theme,
        );
      case 'multi_select':
        return JsonMultiSelectField(
          config: config,
          onChanged: onChanged as ValueChanged<List<String>>?,
          onValidation: onValidation,
          initialValue: initialValue as List<String>?,
          theme: theme,
        );
      case 'file':
        return JsonFileUploadField(
          config: config,
          onChanged: onChanged as ValueChanged<List<String>>?,
          onValidation: onValidation,
          initialValue: initialValue as List<String>?,
          theme: theme,
        );
      case 'slider':
      case 'range':
        return JsonSliderField(
          config: config,
          onChanged: onChanged as ValueChanged<double>?,
          onValidation: onValidation,
          initialValue: initialValue as double?,
          theme: theme,
        );
      case 'rating':
        return JsonRatingField(
          config: config,
          onChanged: onChanged as ValueChanged<double>?,
          onValidation: onValidation,
          initialValue: initialValue as double?,
          theme: theme,
        );
      case 'color':
        return JsonColorField(
          config: config,
          onChanged: onChanged as ValueChanged<Color>?,
          onValidation: onValidation,
          initialValue: initialValue as Color?,
          theme: theme,
        );
      default:
        return const SizedBox.shrink();
    }
  }
} 