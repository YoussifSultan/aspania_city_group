import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class MenuButtonCard extends StatelessWidget {
  MenuButtonCard({
    required this.icon,
    required this.title,
    this.onTap,
    this.onHover,
    this.backgroundColor,
    this.menuCardRadius,
    this.hasIcon = true,
    super.key,
  });
  String title;
  Function? onTap;
  Function? onHover;
  IconData icon;
  bool hasIcon;
  BorderRadius? menuCardRadius;
  Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (isHovering) {
        if (onHover != null) {
          onHover!(isHovering);
        }
      },
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius:
                menuCardRadius ?? const BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 20,
            ),
            Row(children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoSansArabic(fontSize: 20),
              ),
              const SizedBox(
                width: 20,
              ),
              hasIcon
                  ? Icon(
                      icon,
                      size: 25,
                    )
                  : const SizedBox()
            ]),
          ],
        ),
      ),
    );
  }
}
