import 'package:aspania_city_group/Common_Used/button_tile.dart';
import 'package:aspania_city_group/Common_Used/navigation.dart';
import 'package:aspania_city_group/PaymentsPage/AddPaymentDialog.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class OverallPaymentsThroughPeriod extends StatefulWidget {
  const OverallPaymentsThroughPeriod({super.key});

  @override
  State<OverallPaymentsThroughPeriod> createState() =>
      _OverallPaymentsThroughPeriodState();
}

class _OverallPaymentsThroughPeriodState
    extends State<OverallPaymentsThroughPeriod> {
  void exportXLSXOfData() {}
  @override
  Widget build(BuildContext context) {
    RxBool onMoreButtonHover = false.obs;
    double height = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
            color: Colors.white,
            child: ListView(shrinkWrap: true, children: [
              /* *SECTION - Top Part */
              Container(
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.only(top: 10, right: 0),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /* *SECTION - Routes */
                    RoutesBuilder(
                        routeLabels: const ['سداد الملاك خلال هذا الشهر'],
                        routeScreen: [NavigationProperties.nonePageRoute]),
                    /* *!SECTION */
                    /* *SECTION - Action Button */
                    Row(
                      children: [
                        Obx(
                          () => GestureDetector(
                              onTap: () {
                                showMenu(
                                    context: context,
                                    color: Colors.white,
                                    position: const RelativeRect.fromLTRB(
                                        50, 125, 50, 0),
                                    items: [
                                      PopupMenuItem<int>(
                                        value: 0,
                                        child: ButtonTile(
                                          buttonText: 'تسجيل فاتورة',
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return FluidDialog(
                                                    rootPage: FluidDialogPage(
                                                  builder: (context) {
                                                    return const AddPaymentDialog(
                                                      state: 'Add',
                                                    );
                                                  },
                                                ));
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      PopupMenuItem<int>(
                                          value: 1,
                                          child: ButtonTile(
                                            buttonText: 'اصدار تقرير',
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              exportXLSXOfData();
                                            },
                                          )),
                                    ]);
                              },
                              child: MouseRegion(
                                onEnter: (details) {
                                  onMoreButtonHover(true);
                                },
                                onExit: (details) {
                                  onMoreButtonHover(false);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Colors.grey[500] ?? Colors.white),
                                      borderRadius: BorderRadius.circular(60),
                                      color: onMoreButtonHover.value
                                          ? Colors.grey[500]
                                          : Colors.transparent),
                                  child: const Icon(
                                    Icons.more_horiz_outlined,
                                    size: 35,
                                    color: Colors.black,
                                  ),
                                ),
                              )),
                        ),
                      ],
                    )
                    /* *!SECTION */
                  ],
                ),
              ),
              /* *!SECTION */
            ])));
  }
}
