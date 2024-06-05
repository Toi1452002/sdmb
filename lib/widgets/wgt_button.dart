import 'package:flutter/material.dart';

class WgtButton extends StatelessWidget {
  WgtButton({super.key, this.onPressed, required this.text, this.width, this.height, this.color, this.enable = true});
  void Function()? onPressed;
  String text;
  double? width;
  double? height;
  Color? color;
  bool enable;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      child: ElevatedButton(onPressed: enable ?  onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:  color ,

          foregroundColor: color == null ? null : Colors.white ,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
        ), child: Text(text),
      ),
    );
  }
}
