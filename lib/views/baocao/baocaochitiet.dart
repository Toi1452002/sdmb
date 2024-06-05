import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sdmb/config/extension.dart';
import 'package:sdmb/controllers/baocao_controller.dart';
import 'package:sdmb/views/baocao/component/table_bcct_1.dart';
import 'package:sdmb/views/baocao/component/table_bcct_2.dart';

class VBaoCaoChiTiet extends StatelessWidget {
  VBaoCaoChiTiet({super.key});

  final controller = Get.put(BaoCaoController());
  final RxInt _page = 1.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text("${controller.nameKH}");
        }),
        actions: [Obx(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$_page/${controller.dta.value.length}",style: TextStyle(
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.white,
            fontSize: 18,
          ),),
        ))],
      ),
      body: DefaultTabController(
          length: 2,
          child: Obx(() {
            List dta = controller.dta.value;
            return PageView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                onPageChanged: (i) {
                  // setState(() {
                  _page.value = i + 1;
                  // });
                },
                itemCount: dta.length,
                itemBuilder: (_, i) {
                  return Container(
                    padding: EdgeInsets.only(right: 2, left: 2),
                    width: Get.width,
                    height: Get.height,
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: Get.width,
                          padding: const EdgeInsets.all(5),
                          color: Colors.white,
                          child: Text(dta[i]['TinXL'].toString()),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration:
                              BoxDecoration(color: Colors.teal.shade100),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: textKQ(
                                          title: 'Xác',
                                          text: dta[i]['Xac'].toString())),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: textKQ(
                                          title: 'Vốn',
                                          text: dta[i]['Von'].toString())),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: textKQ(
                                          title: 'Thưởng',
                                          text: dta[i]['Thuong'].toString())),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: textKQ(
                                        color: dta[i]['LaiLo'].toString().contains('-') ?Colors.red : Colors.blue,
                                          title: 'Lãi/Lỗ',
                                          text: dta[i]['LaiLo'].toString())),
                                ],
                              )
                            ],
                          ),
                        ),
                        ColoredBox(
                          color: Colors.teal.shade100,
                          child: const TabBar(tabs: [
                            Tab(
                              child: Text('Chi tiết 1'),
                            ),
                            Tab(
                              child: Text('Chi tiết 2'),
                            ),
                          ]),
                        ),
                        Expanded(
                          child: Obx(() => ColoredBox(
                                color: Colors.grey.shade200,
                                child: TabBarView(
                                  children: [
                                    TBL_BCCT_1(
                                      data: controller.dta1.isNotEmpty
                                          ? controller.dta1[i]
                                          : {},
                                    ),
                                    TBL_BCCT_2(
                                      data: controller.dta2.isNotEmpty
                                          ? controller.dta2[i]
                                          : {},
                                    )
                                  ],
                                ),
                              )),
                        )
                      ],
                    ),
                  );
                });
          })),
    );
  }

  Container textKQ({String text = '', String title = '', Color? color}) {
    return Container(
      height: 30,
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      color: Colors.white,
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: title,
              style: const TextStyle(color: Colors.grey, fontSize: 15)),
          const TextSpan(text: '\t'),
          TextSpan(
              text: text.isNumeric
                  ? NumberFormat('#,###').format(text.toDouble)
                  : text,
              style: TextStyle(color: color ?? Colors.black, fontSize: 16))
        ]),
      ),
    );
  }
}
