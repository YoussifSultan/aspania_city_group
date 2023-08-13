import 'package:aspania_city_group/Dashboard/value_notifiers.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Add_RealEstate/add_real_estate.dart';
import 'menu_card_button.dart';

class RealEstatesPage extends StatelessWidget {
  const RealEstatesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> realEstates = [
      'عمارة رقم ۱',
      'عمارة رقم ۲',
      'عمارة رقم ۳',
      'عمارة رقم ٤',
      'عمارة رقم ٥',
      'عمارة رقم ٦',
      'عمارة رقم ۷'
    ];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView(
      shrinkWrap: true,
      children: [
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
                /* *SECTION - RealEstate 3 */
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: RealEstateActionsWidget(
                    onAddingNewApartementButtonTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => FluidDialog(
                          // Set the first page of the dialog.
                          rootPage: FluidDialogPage(
                              alignment: Alignment
                                  .center, //Aligns the dialog to the bottom left.
                              builder: (context) {
                                return AddRealEstate(
                                  windowState: 'AddOwner',
                                  buildingNumber: index + 1,
                                );
                              }),
                        ),
                      );
                    },
                    onShowAllApartementsInRealEstateButtonTap: () {},
                    onShowAllOwnersInRealEstateButtonTap: () {},
                    width: width,
                    realEstateName: realEstates[index],
                  ),
                );
                /* *!SECTION */
              }),
        ),
        /* *SECTION - RealEstate 7 */
        Center(
          child: RealEstateActionsWidget(
            onAddingNewApartementButtonTap: () {
              showDialog(
                context: context,
                builder: (context) => FluidDialog(
                  // Set the first page of the dialog.
                  rootPage: FluidDialogPage(
                      alignment: Alignment
                          .center, //Aligns the dialog to the bottom left.
                      builder: (context) {
                        return const AddRealEstate(
                          buildingNumber: 7,
                          windowState: 'AddOwner',
                        );
                      }),
                ),
              );
            },
            onShowAllApartementsInRealEstateButtonTap: () {},
            onShowAllOwnersInRealEstateButtonTap: () {},
            width: width,
            realEstateName: realEstates.last,
          ),
        ),
        /* *!SECTION */
        const SizedBox(
          height: 10,
        )
      ],
    );
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
  OnHoverOnButtonValueNotifier onAddingNewApartementButtonHoverValueNotifier =
      OnHoverOnButtonValueNotifier(false);
  OnHoverOnButtonValueNotifier onShowAllOwnersInRealEstateValueNotifier =
      OnHoverOnButtonValueNotifier(false);
  OnHoverOnButtonValueNotifier onShowAllApartementsInRealEstateValueNotifier =
      OnHoverOnButtonValueNotifier(false);
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
                ValueListenableBuilder(
                    valueListenable:
                        onAddingNewApartementButtonHoverValueNotifier,
                    builder: (context, value, _) {
                      return MenuButtonCard(
                        icon: Icons.add_home_outlined,
                        title: 'اضف وحدة جديدة',
                        onHover: (isHovering) {
                          onAddingNewApartementButtonHoverValueNotifier
                              .changeOnHoverState(isHovering);
                        },
                        menuCardRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        backgroundColor:
                            onAddingNewApartementButtonHoverValueNotifier
                                    .onHover
                                ? Colors.grey[300]
                                : Colors.grey[50],
                        onTap: () {
                          onAddingNewApartementButtonTap();
                        },
                      );
                    }),
                /* *!SECTION */
                /* *SECTION - Show Owners In RealEstate */
                ValueListenableBuilder(
                    valueListenable: onShowAllOwnersInRealEstateValueNotifier,
                    builder: (context, value, _) {
                      return MenuButtonCard(
                        onHover: (isHovering) {
                          onShowAllOwnersInRealEstateValueNotifier
                              .changeOnHoverState(isHovering);
                        },
                        icon: Icons.show_chart,
                        title: 'استعراض الملاك',
                        menuCardRadius: const BorderRadius.only(),
                        backgroundColor:
                            onShowAllOwnersInRealEstateValueNotifier.onHover
                                ? Colors.grey[300]
                                : Colors.grey[50],
                        onTap: () {
                          onShowAllOwnersInRealEstateButtonTap();
                        },
                      );
                    }),
                /* *!SECTION */
                /* *SECTION - Show all Apartements */
                ValueListenableBuilder(
                    valueListenable:
                        onShowAllApartementsInRealEstateValueNotifier,
                    builder: (context, value, _) {
                      return MenuButtonCard(
                        onHover: (isHovering) {
                          onShowAllApartementsInRealEstateValueNotifier
                              .changeOnHoverState(isHovering);
                        },
                        icon: Icons.all_inbox,
                        title: width > 1250
                            ? 'استعراض جميع الوحدات'
                            : 'استعراض الوحدات',
                        menuCardRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20)),
                        backgroundColor:
                            onShowAllApartementsInRealEstateValueNotifier
                                    .onHover
                                ? Colors.grey[300]
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
