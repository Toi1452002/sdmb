import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdmb/config/router.dart';
import 'package:sdmb/controllers/baocao_controller.dart';
import 'package:sdmb/controllers/tinnhan_controller.dart';
import 'package:sdmb/views/baocao/baocao.dart';
import 'package:sdmb/views/tin/vTin.dart';

class VHome extends StatefulWidget {
  const VHome({super.key});

  @override
  State<VHome> createState() => _VHomeState();
}

class _VHomeState extends State<VHome> {
  int _selectTab = 0;
  List<Widget> tabPages = [ VTin(),  VBaoCao()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: tabPages[_selectTab],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal.shade200,
        splashColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        onPressed: () {
          Get.toNamed(vXuLyTin)!.then((value) => TinNhanContoller().to.onLoadData());
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:   FloatingActionButtonLocation.endContained,
      bottomNavigationBar: BottomAppBar(

        surfaceTintColor: Colors.transparent,
        color: Colors.teal.shade300,

        height: 70,
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          // mainAxisSize: MainAxisSize.max,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            InkWell(
              radius: 20,
              borderRadius: BorderRadius.circular(100),
              onTap: (){
                setState(() {
                  _selectTab = 0;
                });
              },
              child: Column(
                children: [
                  Icon(Icons.messenger,color: _selectTab ==0 ? Colors.white :Colors.teal.shade100,),
                  Text('Tin nhắn',style: TextStyle(
                    color: _selectTab == 0 ? Colors.white :Colors.teal.shade100,
                    fontSize: _selectTab == 0 ? 15 : 14
                  ),)
                ],
              ),
            ),
            // const SizedBox(
            //   width: 70,
            // ),
            Padding(
              padding: const EdgeInsets.only(right: 90),
              child: InkWell(
                radius: 20,
                borderRadius: BorderRadius.circular(100),
                onTap: (){
                  setState(() {
                    _selectTab = 1;
                    BaoCaoController().to.onLoadBaoCao();
                  });
                },
                child: Column(
                  children: [
                    Icon(Icons.table_chart,color: _selectTab == 1 ? Colors.white :Colors.teal.shade100,),
                    Text('Báo cáo',style: TextStyle(
                      color: _selectTab == 1 ? Colors.white : Colors.teal.shade100,
                      fontSize: _selectTab == 1 ? 15 : 14
                    ),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
