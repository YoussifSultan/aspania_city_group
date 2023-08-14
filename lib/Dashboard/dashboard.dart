import 'package:aspania_city_group/Dashboard/real_estate_summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'menu_card_button.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  /* *SECTION -  Animations */
  late AnimationController openMainScreenAnimationController;
  /* *!SECTION */
  /* *SECTION - ValueNotifiers */
  RxInt selectedTabVaueNotifier = 0.obs;
  /* *!SECTION */
  /* *SECTION - Dispose */
  @override
  void dispose() {
    openMainScreenAnimationController.dispose();
    super.dispose();
  }

  /* *!SECTION */
  /* *SECTION - Init State */
  @override
  void initState() {
    openMainScreenAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
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
                  return SizeTransition(
                    sizeFactor: openMainScreenAnimationController,
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 20),
                      width: width > 1250 ? width * 0.80 : width * 0.75,
                      height: height * 0.95,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: selectedTabVaueNotifier.toInt() == 0
                          /* *SECTION - Real Estate Part */
                          ? const RealEstatesPage()
                          /* *!SECTION */
                          /* *TODO - Implement Other Screens */
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
                  width: width > 1250 ? width * 0.17 : width * 0.23,
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /* *SECTION - Aspania City Image */
                      /* *TODO - Change Image */
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(left: 20),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/Boudy-Elhegaz-real-estate-logo-10.jpg'),
                            )),
                      ),
                      /* *!SECTION */
                      const SizedBox(
                        height: 30,
                      ),
                      /* *SECTION - Profile Button */
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                        width: width * 0.14,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /* *SECTION - ProfileName */
                            Text(
                              'الاسم',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.gulzar(fontSize: 20),
                            ),
                            /* *!SECTION */
                            const SizedBox(
                              width: 10,
                            ),
                            /* *SECTION - Profile Image */
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(60)),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/Boudy-Elhegaz-real-estate-logo-10.jpg'),
                                  )),
                            ),
                            /* *!SECTION */
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      /* *SECTION - Menu Buttons */
                      /* *SECTION - Real Estates Item */
                      MenuButtonCard(
                        title: 'الوحدات',
                        icon: Icons.category_outlined,
                        onTap: () {
                          selectedTabVaueNotifier(0);
                          openMainScreenAnimationController.forward(from: 0);
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
                          selectedTabVaueNotifier(1);
                          openMainScreenAnimationController.forward(from: 0);
                        },
                      ),
                      /* *!SECTION */
                      const SizedBox(
                        height: 10,
                      ),
                      /* *SECTION - Log In Item */
                      MenuButtonCard(
                        title: 'تسجيل الدخول',
                        icon: Icons.login_outlined,
                      ),
                      /* *!SECTION */
                      const SizedBox(
                        height: 10,
                      ),
                      /* *SECTION - Log Out Item */
                      MenuButtonCard(
                        title: 'تسجيل الخروج',
                        icon: Icons.logout_outlined,
                      ),
                      /* *!SECTION */
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
