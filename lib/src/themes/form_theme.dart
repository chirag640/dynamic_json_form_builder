import 'package:flutter/material.dart';

class FormTheme {
  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? errorColor;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final TextStyle? helperStyle;
  final TextStyle? errorStyle;
  final InputBorder? inputBorder;
  final List<BoxShadow>? inputShadow;
  final double? labelSpacing;
  final bool labelAboveField;

  const FormTheme({
    this.primaryColor,
    this.backgroundColor,
    this.errorColor,
    this.labelStyle,
    this.inputStyle,
    this.helperStyle,
    this.errorStyle,
    this.inputBorder,
    this.inputShadow,
    this.labelSpacing,
    this.labelAboveField = true,
  });

  factory FormTheme.light() => FormTheme(
    primaryColor: Colors.deepPurple,
    backgroundColor: Colors.white,
    errorColor: Colors.red,
    labelStyle: const TextStyle(fontWeight: FontWeight.w600),
    inputStyle: const TextStyle(),
    helperStyle: const TextStyle(color: Colors.grey),
    errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
    inputBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    inputShadow: [
      BoxShadow(
        color: Colors.deepPurpleAccent.withAlpha((0.08 * 255).toInt()),
        blurRadius: 12,
        offset: Offset(0, 4),
      ),
    ],
    labelSpacing: 8,
    labelAboveField: true,
  );

  factory FormTheme.dark() => FormTheme(
    primaryColor: Colors.deepPurple[200],
    backgroundColor: const Color(0xFF23232B),
    errorColor: Colors.red[200],
    labelStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
    inputStyle: const TextStyle(color: Colors.white),
    helperStyle: const TextStyle(color: Colors.grey),
    errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
    inputBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    inputShadow: [
      BoxShadow(
        color: Colors.deepPurple.withAlpha((0.15 * 255).toInt()),
        blurRadius: 14,
        offset: Offset(0, 4),
      ),
    ],
    labelSpacing: 8,
    labelAboveField: true,
  );
} 