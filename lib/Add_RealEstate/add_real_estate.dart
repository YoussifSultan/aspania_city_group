import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddRealEstate extends StatelessWidget {
  const AddRealEstate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    /* *SECTION - Dialog */
    return Container(
      width: width * 0.7,
      height: height * 0.8,
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          /* *SECTION -  */
          Column(
            children: [
              Text(
                'مواصفات الوحدة',
                style: GoogleFonts.notoSansArabic(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
    /* *!SECTION */
  }
}
