import 'package:aspania_city_group/Dashboard/menu_card_button.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Dashboard/value_notifiers.dart';

class AddRealEstate extends StatefulWidget {
  const AddRealEstate({
    super.key,
    this.buildingNumber = -1,
  });
  final int buildingNumber;
  @override
  State<AddRealEstate> createState() => _AddRealEstateState();
}

class _AddRealEstateState extends State<AddRealEstate> {
  /* *SECTION - Text Controller */
  TextEditingController apartementBuildingPositionTextController =
      TextEditingController();
  TextEditingController apartementBuildingFloorPositionTextController =
      TextEditingController();
  TextEditingController apartementStateTextController = TextEditingController();
  TextEditingController apartementNumberTextController =
      TextEditingController();
  TextEditingController ownerNameTextController = TextEditingController();
  TextEditingController ownerEmailTextController = TextEditingController();
  TextEditingController ownerPhoneNumberTextController =
      TextEditingController();
  TextEditingController ownerRoleTextController = TextEditingController();
  TextEditingController ownerPasswordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  /* *!SECTION */
  /* *SECTION - Important Lists */
  final List<String> realEstates = [
    'عمارة رقم ۱',
    'عمارة رقم ۲',
    'عمارة رقم ۳',
    'عمارة رقم ٤',
    'عمارة رقم ٥',
    'عمارة رقم ٦',
    'عمارة رقم ۷'
  ];
  final List<String> realEstateFloors = [
    'الارضي منخفض',
    'الارضي مرتفع',
    'الاول',
    'الثاني',
    'الثالث',
    'الرابع',
  ];
  final List<String> apartementState = [
    'مقيم',
    'تحت التشطيب',
    'مباعة \\ مغلق',
    'طرف الشركة',
  ];
  final List<String> ownerRole = [
    'Admin',
    'Owner',
  ];
  /* *!SECTION */
  /* *SECTION -  */
  @override
  void initState() {
    if (widget.buildingNumber != -1) {
      apartementBuildingPositionTextController.text =
          realEstates[widget.buildingNumber];
    }
    super.initState();
  }

  /* *!SECTION */
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
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              /* *SECTION - Apartement Postion */

              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 15, 10),
                alignment: Alignment.topRight,
                decoration: BoxDecoration(
                    color: Colors.grey[200] ?? Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                width: width > 1350
                    ? width * 0.3
                    : width > 1000
                        ? width * 0.4
                        : width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /* *SECTION -  Apartement Postion header*/
                    Text(
                      'مواصفات الوحدة',
                      style: GoogleFonts.notoSansArabic(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    /* *!SECTION */
                    const SizedBox(
                      height: 20,
                    ),
                    /* *SECTION - apartement buiding Position */
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        TextTile(
                          width: 200,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => FluidDialog(
                                alignmentDuration: const Duration(seconds: 1),
                                alignmentCurve: Curves.bounceInOut,
                                // Set the first page of the dialog.
                                rootPage: FluidDialogPage(
                                    alignment: Alignment.bottomCenter,
                                    //Aligns the dialog to the bottom left.
                                    builder: (context) {
                                      /* *SECTION - Building Selection */
                                      return Container(
                                        padding: const EdgeInsets.all(10),
                                        width: width * 0.3,
                                        height: height * 0.4,
                                        child: ListView.builder(
                                          itemCount: realEstates.length,
                                          itemBuilder: (context, index) {
                                            /* *SECTION - Building Item With Hover */
                                            OnHoverOnButtonValueNotifier
                                                onHoverOfFloorItem =
                                                OnHoverOnButtonValueNotifier(
                                                    false);
                                            return ValueListenableBuilder(
                                                valueListenable:
                                                    onHoverOfFloorItem,
                                                builder: (context, value, _) {
                                                  return MenuButtonCard(
                                                      backgroundColor:
                                                          onHoverOfFloorItem
                                                                  .onHover
                                                              ? Colors.grey[500]
                                                              : Colors.white,
                                                      icon: Icons.abc,
                                                      hasIcon: false,
                                                      onHover: (isHovering) {
                                                        onHoverOfFloorItem
                                                            .changeOnHoverState(
                                                                isHovering);
                                                      },
                                                      onTap: () {
                                                        apartementBuildingPositionTextController
                                                                .text =
                                                            realEstates[index];
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      title:
                                                          realEstates[index]);
                                                });
                                            /* *!SECTION */
                                          },
                                        ),
                                      );
                                      /* *!SECTION */
                                    }),
                              ),
                            );
                          },
                          textController:
                              apartementBuildingPositionTextController,
                          hintText: 'ادخل رقم العمارة',
                          icon: Icons.home_filled,
                          title: 'رقم العمارة',
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        /* *SECTION - Floor Tile */
                        TextTile(
                          width: 200,
                          textController:
                              apartementBuildingFloorPositionTextController,
                          hintText: 'ادخل رقم الدور',
                          icon: Icons.file_upload_outlined,
                          onTap: () {
                            /* *SECTION - Show Floor Selection */

                            showDialog(
                              context: context,
                              builder: (context) => FluidDialog(
                                alignmentDuration: const Duration(seconds: 1),
                                alignmentCurve: Curves.bounceInOut,
                                // Set the first page of the dialog.
                                rootPage: FluidDialogPage(
                                    alignment: Alignment.bottomCenter,
                                    //Aligns the dialog to the bottom left.
                                    builder: (context) {
                                      /* *SECTION - Floors Selection */
                                      return Container(
                                        padding: const EdgeInsets.all(10),
                                        width: width * 0.3,
                                        height: height * 0.4,
                                        child: ListView.builder(
                                          itemCount: realEstateFloors.length,
                                          itemBuilder: (context, index) {
                                            /* *SECTION - Floor Item With Hover */
                                            OnHoverOnButtonValueNotifier
                                                onHoverOfFloorItem =
                                                OnHoverOnButtonValueNotifier(
                                                    false);
                                            return ValueListenableBuilder(
                                                valueListenable:
                                                    onHoverOfFloorItem,
                                                builder: (context, value, _) {
                                                  return MenuButtonCard(
                                                      backgroundColor:
                                                          onHoverOfFloorItem
                                                                  .onHover
                                                              ? Colors.grey[500]
                                                              : Colors.white,
                                                      icon: Icons.abc,
                                                      hasIcon: false,
                                                      onHover: (isHovering) {
                                                        onHoverOfFloorItem
                                                            .changeOnHoverState(
                                                                isHovering);
                                                      },
                                                      onTap: () {
                                                        apartementBuildingFloorPositionTextController
                                                                .text =
                                                            realEstateFloors[
                                                                index];
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      title: realEstateFloors[
                                                          index]);
                                                });
                                            /* *!SECTION */
                                          },
                                        ),
                                      );
                                      /* *!SECTION */
                                    }),
                              ),
                            );
                            /* *!SECTION */
                          },
                          title: 'رقم الدور',
                        ),
                        /* *!SECTION */
                      ],
                    )
                    /* *!SECTION */
                    ,
                    const SizedBox(
                      height: 20,
                    ),
                    /* *SECTION - apartement number with apartement State  */
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        /* *SECTION - Apartement State */
                        TextTile(
                          width: 200,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => FluidDialog(
                                alignmentDuration: const Duration(seconds: 1),
                                alignmentCurve: Curves.bounceInOut,
                                // Set the first page of the dialog.
                                rootPage: FluidDialogPage(
                                    alignment: Alignment.bottomCenter,
                                    //Aligns the dialog to the bottom left.
                                    builder: (context) {
                                      /* *SECTION - States Selection */
                                      return Container(
                                        padding: const EdgeInsets.all(10),
                                        width: width * 0.3,
                                        height: height * 0.3,
                                        child: ListView.builder(
                                          itemCount: apartementState.length,
                                          itemBuilder: (context, index) {
                                            /* *SECTION - States Item With Hover */
                                            OnHoverOnButtonValueNotifier
                                                onHoverOfFloorItem =
                                                OnHoverOnButtonValueNotifier(
                                                    false);
                                            return ValueListenableBuilder(
                                                valueListenable:
                                                    onHoverOfFloorItem,
                                                builder: (context, value, _) {
                                                  return MenuButtonCard(
                                                      backgroundColor:
                                                          onHoverOfFloorItem
                                                                  .onHover
                                                              ? Colors.grey[500]
                                                              : Colors.white,
                                                      icon: Icons.abc,
                                                      hasIcon: false,
                                                      onHover: (isHovering) {
                                                        onHoverOfFloorItem
                                                            .changeOnHoverState(
                                                                isHovering);
                                                      },
                                                      onTap: () {
                                                        apartementStateTextController
                                                                .text =
                                                            apartementState[
                                                                index];
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      title: apartementState[
                                                          index]);
                                                });
                                            /* *!SECTION */
                                          },
                                        ),
                                      );
                                      /* *!SECTION */
                                    }),
                              ),
                            );
                          },
                          textController: apartementStateTextController,
                          hintText: 'اختر حالة الوحدة',
                          icon: Icons.build_outlined,
                          title: 'حالة الوحدة',
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        /* *!SECTION */
                        /* *SECTION - Apartement Number */
                        TextTile(
                          width: 200,
                          textController: apartementNumberTextController,
                          hintText: 'ادخل رقم الوحدة',
                          icon: Icons.numbers_outlined,
                          title: 'رقم الوحدة',
                        ),
                        /* *!SECTION */
                      ],
                    )

                    /* *!SECTION */
                  ],
                ),
              ),
              /* *!SECTION */
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          /* *SECTION - Owner Data */
          Column(
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 15, 20),
                  alignment: Alignment.topRight,
                  decoration: BoxDecoration(
                      color: Colors.grey[200] ?? Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  width: width > 1350
                      ? width * 0.32
                      : width > 1000
                          ? width * 0.41
                          : width * 0.52,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /* *SECTION -  Apartement Postion header*/
                        Text(
                          'بيانات المالك',
                          style: GoogleFonts.notoSansArabic(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        /* *!SECTION */
                        const SizedBox(
                          height: 20,
                        ),
                        /* *SECTION - Owner Name */
                        TextTile(
                          width: width > 1350
                              ? width * 0.3
                              : width > 1000
                                  ? width * 0.4
                                  : width * 0.5,
                          textController: ownerNameTextController,
                          hintText: 'ادخل اسم الماك',
                          icon: Icons.person_outlined,
                          title: 'اسم المالك',
                        ),
                        /* *!SECTION */
                        const SizedBox(
                          height: 20,
                        ),
                        /* *SECTION - Owner Phone And Owner Role*/
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            TextTile(
                              width: width * 0.14,
                              textController: ownerPhoneNumberTextController,
                              hintText: 'ادخل رقم تلفون',
                              icon: Icons.phone_outlined,
                              title: 'رقم تليفون المالك',
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            TextTile(
                              width: width * 0.14,
                              textController: ownerRoleTextController,
                              hintText: 'اختر الصلاحيات ',
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => FluidDialog(
                                    alignmentDuration:
                                        const Duration(seconds: 1),
                                    alignmentCurve: Curves.bounceInOut,
                                    // Set the first page of the dialog.
                                    rootPage: FluidDialogPage(
                                        alignment: Alignment.bottomCenter,
                                        //Aligns the dialog to the bottom left.
                                        builder: (context) {
                                          /* *SECTION - Role Selection */
                                          return Container(
                                            padding: const EdgeInsets.all(10),
                                            width: width * 0.3,
                                            height: height * 0.2,
                                            child: ListView.builder(
                                              itemCount: ownerRole.length,
                                              itemBuilder: (context, index) {
                                                /* *SECTION - Roles Item With Hover */
                                                OnHoverOnButtonValueNotifier
                                                    onHoverOfFloorItem =
                                                    OnHoverOnButtonValueNotifier(
                                                        false);
                                                return ValueListenableBuilder(
                                                    valueListenable:
                                                        onHoverOfFloorItem,
                                                    builder:
                                                        (context, value, _) {
                                                      return MenuButtonCard(
                                                          backgroundColor:
                                                              onHoverOfFloorItem
                                                                      .onHover
                                                                  ? Colors
                                                                      .grey[500]
                                                                  : Colors
                                                                      .white,
                                                          icon: Icons.abc,
                                                          hasIcon: false,
                                                          onHover:
                                                              (isHovering) {
                                                            onHoverOfFloorItem
                                                                .changeOnHoverState(
                                                                    isHovering);
                                                          },
                                                          onTap: () {
                                                            ownerRoleTextController
                                                                    .text =
                                                                ownerRole[
                                                                    index];
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          title:
                                                              ownerRole[index]);
                                                    });
                                                /* *!SECTION */
                                              },
                                            ),
                                          );
                                          /* *!SECTION */
                                        }),
                                  ),
                                );
                              },
                              icon: Icons.manage_accounts_outlined,
                              title: 'صلاحيات المالك',
                            ),
                          ],
                        ),
                        /* *!SECTION */
                        const SizedBox(
                          height: 20,
                        ),
                        /* *SECTION - Owner Email */
                        TextTile(
                          width: width > 1350
                              ? width * 0.3
                              : width > 1000
                                  ? width * 0.4
                                  : width * 0.5,
                          textController: ownerEmailTextController,
                          hintText: 'ادخل البريد الالكتروني الماك',
                          icon: Icons.email_outlined,
                          title: 'البريد الالكتروني',
                        ),
                        /* *!SECTION */
                        const SizedBox(
                          height: 20,
                        ),
                        /* *SECTION - Owner Phone And Owner Role*/
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            TextTile(
                              width: width * 0.14,
                              textController: ownerPasswordTextController,
                              hintText: 'ادخل الكلمة السرية',
                              icon: Icons.password_outlined,
                              title: 'الكلمة السرية',
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            TextTile(
                              width: width * 0.14,
                              textController: confirmPasswordTextController,
                              hintText: 'كلمة السرية',
                              icon: Icons.password_sharp,
                              title: 'تاكيد كلمة السرية',
                            ),
                          ],
                        ),
                        /* *!SECTION */
                      ])),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey[500] ?? Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        'حفظ الوحدة',
                        style: GoogleFonts.notoSansArabic(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey[500] ?? Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        'الغاء',
                        style: GoogleFonts.notoSansArabic(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          /* *!SECTION */
        ],
      ),
    );
    /* *!SECTION */
  }
}

class TextTile extends StatelessWidget {
  const TextTile({
    super.key,
    required this.width,
    required this.textController,
    required this.title,
    required this.hintText,
    required this.icon,
    this.onTap,
  });

  final double width;
  final String title;
  final String hintText;
  final IconData icon;
  final Function? onTap;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
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
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[500] ?? Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          width: width,
          height: 50,
          child: TextField(
            onTap: () {
              if (expandable) {
                onTap!();
              }
            },
            readOnly: expandable,
            textDirection: TextDirection.rtl,
            controller: textController,
            onChanged: (value) {},
            decoration: InputDecoration(
                hintText: hintText,
                suffixIcon: Icon(icon),
                border: InputBorder.none,
                hintTextDirection: TextDirection.rtl),
          ),
        ),
      ],
    );
  }
}
