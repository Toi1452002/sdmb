import 'package:flutter/material.dart';
class ErrorController extends TextEditingController{
  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style , required bool withComposing}) {
    List<TextSpan> child = [];
    text.splitMapJoin(RegExp(r"\B [a-zA-Z0-9]+\b"),onMatch:(Match m){
      child.add(TextSpan(text: m.group(0),style: const TextStyle(color: Colors.red)));
      return "";
    },onNonMatch:(String a){
      child.add(TextSpan(text: a));
      return text;
    });
    return TextSpan(children: child,style: style);
  }
}