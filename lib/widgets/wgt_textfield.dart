import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WgtTextfield extends StatelessWidget {
  String? hint;
  IconData? icon;
  bool obscureText;
  TextEditingController? controller;
  TextAlign textAlign;
  void Function(String)? onChanged;
  TextInputType? keyboardType;
  String label;
  bool autofocus;
  bool hasBoder;
  bool onlyNumber;
  String errorText;
  int? maxLength;
  Widget? suffixIcon;
  int? maxLines;
  bool? enabled;
  bool readOnly;
  void Function()? onTap;
  WgtTextfield(
      {super.key,
      this.hint,
      this.icon,
      this.obscureText = false,
      this.controller,
      this.textAlign = TextAlign.start,
      this.onChanged,
      this.keyboardType,
      this.label = '',
      this.autofocus = false,
      this.errorText = '',
      this.onlyNumber = false,
      this.hasBoder = false,
      this.maxLength,
      this.suffixIcon,
      this.maxLines,
      this.enabled,
      this.readOnly = false,
      this.onTap
      });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      maxLength: maxLength,
      maxLines:obscureText ? 1 : maxLines ,
      textAlign: textAlign,
      onChanged: onChanged,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      onTap: onTap,
      inputFormatters: onlyNumber  ? [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        FilteringTextInputFormatter.digitsOnly
      ] : null,
      decoration: InputDecoration(
        label: label == '' ? null : Text(label),
        counterText: '',

        errorText: errorText == ''? null : errorText,
        errorMaxLines: 1,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: hasBoder ? const BorderSide() : BorderSide.none),
        fillColor: Colors.white.withOpacity(.8),
        contentPadding: const EdgeInsets.only(bottom: 5, left: 8,right: 8),
        hintText: hint,
        filled: true,
        prefixIcon: icon == null ? null : Icon(icon),
        suffixIcon: suffixIcon
      ),
    );
  }
}
