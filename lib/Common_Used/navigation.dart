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
buildingNumber , window State (Edit_Owner, Add_Owner), realestate data
)
4. Show AllRealEstate (
  index of building , All_Apartements ORRR Recorded_Apartements ORRR All_Owners
)
5.Payment Page(
  RealEstate ID ,
)
 */
class NavigationProperties {
  static String ownerPageRoute = 'Owners';
  /* *SECTION - Payments */
  static String paymentsDetailedPageRoute = 'PaymentDetailsInApartementPage';
  static String overallPaymentsThroughPeriodPageRoute =
      'OverallPaymentPeriodPage';
  /* *!SECTION */
  static String nonePageRoute = 'None';
  /* *SECTION - Apartements */
  static String realEstateSummaryPageRoute = 'realEstateSummary';
  static String addNewRealEstatePageRoute = 'AddNewApartement';
  static String dataTableOfApartements = 'showAllApartements';
  /* *!SECTION */
  static List selectedTabNeededParamters = [];
  static RxString selectedTabVaueNotifier = 'Apartemnts'.obs;
}

/* *!SECTION */

class RoutesBuilder extends StatelessWidget {
  const RoutesBuilder(
      {super.key, required this.routeLabels, required this.routeScreen});
  final List<String> routeLabels;
  final List<String> routeScreen;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: routeLabels.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return Text(
            ' / ',
            style:
                GoogleFonts.notoSansArabic(color: Colors.black, fontSize: 28),
          );
        },
        itemBuilder: (context, index) {
          return RouteTextWIthHover(
              routeName: routeLabels[index],
              onTap: () {
                if (routeScreen[index] != NavigationProperties.nonePageRoute) {
                  NavigationProperties.selectedTabVaueNotifier(
                      routeScreen[index]);
                }
              });
        },
      ),
    );
  }
}

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
