import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Dashboard/menu_card_button.dart';

class DialogOfTile {
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
}
