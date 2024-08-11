import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdmb/controllers/user_controller.dart';
import 'package:sdmb/widgets/wgt_button.dart';
import 'package:sdmb/widgets/wgt_textfield.dart';

import '../../config/functions/md_mathietbi.dart';
import '../../config/router.dart';

class VLogin extends StatelessWidget {
  VLogin({super.key});

  final controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Colors.teal.shade200,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đăng nhập vào ứng dụng',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey.shade600,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                WgtTextfield(
                  controller: controller.txtUsername,
                  hint: 'Username',
                  icon: Icons.person,
                ),
                const SizedBox(
                  height: 10,
                ),
                WgtTextfield(
                  controller: controller.txtPassword,
                  hint: 'Password',
                  icon: Icons.lock_rounded,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                WgtButton(
                  text: 'Đăng nhập',
                  onPressed: () {
                    controller.onLogin(context);
                  },
                ),
                SizedBox(height: 5),
                TextButton(onPressed: () async {
                  Get.toNamed(vKichHoat,parameters:{'MaThietBi': getKey()});
                }, child: const Text('Kích hoạt ứng dụng',style: TextStyle(
                    decoration: TextDecoration.underline
                ),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
