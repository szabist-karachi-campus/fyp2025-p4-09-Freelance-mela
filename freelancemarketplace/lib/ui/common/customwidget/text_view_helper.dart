// ignore_for_file: must_be_immutable, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ui_helpers.dart';
import './text_helper.dart';

class text_view_helper extends StatelessWidget {
  text_view_helper({
    super.key,
    required this.hint,
    required this.controller,
    this.size = fontSize10,
    this.hintcol,
    this.textcolor,
    this.fontWeight = FontWeight.w500,
    this.obsecure = false,
    this.textInputType = TextInputType.text,
    this.maxline = 1,
    this.maxlength,
    this.padding = const EdgeInsetsDirectional.all(5),
    this.prefix,
    this.suffix,
    this.onchange,
    this.onsubmit,
    this.formatter = const [],
    this.isError = false,
  });

  String hint;
  double? size;
  Color? hintcol, textcolor;
  bool obsecure;
  FontWeight fontWeight;
  int? maxline, maxlength;
  TextInputType textInputType;
  TextEditingController controller;
  EdgeInsetsDirectional padding;
  final Function(String)? onchange;
  final Function(String)? onsubmit;
  List<TextInputFormatter> formatter;
  Widget? prefix, suffix;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 4),
          ),
          errorBorder: isError
              ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 4),
          )
              : null,
          counterText: "",
          hintStyle: text_helper.customstyle(
              hintcol, size, context, FontWeight.normal, null),
          hintText: "",
          labelText: hint,
          labelStyle: text_helper.customstyle(
              hintcol, size, context, FontWeight.normal, null),
          prefixIcon: prefix,
          suffix: suffix,
        ),
        cursorWidth: 4,
        cursorRadius: const Radius.circular(10),
        inputFormatters: formatter.isNotEmpty
            ? formatter
            : [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
        ],
        obscureText: obsecure,
        maxLines: maxline,
        maxLength: maxlength,
        onFieldSubmitted:
        onsubmit != null ? (value) => onsubmit!(value) : null,
        onChanged: onchange != null ? (value) => onchange!(value) : null,
        style: text_helper.customstyle(
            textcolor, size, context, fontWeight, null),
      ),
    );
  }
}
