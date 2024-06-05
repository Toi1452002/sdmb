
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class WgtDropdown extends StatelessWidget {
  double width;
  double height;
  List<String> items;
  String hint;
  String? value;
  Color? color;
  bool? disable;
  void Function(String?)? onChange;

  WgtDropdown(
      {this.width = 100,
        this.height = 40,
        required this.items,
        this.hint = "",
        this.value,
        this.color,
        this.disable,
        required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey,),color:color?? Colors.white),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(

          alignedDropdown: true,
          child: DropdownButton(
            isExpanded: true,
            dropdownColor: Colors.white,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.black,

            ),
            hint: Text(hint,style: Theme.of(context).textTheme.bodyMedium,),
            value: value,
            items: items.map((String e) => DropdownMenuItem(
              value: e,
              child: Text(e,style: Theme.of(context).textTheme.bodyMedium,),
            ))
                .toList(),

            onChanged: disable??false ? null : onChange,
            menuMaxHeight: 200,
          ),
        ),
      ),
    );
  }
}
