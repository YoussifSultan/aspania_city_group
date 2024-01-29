import 'package:aspania_city_group/Common_Used/navigation.dart';
import 'package:aspania_city_group/class/realestate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../class/buidlingproperties.dart';
import 'menu_card_button.dart';

class RealEstatesPage extends StatelessWidget {
  const RealEstatesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Building> realEstates = [
      Building(buildingName: 'عمارة رقم ۱', id: 1),
      Building(buildingName: 'عمارة رقم ۲', id: 2),
      Building(buildingName: 'عمارة رقم ۳', id: 3),
      Building(buildingName: 'عمارة رقم ٤', id: 4),
      Building(buildingName: 'عمارة رقم ٥', id: 5),
      Building(buildingName: 'عمارة رقم ٦', id: 6),
      Building(buildingName: 'عمارة رقم ۷', id: 7),
    ];
    double width = MediaQuery.of(context).size.width;
    /* *SECTION - Mobile View */
    if (NavigationProperties.sizingInformation.deviceScreenType ==
            DeviceScreenType.tablet ||
        NavigationProperties.sizingInformation.deviceScreenType ==
            DeviceScreenType.mobile) {
      return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 7,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, index) {
                  return RealEstateActionsMobileWidget(
                      width: NavigationProperties
                          .sizingInformation.screenSize.width,
                      realEstateName: realEstates
                          .firstWhere((element) => element.id == index + 1)
                          .buildingName,
                      onAddingNewApartementButtonTap: () {
                        NavigationProperties.selectedTabNeededParamters = [
                          index + 1,
                          'AddOwner',
                          RealEstateData(
                              id: 0,
                              apartementStatusId: 0,
                              apartementPostionInFloorId: 0,
                              apartementPostionInBuildingId: 0,
                              apartementLink: 'None',
                              isApartementHasEnoughData: false,
                              apartementName: 'None')
                        ];
                        NavigationProperties.selectedTabVaueNotifier(
                            NavigationProperties.addNewRealEstatePageRoute);
                      },
                      onShowAllOwnersInRealEstateButtonTap: () {
                        NavigationProperties.selectedTabNeededParamters = [
                          index + 1,
                          'Recorded_Apartements'
                        ];
                        NavigationProperties.selectedTabVaueNotifier(
                            NavigationProperties.dataTableOfApartements);
                      },
                      onShowAllApartementsInRealEstateButtonTap: () {
                        NavigationProperties.selectedTabNeededParamters = [
                          index + 1,
                          'All_Apartements'
                        ];
                        NavigationProperties.selectedTabVaueNotifier(
                            NavigationProperties.dataTableOfApartements);
                      });
                },
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ));
    }
    /* *!SECTION */
    /* *SECTION - Desktop View */
    else if (NavigationProperties.sizingInformation.deviceScreenType ==
        DeviceScreenType.desktop) {
      return ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 20,
          ),
          /* *SECTION - Routes  */
          Row(
            textDirection: TextDirection.rtl,
            children: [
              RouteTextWIthHover(
                routeName: 'الوحدات',
                onTap: () {
                  NavigationProperties.selectedTabVaueNotifier(
                      NavigationProperties.realEstateSummaryPageRoute);
                },
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          /* *!SECTION */
          Directionality(
            textDirection: TextDirection.rtl,
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: realEstates.length - 1,
                reverse: false,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width > 1250 ? 3 : 2,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 20),
                itemBuilder: (context, index) {
                  /* *SECTION - RealEstate 1 -6  */
                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: RealEstateActionsWidget(
                      onAddingNewApartementButtonTap: () {
                        NavigationProperties.selectedTabNeededParamters = [
                          index + 1,
                          'AddOwner',
                          RealEstateData(
                              id: 0,
                              apartementStatusId: 0,
                              apartementPostionInFloorId: 0,
                              apartementPostionInBuildingId: 0,
                              apartementLink: 'None',
                              isApartementHasEnoughData: false,
                              apartementName: 'None')
                        ];
                        NavigationProperties.selectedTabVaueNotifier(
                            NavigationProperties.addNewRealEstatePageRoute);
                      },
                      onShowAllApartementsInRealEstateButtonTap: () {
                        NavigationProperties.selectedTabNeededParamters = [
                          index + 1,
                          'All_Apartements'
                        ];
                        NavigationProperties.selectedTabVaueNotifier(
                            NavigationProperties.dataTableOfApartements);
                      },
                      onShowAllOwnersInRealEstateButtonTap: () {
                        NavigationProperties.selectedTabNeededParamters = [
                          index + 1,
                          'Recorded_Apartements'
                        ];
                        NavigationProperties.selectedTabVaueNotifier(
                            NavigationProperties.dataTableOfApartements);
                      },
                      width: width,
                      realEstateName: realEstates
                          .firstWhere((element) => element.id == index + 1)
                          .buildingName,
                    ),
                  );
                  /* *!SECTION */
                }),
          ),
          /* *SECTION - RealEstate 7 */
          Center(
            child: RealEstateActionsWidget(
              onAddingNewApartementButtonTap: () {
                NavigationProperties.selectedTabNeededParamters = [
                  7,
                  'AddOwner',
                  RealEstateData(
                      id: 0,
                      apartementStatusId: 0,
                      apartementPostionInFloorId: 0,
                      apartementPostionInBuildingId: 0,
                      apartementLink: 'None',
                      isApartementHasEnoughData: false,
                      apartementName: 'None')
                ];
                NavigationProperties.selectedTabVaueNotifier(
                    NavigationProperties.addNewRealEstatePageRoute);
              },
              onShowAllApartementsInRealEstateButtonTap: () {
                NavigationProperties.selectedTabNeededParamters = [
                  7,
                  'All_Apartements'
                ];
                NavigationProperties.selectedTabVaueNotifier(
                    NavigationProperties.dataTableOfApartements);
              },
              onShowAllOwnersInRealEstateButtonTap: () {
                NavigationProperties.selectedTabNeededParamters = [
                  7,
                  'Recorded_Apartements'
                ];
                NavigationProperties.selectedTabVaueNotifier(
                    NavigationProperties.dataTableOfApartements);
              },
              width: width,
              realEstateName: realEstates.last.buildingName,
            ),
          ),
          /* *!SECTION */
          const SizedBox(
            height: 10,
          )
        ],
      );
    }
    /* *!SECTION */
    return const SizedBox();
  }
}

class RealEstateActionsWidget extends StatelessWidget {
  RealEstateActionsWidget({
    super.key,
    required this.width,
    required this.realEstateName,
    required this.onAddingNewApartementButtonTap,
    required this.onShowAllOwnersInRealEstateButtonTap,
    required this.onShowAllApartementsInRealEstateButtonTap,
  });

  final double width;
  final String realEstateName;
  final Function onAddingNewApartementButtonTap;
  final Function onShowAllOwnersInRealEstateButtonTap;
  final Function onShowAllApartementsInRealEstateButtonTap;
  /* *SECTION - OnHover Properties */
  final RxBool onAddingNewApartementButtonHoverValueNotifier = false.obs;
  final RxBool onShowAllOwnersInRealEstateValueNotifier = false.obs;
  final RxBool onShowAllApartementsInRealEstateValueNotifier = false.obs;
  /* *!SECTION */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /* *SECTION - RealEstate Title */

        Container(
          alignment: Alignment.center,
          width: width * 0.15,
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          decoration: BoxDecoration(
              color: Colors.grey[500],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Text(
            realEstateName,
            style:
                GoogleFonts.notoSansArabic(fontSize: 20, color: Colors.white),
          ),
        ),
        /* *!SECTION */
        /* *SECTION - RealEstate Actions */
        Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.grey[500] ?? Colors.white),
                    bottom: BorderSide(color: Colors.grey[500] ?? Colors.white),
                    left: BorderSide(color: Colors.grey[500] ?? Colors.white),
                    right: BorderSide(color: Colors.grey[500] ?? Colors.white)),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: [
                /* *SECTION - Add New Apartement */
                Obx(() {
                  return MenuButtonCard(
                    icon: Icons.add_home_outlined,
                    title: 'اضف وحدة جديدة',
                    onHover: (isHovering) {
                      onAddingNewApartementButtonHoverValueNotifier(isHovering);
                    },
                    menuCardRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    backgroundColor:
                        onAddingNewApartementButtonHoverValueNotifier.value
                            ? Colors.yellowAccent[100]
                            : Colors.grey[50],
                    onTap: () {
                      onAddingNewApartementButtonTap();
                    },
                  );
                }),
                /* *!SECTION */
                /* *SECTION - Show Owners In RealEstate */
                Obx(() {
                  return MenuButtonCard(
                    onHover: (isHovering) {
                      onShowAllOwnersInRealEstateValueNotifier(isHovering);
                    },
                    icon: Icons.show_chart,
                    title: width > 1250
                        ? 'استعراض الوحدات المسجلة'
                        : 'الوحدات المسجلة',
                    menuCardRadius: const BorderRadius.only(),
                    backgroundColor:
                        onShowAllOwnersInRealEstateValueNotifier.value
                            ? Colors.yellowAccent[100]
                            : Colors.grey[50],
                    onTap: () {
                      onShowAllOwnersInRealEstateButtonTap();
                    },
                  );
                }),
                /* *!SECTION */
                /* *SECTION - Show all Apartements */
                Obx(() {
                  return MenuButtonCard(
                    onHover: (isHovering) {
                      onShowAllApartementsInRealEstateValueNotifier(isHovering);
                    },
                    icon: Icons.all_inbox,
                    title:
                        width > 1250 ? 'استعراض جميع الوحدات' : 'جميع الوحدات',
                    menuCardRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    backgroundColor:
                        onShowAllApartementsInRealEstateValueNotifier.value
                            ? Colors.yellowAccent[100]
                            : Colors.grey[50],
                    onTap: () {
                      onShowAllApartementsInRealEstateButtonTap();
                    },
                  );
                }),
                /* *!SECTION */
              ],
            )),
        /* *!SECTION */
      ],
    );
  }
}

class RealEstateActionsMobileWidget extends StatelessWidget {
  RealEstateActionsMobileWidget({
    super.key,
    required this.width,
    required this.realEstateName,
    required this.onAddingNewApartementButtonTap,
    required this.onShowAllOwnersInRealEstateButtonTap,
    required this.onShowAllApartementsInRealEstateButtonTap,
  });

  final double width;
  final String realEstateName;
  final Function onAddingNewApartementButtonTap;
  final Function onShowAllOwnersInRealEstateButtonTap;
  final Function onShowAllApartementsInRealEstateButtonTap;
  /* *SECTION - OnHover Properties */
  final RxBool onAddingNewApartementButtonHoverValueNotifier = false.obs;
  final RxBool onShowAllOwnersInRealEstateValueNotifier = false.obs;
  final RxBool onShowAllApartementsInRealEstateValueNotifier = false.obs;
  /* *!SECTION */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /* *SECTION - RealEstate Title */

        Container(
          alignment: Alignment.center,
          width: width * 0.6,
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          decoration: BoxDecoration(
              color: Colors.grey[500],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Text(
            realEstateName,
            style:
                GoogleFonts.notoSansArabic(fontSize: 20, color: Colors.white),
          ),
        ),
        /* *!SECTION */
        /* *SECTION - RealEstate Actions */
        Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.grey[500] ?? Colors.white),
                    bottom: BorderSide(color: Colors.grey[500] ?? Colors.white),
                    left: BorderSide(color: Colors.grey[500] ?? Colors.white),
                    right: BorderSide(color: Colors.grey[500] ?? Colors.white)),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: [
                /* *SECTION - Add New Apartement */
                Obx(() {
                  return MenuButtonCard(
                    icon: Icons.add_home_outlined,
                    title: 'اضف وحدة جديدة',
                    onHover: (isHovering) {
                      onAddingNewApartementButtonHoverValueNotifier(isHovering);
                    },
                    menuCardRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    backgroundColor:
                        onAddingNewApartementButtonHoverValueNotifier.value
                            ? Colors.yellowAccent[100]
                            : Colors.grey[50],
                    onTap: () {
                      onAddingNewApartementButtonTap();
                    },
                  );
                }),
                /* *!SECTION */
                /* *SECTION - Show Owners In RealEstate */
                Obx(() {
                  return MenuButtonCard(
                    onHover: (isHovering) {
                      onShowAllOwnersInRealEstateValueNotifier(isHovering);
                    },
                    icon: Icons.show_chart,
                    title: 'الوحدات المسجلة',
                    menuCardRadius: const BorderRadius.only(),
                    backgroundColor:
                        onShowAllOwnersInRealEstateValueNotifier.value
                            ? Colors.yellowAccent[100]
                            : Colors.grey[50],
                    onTap: () {
                      onShowAllOwnersInRealEstateButtonTap();
                    },
                  );
                }),
                /* *!SECTION */
                /* *SECTION - Show all Apartements */
                Obx(() {
                  return MenuButtonCard(
                    onHover: (isHovering) {
                      onShowAllApartementsInRealEstateValueNotifier(isHovering);
                    },
                    icon: Icons.all_inbox,
                    title: 'جميع الوحدات',
                    menuCardRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    backgroundColor:
                        onShowAllApartementsInRealEstateValueNotifier.value
                            ? Colors.yellowAccent[100]
                            : Colors.grey[50],
                    onTap: () {
                      onShowAllApartementsInRealEstateButtonTap();
                    },
                  );
                }),
                /* *!SECTION */
              ],
            )),
        /* *!SECTION */
      ],
    );
  }
}
