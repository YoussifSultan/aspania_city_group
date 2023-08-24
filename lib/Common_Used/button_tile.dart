import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonTile extends StatelessWidget {
  const ButtonTile({
    super.key,
    required this.onTap,
    required this.buttonText,
  });

  final Function onTap;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    final RxBool onHover = false.obs;

    return Obx(() {
      return GestureDetector(
        onTap: () {
          onTap();
        },
        child: MouseRegion(
          onEnter: (details) {
            onHover(true);
          },
          onExit: (details) {
            onHover(false);
          },
          child: Container(
            width: 150,
            height: 40,
            decoration: BoxDecoration(
                color: onHover.value ? Colors.grey[500] : Colors.transparent,
                border: Border.all(color: Colors.grey[500] ?? Colors.white),
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Text(
                buttonText,
                style: GoogleFonts.notoSansArabic(fontSize: 18),
              ),
            ),
          ),
        ),
      );
    });
  }
}
