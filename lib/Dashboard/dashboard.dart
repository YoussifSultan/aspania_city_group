import 'package:aspania_city_group/Add_RealEstate/add_real_estate.dart';
import 'package:aspania_city_group/Dashboard/real_estate_summary.dart';
import 'package:aspania_city_group/DataTableForApartements/ShowAllApartements.dart';
import 'package:aspania_city_group/Common_Used/navigation.dart';
import 'package:aspania_city_group/Sign_InPage/SignIn_Page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../PaymentsPage/PaymentsPerMonth.dart';
import 'menu_card_button.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  /* *SECTION -  Animations */
  /* *!SECTION */
  /* *SECTION - ValueNotifiers */
  /* *!SECTION */
  /* *SECTION - Dispose */

  /* *!SECTION */
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
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: NavigationProperties.selectedTabVaueNotifier
                                  .toString() ==
                              NavigationProperties.realEstateSummaryPageRoute
                          /* *SECTION - Real Estate Part */
                          ? const RealEstatesPage()
                          /* *!SECTION */
                          : NavigationProperties.selectedTabVaueNotifier
                                      .toString() ==
                                  NavigationProperties.addNewRealEstatePageRoute
                              ? AddRealEstate(
                                  windowState: NavigationProperties
                                      .selectedTabNeededParamters[1],
                                  buildingNumber: NavigationProperties
                                      .selectedTabNeededParamters[0],
                                  dataToEdit: NavigationProperties
                                      .selectedTabNeededParamters[2],
                                )
                              : NavigationProperties.selectedTabVaueNotifier
                                          .toString() ==
                                      NavigationProperties
                                          .dataTableOfApartements
                                  ? const ShowwAllAprtementsPage()
                                  : NavigationProperties.selectedTabVaueNotifier
                                              .toString() ==
                                          NavigationProperties.paymentsPageRoute
                                      ? const PaymentsPageOfApartement()
                                      : const SizedBox(),
                    ),
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
                            title: 'الملاك',
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
                                  [];
                              NavigationProperties.selectedTabVaueNotifier(
                                  NavigationProperties.paymentsPageRoute);
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
            return Container(color: Colors.red);
          }

          if (sizingInformation.deviceScreenType == DeviceScreenType.watch) {
            return Container(color: Colors.yellow);
          }

          return Container(color: Colors.purple);
        },
      )),
    );
  }
}
