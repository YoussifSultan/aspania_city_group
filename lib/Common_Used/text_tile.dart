import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class TextTile extends StatelessWidget {
  const TextTile({
    super.key,
    required this.width,
    required this.textController,
    required this.title,
    required this.hintText,
    required this.icon,
    this.onTap,
    this.onSubmit,
    this.height = 50,
    this.onChange,
    this.isPassword = false,
  });

  final double width;
  final double height;
  final bool isPassword;
  final String title;
  final String hintText;
  final IconData icon;
  final Function? onTap;
  final Function? onSubmit;
  final Function? onChange;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    final RxString errorText = ''.obs;
    bool expandable = onTap != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style:
              GoogleFonts.notoSansArabic(fontSize: 18, color: Colors.grey[500]),
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /* *SECTION - TextField */
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey[500] ?? Colors.black),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  width: width,
                  height: height,
                  child: TextField(
                    textAlign: TextAlign.right,
                    onTap: () {
                      if (expandable) {
                        onTap!();
                      }
                    },
                    readOnly: expandable,
                    maxLines: height != 50 ? 3 : 1,
                    controller: textController,
                    onChanged: (value) {
                      if (onChange != null) {
                        onChange!(value, errorText);
                      }
                    },
                    obscureText: isPassword,
                    enableSuggestions: isPassword ? false : true,
                    autocorrect: isPassword ? false : true,
                    onSubmitted: (value) {
                      if (onSubmit != null) {
                        onSubmit!(value);
                      }
                    },
                    decoration: InputDecoration(
                        hintText: hintText,
                        suffixIcon: Icon(icon),
                        border: InputBorder.none,
                        hintTextDirection: TextDirection.rtl),
                  )),
              /* *!SECTION */
              const SizedBox(
                height: 5,
              ),
              /* *SECTION - Error Text */
              Visibility(
                  visible: errorText.isNotEmpty,
                  child: Text(
                    errorText.value,
                    style: GoogleFonts.notoSansArabic(
                        color: Colors.red, fontSize: 14),
                  )),
              SizedBox(
                height: errorText.isNotEmpty ? 5 : 15,
              )
              /* *!SECTION */
            ],
          );
        }),
      ],
    );
  }
}
