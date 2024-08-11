import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlashToast {
  BuildContext context;

  FlashToast(this.context);

  showInfo(String content) {
    context.showInfoBar(

      content: Text(content),
      position: FlashPosition.top,
    );
  }

  showError(String content) {
    context.showErrorBar(
      content: Text(content),
      position: FlashPosition.top,
    );
  }
  showSuccess(String content) {
    context.showSuccessBar(
      content: Text(content),
      position: FlashPosition.top,
    );
  }


  showAlert(String title, String content,void Function()? onPressed){
    showDialog(context: context,barrierDismissible: false, builder: (_){
      return AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.only(left: 15,top: 10),
        actionsPadding: const EdgeInsets.only(top: 20,right: 5,bottom: 10),
        titlePadding: const EdgeInsets.only(left: 15,top: 15),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Hủy')),
          TextButton(onPressed: onPressed, child: const Text('Chấp nhận')),
        ],
      );
    });
  }



}
