import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelAndDataVerticalWidget extends StatelessWidget {
  const LabelAndDataVerticalWidget({
    super.key,
    required this.dataText,
    required this.labelText,
    this.dataTextDirection = TextDirection.ltr,
  });

  final String dataText;
  final String labelText;
  final TextDirection dataTextDirection;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(labelText,
            maxLines: 1,
            textDirection: TextDirection.rtl,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSansArabic(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            )),
        Text(dataText,
            maxLines: 1,
            textDirection: dataTextDirection,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSansArabic(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            )),
      ],
    );
  }
}

class LabelAndDataHorizontalWidget extends StatelessWidget {
  const LabelAndDataHorizontalWidget({
    super.key,
    required this.dataText,
    required this.labelText,
  });

  final String dataText;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$labelText:',
            maxLines: 1,
            textDirection: TextDirection.rtl,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSansArabic(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            )),
        Text(dataText,
            maxLines: 1,
            textDirection: TextDirection.rtl,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSansArabic(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            )),
      ],
    );
  }
}
