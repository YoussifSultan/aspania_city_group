import 'package:aspania_city_group/Add_RealEstate/add_real_estate.dart';
import 'package:aspania_city_group/Common_Used/dialog_tile.dart';
import 'package:aspania_city_group/Common_Used/global_class.dart';
import 'package:aspania_city_group/Dashboard/real_estate_summary.dart';
import 'package:aspania_city_group/DataTableForApartements/ShowAllApartements.dart';
import 'package:aspania_city_group/Common_Used/navigation.dart';
import 'package:aspania_city_group/DrawerMobile/MenuDrawer.dart';
import 'package:aspania_city_group/PaymentsPage/AddPaymentDialog.dart';
import 'package:aspania_city_group/PaymentsPage/filter_payments_Page.dart';
import 'package:aspania_city_group/PaymentsPage/overallPayments.dart';
import 'package:aspania_city_group/Sign_InPage/SignIn_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../PaymentsPage/PaymentsDetailedPage.dart';
import 'menu_card_button.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  /* *SECTION - Init State */

  @override
  void initState() {
    super.initState();
  }

  /* *!SECTION */
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(child: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          GlobalClass.sizingInformation = sizingInformation;
          // Check the sizing information here and return your UI
          /* *SECTION - Desktop Ui */
          if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /* *SECTION - Main Screen */
                Obx(() {
                  AnimationController openMainScreenAnimationController =
                      AnimationController(
                          vsync: this, duration: const Duration(seconds: 1));
                  openMainScreenAnimationController.forward();
                  return FadeTransition(
                    opacity: openMainScreenAnimationController,
                    child: Container(
                        padding: const EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 20),
                        width: width > 1250 ? width * 0.80 : width * 0.7,
                        height: height * 0.95,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: getScreenRequired(NavigationProperties
                            .selectedTabVaueNotifier
                            .toString())),
                  );
                }),
                const SizedBox(
                  width: 20,
                ),
                /* *!SECTION */
                /* *SECTION -  Divider */
                const VerticalDivider(
                  width: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                /* *!SECTION */
                /* *SECTION - Drawer */
                Container(
                  width: width > 1250 ? width * 0.17 : width * 0.25,
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          /* *SECTION - Menu Buttons */
                          /* *SECTION - Real Estates Item */
                          MenuButtonCard(
                            title: 'الوحدات',
                            icon: Icons.category_outlined,
                            onTap: () {
                              NavigationProperties.selectedTabVaueNotifier(
                                  NavigationProperties
                                      .realEstateSummaryPageRoute);
                            },
                          ),
                          /* *!SECTION */
                          const SizedBox(
                            height: 10,
                          ),
                          /* *SECTION - Owners Item */
                          MenuButtonCard(
                            title: 'المقيمين',
                            icon: Icons.people_alt_outlined,
                            onTap: () {
                              NavigationProperties.selectedTabNeededParamters =
                                  [-1, 'All_Owners'];
                              NavigationProperties.selectedTabVaueNotifier(
                                  NavigationProperties.dataTableOfApartements);
                            },
                          ),
                          /* *!SECTION */
                          const SizedBox(
                            height: 10,
                          ),
                          /* *SECTION - Payments Item */
                          MenuButtonCard(
                            title: 'سداد',
                            icon: Icons.payments_rounded,
                            onTap: () {
                              NavigationProperties.selectedTabNeededParamters =
                                  ['PaymentsDuringMonth', ''];
                              NavigationProperties.selectedTabVaueNotifier(
                                  NavigationProperties
                                      .overallPaymentsThroughPeriodPageRoute);
                            },
                          ),
                          /* *!SECTION */
                          const SizedBox(
                            height: 10,
                          ),
                          /* *!SECTION */
                        ],
                      ),
                      /* *SECTION - Log Out Item */
                      Container(
                        margin: const EdgeInsets.only(bottom: 50),
                        child: MenuButtonCard(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SigninScreen()),
                            );
                          },
                          hasIcon: false,
                          title: width > 1250 ? 'تسجيل الخروج' : 'الخروج',
                          icon: Icons.logout_outlined,
                        ),
                      ),
                      /* *!SECTION */
                    ],
                  ),
                ),
                /* *!SECTION */
              ],
            );
          }
          /* *!SECTION */
          if (sizingInformation.deviceScreenType == DeviceScreenType.tablet ||
              sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
            return ZoomDrawer(
              controller: GlobalClass.drawerController,
              style: DrawerStyle.defaultStyle,
              menuScreen: const DrawerMenuScreen(),
              isRtl: true,
              mainScreen: Container(
                color: Colors.grey[100],
                child: ListView(
                  children: [
                    /* *SECTION - Top Part */
                    Container(
                      height: height * 0.07,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton.filled(
                              onPressed: () {
                                GlobalClass.drawerController.toggle!();
                              },
                              focusColor: Colors.transparent,
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.transparent)),
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.black,
                                size: 24,
                              )),
                          /* *!SECTION */
                          /* *SECTION - Title Leaved to Changing*/
                          Text(
                            'Spain City',
                            style: GoogleFonts.notoSansArabic(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          /* *!SECTION */
                          /* *SECTION - Options Icon */
                          Row(
                            children: [
                              IconButton.filled(
                                  onPressed: () {
                                    if (GlobalClass
                                        .menuOptionsMobile.isNotEmpty) {
                                      DialogTile.bottomSheetTile(
                                          context: context,
                                          width: width,
                                          height: height,
                                          onMenuButtonTap: (index) {
                                            GlobalClass.menuOptionsMobile[index]
                                                .onMenuTapButton();
                                            Navigator.of(context).pop();
                                          },
                                          menuText: GlobalClass
                                              .menuOptionsMobile
                                              .map((e) => e.menuTitle)
                                              .toList());
                                    }
                                  },
                                  focusColor: Colors.transparent,
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.transparent)),
                                  icon: const Icon(
                                    Icons.more_horiz_outlined,
                                    color: Colors.black,
                                    size: 24,
                                  )),
                              /* *SECTION - Home Icon */
                              IconButton.filled(
                                  onPressed: () {
                                    NavigationProperties
                                        .selectedTabVaueNotifier(
                                            NavigationProperties
                                                .realEstateSummaryPageRoute);
                                  },
                                  focusColor: Colors.transparent,
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.transparent)),
                                  icon: const Icon(
                                    Icons.home_outlined,
                                    color: Colors.black,
                                    size: 24,
                                  )),
                              /* *!SECTION */
                            ],
                          ),
                          /* *!SECTION */
                        ],
                      ),
                    ),

                    /* *SECTION - Main Screen */

                    Obx(() {
                      AnimationController openMainScreenAnimationController =
                          AnimationController(
                              vsync: this,
                              duration: const Duration(seconds: 1));
                      openMainScreenAnimationController.forward();
                      return FadeTransition(
                          opacity: openMainScreenAnimationController,
                          child: Container(
                              clipBehavior: Clip.hardEdge,
                              height:
                                  sizingInformation.screenSize.height * 0.87,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24))),
                              child: getScreenRequired(NavigationProperties
                                  .selectedTabVaueNotifier
                                  .toString())));
                    })
                    /* *!SECTION */
                  ],
                ),
              ),
              borderRadius: 24.0,
              showShadow: true,
              angle: 0.0,
              drawerShadowsBackgroundColor: Colors.grey[300] ?? Colors.white,
              slideWidth: MediaQuery.of(context).size.width * 0.95,
              openCurve: Curves.fastOutSlowIn,
              closeCurve: Curves.bounceIn,
            );
          }

          if (sizingInformation.deviceScreenType == DeviceScreenType.watch) {
            return Container(color: Colors.yellow);
          }

          return Container(color: Colors.purple);
        },
      )),
    );
  }

  Widget getScreenRequired(String requiredScreen) {
    /* *SECTION - Real Estate Part */
    if (requiredScreen == NavigationProperties.realEstateSummaryPageRoute) {
      return const RealEstatesPage();
    } else if (requiredScreen ==
        NavigationProperties.addNewRealEstatePageRoute) {
      return AddRealEstate(
        windowState: NavigationProperties.selectedTabNeededParamters[1],
        buildingNumber: NavigationProperties.selectedTabNeededParamters[0],
        dataToEdit: NavigationProperties.selectedTabNeededParamters[2],
      );
    } else if (requiredScreen == NavigationProperties.dataTableOfApartements) {
      return ShowwAllAprtementsPage(
        sqlQueryStatement: NavigationProperties.selectedTabNeededParamters[0],
      );
    } else if (requiredScreen ==
        NavigationProperties.paymentsDetailedPageRoute) {
      return const PaymentsPageOfSpecifiedApartement();
    } else if (requiredScreen ==
        NavigationProperties.overallPaymentsThroughPeriodPageRoute) {
      return OverallPaymentsThroughPeriod(
        status: NavigationProperties.selectedTabNeededParamters[0],
        queryStatement: NavigationProperties.selectedTabNeededParamters[1],
      );
    } else if (requiredScreen == NavigationProperties.addPaymentMobilePage) {
      return AddPaymentDialog(
        state: NavigationProperties.selectedTabNeededParamters[0],
        selectedOwner: NavigationProperties.selectedTabNeededParamters[1],
        paymentData: NavigationProperties.selectedTabNeededParamters[2],
      );
    } else if (requiredScreen == NavigationProperties.filterPaymentsPage) {
      return const FilterPaymentsPage();
    }

    return const Text('Add it in dashboard 329:50');
  }
}
