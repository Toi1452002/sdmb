import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdmb/controllers/khach_controller.dart';
import 'package:sdmb/widgets/wgt_textfield.dart';

class CauHinh extends StatelessWidget {
  const CauHinh({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            // Expanded(
            //   child: WgtTextfield(
            //     controller: KhachController().to.txtGiuLai,
            //     label: 'Giữ lại',
            //     keyboardType: TextInputType.number,
            //   ),
            // ),
            // const SizedBox(
            //   width: 5,
            // ),
            Expanded(
              child: WgtTextfield(
                controller: KhachController().to.txtAU3,
                label: 'an ủi 3 con',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: WgtTextfield(
                controller: KhachController().to.txtAU34,
                label: 'an ủi x3,4',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        WgtTextfield(
          label: 'SDT',
          keyboardType: TextInputType.number,
          controller: KhachController().to.txtSDT,
        ),
        const SizedBox(
          height: 10,
        ),
        ColoredBox(
          color: Colors.white.withOpacity(.8),
          child: ListTile(
              title: const Text('Đầu trên'),
              trailing: Obx(()=>Checkbox(
                onChanged: (value) {
                  KhachController().to.dautren = value!;
                },
                value: KhachController().to.dautren,
              ))),
        )
      ],
    );
  }
}
