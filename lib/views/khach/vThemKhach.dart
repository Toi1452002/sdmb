
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sdmb/controllers/khach_controller.dart';
import 'package:sdmb/views/khach/component/cauhinh.dart';
import 'package:sdmb/views/khach/component/gia.dart';
import 'package:sdmb/widgets/wgt_button.dart';
import 'package:sdmb/widgets/wgt_textfield.dart';

class VThemKhach extends StatelessWidget {
  const VThemKhach({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Giá khách'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(5),
            child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    WgtTextfield(
                      hint: 'Tên khách',
                      controller: KhachController().to.txtTenKhach,
                    ),
                    SizedBox(height: 5,),
                    ColoredBox(
                      color: Colors.white.withOpacity(.8),
                      child: const TabBar(indicatorSize: TabBarIndicatorSize.tab,tabs: [
                        Tab(
                          child: Text('Giá'),
                        ),
                        Tab(
                          child: Text('Cấu hình'),
                        ),
                      ]),
                    ),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          Gia(),
                          CauHinh()
                        ],
                      ),
                    )
                  ],
                ))),
        persistentFooterButtons: [
          WgtButton(text: 'Chấp nhận',onPressed: (){
            KhachController().to.onAddKhach(context);
          },)
        ],
      ),
    );
  }
}
