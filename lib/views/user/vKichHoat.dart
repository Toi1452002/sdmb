import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sdmb/config/toast.dart';
import 'package:sdmb/controllers/user_controller.dart';
import 'package:sdmb/widgets/wgt_button.dart';
import 'package:sdmb/widgets/wgt_textfield.dart';


class VKichHoat extends StatelessWidget {
  VKichHoat({super.key});
  final txtMaKichHoat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Colors.teal.shade200,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kích hoạt ứng dụng',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueGrey.shade600,
                      fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 10,),
                // WgtTextfield(
                //
                //   controller: TextEditingController(text: Get.parameters['MaThietBi']),
                //   readOnly: true,
                //   icon: Icons.key,
                //   suffixIcon: IconButton(
                //     icon: Icon(Icons.copy),
                //     onPressed: (){
                //       Clipboard.setData(ClipboardData(text: Get.parameters['MaThietBi'].toString())).whenComplete((){
                //         FlashToast(context).showSuccess('Đã sao chép');
                //       });
                //     },
                //   ),
                // ),
                SizedBox(height: 10,),
                WgtTextfield(
                  controller: txtMaKichHoat,
                  icon: Icons.code_sharp,
                  hint: 'Nhập mã kích hoạt',
                ),
                const SizedBox(
                  height: 15,
                ),
                WgtButton(text: 'Kích hoạt',onPressed: (){
                  FocusScope.of(context).requestFocus(FocusNode());
                  UserController().to.onKichHoat(txtMaKichHoat.text,context);
                },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
