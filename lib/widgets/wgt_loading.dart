import 'package:flutter/material.dart';
import 'package:get/get.dart';

showLoading(){
  Get.dialog(
      barrierDismissible: false,
      PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.white,
          child: Container(
            width: 100,
            height: 60,
            padding: const EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
        
            child: const Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 15,),
                Text('Loading...')
              ],
            ),
          ),
        ),
      )
  );
}

closeLoading(){
  Get.back();
}