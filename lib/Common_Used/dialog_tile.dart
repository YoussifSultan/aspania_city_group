import 'package:aspania_city_group/Common_Used/button_tile.dart';
import 'package:aspania_city_group/Common_Used/global_class.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selector_wheel/selector_wheel/models/selector_wheel_value.dart';
import 'package:selector_wheel/selector_wheel/selector_wheel.dart';

import '../Dashboard/menu_card_button.dart';

class DialogTile {
  static Future<dynamic> showMonthAndDateSelectorBottomSheet(
      BuildContext context) {
    int selectedYearValue = 2024;
    int selectedMonthValue = 1;
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              width: GlobalClass.sizingInformation.screenSize.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(10),
              height: 270,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /* *SECTION - Year Selection */

                        SizedBox(
                          width:
                              GlobalClass.sizingInformation.screenSize.width *
                                  0.4,
                          height: 200,
                          child: SelectorWheel(
                            width:
                                GlobalClass.sizingInformation.screenSize.width *
                                    0.4,
                            childCount: 11,
                            selectedItemIndex: 4,
                            convertIndexToValue: (int index) {
                              List<String> years = [
                                '2020',
                                '2021',
                                '2022',
                                '2023',
                                '2024',
                                '2025',
                                '2026',
                                '2027',
                                '2028',
                                '2029',
                                '2030',
                              ];
                              return SelectorWheelValue(
                                label: years[index],
                                value: int.parse(years[index]),
                                index: index,
                              );
                            },
                            onValueChanged:
                                (SelectorWheelValue<int> selection) {
                              selectedYearValue = selection.value;
                            },
                          ),
                        ),
                        /* *!SECTION */
                        /* *SECTION - Month Selection */

                        SizedBox(
                          width:
                              GlobalClass.sizingInformation.screenSize.width *
                                  0.4,
                          height: 200,
                          child: SelectorWheel(
                            childCount: 12,
                            selectedItemIndex: 5,
                            width:
                                GlobalClass.sizingInformation.screenSize.width *
                                    0.4,
                            convertIndexToValue: (int index) {
                              List<String> months = [
                                'يناير',
                                'فبراير',
                                'مارس',
                                'ابريل',
                                'مايو',
                                'يونيه',
                                'يوليو',
                                'اغسطس',
                                'سبتمبر',
                                'اكتوبر',
                                'نوفمبر',
                                'ديسمبر',
                              ];
                              return SelectorWheelValue(
                                label: months[index],
                                value: index + 1,
                                index: index,
                              );
                            },
                            onValueChanged:
                                (SelectorWheelValue<int> selection) {
                              selectedMonthValue = selection.value;
                            },
                          ),
                        ) /* *!SECTION */
                      ]),
                  ButtonTile(
                      onTap: () {
                        Navigator.of(context)
                            .pop([selectedYearValue, selectedMonthValue]);
                      },
                      buttonText: 'نعم')
                ],
              ));
        });
  }

  static Future<dynamic> dialogMenuTile(
      {required BuildContext context,
      required double width,
      required double height,
      required Function onMenuButtonTap,
      required List<String> menuStrings}) {
    return showDialog(
      context: context,
      builder: (context) => FluidDialog(
        alignmentDuration: const Duration(seconds: 1),
        alignmentCurve: Curves.bounceInOut,
        // Set the first page of the dialog.
        rootPage: FluidDialogPage(
            alignment: Alignment.bottomCenter,
            //Aligns the dialog to the bottom left.
            builder: (context) {
              /* *SECTION - Building Selection */
              return Container(
                padding: const EdgeInsets.all(10),
                width: width * 0.3,
                height: height * 0.4,
                child: ListView.builder(
                  itemCount: menuStrings.length,
                  itemBuilder: (context, index) {
                    /* *SECTION - Building Item With Hover */
                    RxBool onHoverOfBuildingItem = false.obs;
                    return Obx(() {
                      return MenuButtonCard(
                          backgroundColor: onHoverOfBuildingItem.value
                              ? Colors.grey[500]
                              : Colors.white,
                          icon: Icons.abc,
                          hasIcon: false,
                          onHover: (isHovering) {
                            onHoverOfBuildingItem(isHovering);
                          },
                          onTap: () {
                            onMenuButtonTap(index);
                          },
                          title: menuStrings[index]);
                    });
                    /* *!SECTION */
                  },
                ),
              );
              /* *!SECTION */
            }),
      ),
    );
  }

  static Future<dynamic> bottomSheetTile(
      {required BuildContext context,
      required double width,
      required double height,
      required Function onMenuButtonTap,
      required List<String> menuText}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          /* *SECTION - Building Selection */
          return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                color: Colors.grey[50],
              ),
              padding: const EdgeInsets.all(10),
              height: height * 0.6,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView.separated(
                  itemCount: menuText.length,
                  itemBuilder: (context, index) {
                    /* *SECTION - Building Item With Hover */
                    RxBool onHoverOfBuildingItem = false.obs;
                    return Obx(() {
                      return MenuButtonCard(
                          backgroundColor: onHoverOfBuildingItem.value
                              ? Colors.grey[500]
                              : Colors.white,
                          icon: Icons.abc,
                          hasIcon: false,
                          onHover: (isHovering) {
                            onHoverOfBuildingItem(isHovering);
                          },
                          onTap: () {
                            onMenuButtonTap(index);
                          },
                          title: menuText[index]);
                    });
                    /* *!SECTION */
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                ),
              ));
          /* *!SECTION */
        });
  }
}
