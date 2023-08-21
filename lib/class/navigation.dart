/* *SECTION - ValueNotifiers */
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

/* *NOTE - 
selectedTabVaueNotifier has only 
1. Apartements
2. Owners
3. AddNewApartement(
buildingNumber , window State , realestate data
)
 */
class NavigationProperties {
  static String realEstateSummaryPageRoute = 'realEstateSummary';
  static String ownerPageRoute = 'Owners';
  static String addNewRealEstatePageRoute = 'AddNewApartement';
  static String showAllRealEstatePageRoute = 'showAllApartements';
  static List selectedTabNeededParamters = [];
  static RxString selectedTabVaueNotifier = 'Apartemnts'.obs;
}

/* *!SECTION */

class RouteTextWIthHover extends StatelessWidget {
  const RouteTextWIthHover({
    super.key,
    required this.routeName,
    this.onTap,
  });
  final String routeName;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    RxBool onRouteHover = false.obs;
    return MouseRegion(
      onEnter: (details) {
        onRouteHover(true);
      },
      onExit: (details) {
        onRouteHover(false);
      },
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Obx(() {
          return Text(
            routeName,
            style: GoogleFonts.notoSansArabic(
                color: onRouteHover.value ? Colors.black : Colors.grey[600],
                fontSize: onRouteHover.value ? 25.5 : 25),
          );
        }),
      ),
    );
  }
}
