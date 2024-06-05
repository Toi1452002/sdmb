import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdmb/controllers/xulytin_controller.dart';
import 'package:sdmb/widgets/wgt_button.dart';
import 'package:sdmb/widgets/wgt_dropdown.dart';


class V_TinSMS extends StatelessWidget {
  const V_TinSMS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Tin SMS (${XuLyTinController().to.soTin})')),
        actions: [
          Obx(() => WgtDropdown(items: const ['All','Nhận','Gửi'],value: XuLyTinController().to.typeSMS, onChange: (value){
            XuLyTinController().to.changeTypeSMS(value!, context);
          })
          )
        ],
      ),
      body: Obx(() {
        List<Map<String, dynamic>> data = XuLyTinController().to.lstSMS;
        List<Map<String, dynamic>> lstSelect = XuLyTinController().to.lstSelectSMS;
        return ListView.separated(
          itemCount: data.length,
          itemBuilder: (context, i) {
            return CheckboxListTile(
              value: lstSelect.contains(data[i]),
              secondary: Container(
                margin: EdgeInsets.only(left: 10),
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Sv_Color.main.withOpacity(.8),
                ),
                child: Text((i+1).toString(),style: TextStyle(color: Colors.black),),
              ),
              contentPadding: EdgeInsets.zero,
              // activeColor: Colors.grey,
              tileColor: lstSelect.contains(data[i]) ? Colors.blue[100] : null,
              onChanged: (value) {
                XuLyTinController().to.onChonSMS(data[i], value!);
              },
              subtitle: Text(data[i]['Date']),
              title: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 150,
                ),
                child: SingleChildScrollView(
                  child: Text(data[i]['Tin'],
                     ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        );
      }),
      persistentFooterButtons: [
        Obx(() => WgtButton(onPressed: (){ XuLyTinController().to.onChapNhanSMS(context);
          }, text: 'Chấp nhận ${XuLyTinController().to.lstSelectSMS.length}'))
      ],
    );
  }
}
