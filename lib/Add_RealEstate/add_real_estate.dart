import 'package:aspania_city_group/Dashboard/menu_card_button.dart';
import 'package:aspania_city_group/class/buidlingproperties.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Dashboard/value_notifiers.dart';
import '../class/role.dart';

class AddRealEstate extends StatefulWidget {
  const AddRealEstate({
    super.key,
    this.buildingNumber = -1,
    required this.windowState,
  });
  final int buildingNumber;
  final String windowState;
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
  TextEditingController apartementLinkTextController = TextEditingController();
  TextEditingController ownerEmailTextController = TextEditingController();
  TextEditingController ownerPhoneNumberTextController =
      TextEditingController();
  TextEditingController ownerRoleTextController = TextEditingController();
  TextEditingController ownerPasswordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  /* *!SECTION */
  /* *SECTION - ValueNotfiers */
  OnHoverOnButtonValueNotifier onSaveButtonHoverValueNotifier =
      OnHoverOnButtonValueNotifier(false);
  OnHoverOnButtonValueNotifier onCancelButtonHoverValueNotifier =
      OnHoverOnButtonValueNotifier(false);
  OnHoverOnButtonValueNotifier onEditButtonHoverValueNotifier =
      OnHoverOnButtonValueNotifier(false);
  /* *!SECTION */
  /* *SECTION - Important Lists */
  final List<Building> realEstates = [
    Building(buildingName: 'عمارة رقم ۱', id: 1),
    Building(buildingName: 'عمارة رقم ۲', id: 2),
    Building(buildingName: 'عمارة رقم ۳', id: 3),
    Building(buildingName: 'عمارة رقم ٤', id: 4),
    Building(buildingName: 'عمارة رقم ٥', id: 5),
    Building(buildingName: 'عمارة رقم ٦', id: 6),
    Building(buildingName: 'عمارة رقم ۷', id: 7),
  ];
  final List<Floor> realEstateFloors = [
    Floor(floorName: 'الارضي المنخفض', id: 1),
    Floor(floorName: 'الارضي مرتفع', id: 2),
    Floor(floorName: 'الاول', id: 3),
    Floor(floorName: 'الثاني', id: 4),
    Floor(floorName: 'الثالث', id: 5),
    Floor(floorName: 'الرابع', id: 6),
  ];
  final List<ApartementStatus> apartementState = [
    ApartementStatus(state: 'مقيم', id: 1),
    ApartementStatus(state: 'تحت التشطيب', id: 2),
    ApartementStatus(state: 'مباعة \\ مغلق', id: 3),
    ApartementStatus(state: 'طرف الشركة', id: 4),
  ];

  final List<OwnerRole> ownerRole = [
    const OwnerRole(
        id: 1, ownerRole: 'Admin', roles: ['ssss', 'sss', 'sscsmahbchs']),
    const OwnerRole(
        id: 2, ownerRole: 'Owner', roles: ['ssss', 'sss', 'sscsmahbchs']),
  ];
  /* *!SECTION */
  /* *SECTION -  */
  @override
  void initState() {
    if (widget.windowState == 'EditOwner') {}
    if (widget.buildingNumber != -1) {
      apartementBuildingPositionTextController.text = realEstates
          .firstWhere((element) => element.id == widget.buildingNumber)
          .buildingName;
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
      width: width > 1350
          ? width * 0.7
          : width > 1000
              ? width * 0.8
              : width * 0.9,
      height: height * 0.8,
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                ownerRole
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .id ==
                                                                        index +
                                                                            1)
                                                                    .ownerRole;
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          title: ownerRole
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      index + 1)
                                                              .ownerRole);
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
/* *SECTION - Apartement Position And Image WIth Qr Code */
              Column(
                children: [
                  /* *SECTION - Link And Qrcode */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /* *SECTION - QrCode */
                      Container(
                        height: 200,
                        padding: const EdgeInsets.fromLTRB(20, 10, 15, 10),
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                            color: Colors.grey[200] ?? Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        width: width > 1350
                            ? width * 0.14
                            : width > 1000
                                ? width * 0.19
                                : width * 0.24,
                        child: widget.windowState == 'AddOwner'
                            ? const Center(
                                child: Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 30,
                                ),
                              )
                            : const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/download.png')),
                      ),
                      /* *!SECTION */
                      const SizedBox(
                        width: 20,
                      ),
                      /* *SECTION - Link  */
                      Container(
                          height: 200,
                          padding: const EdgeInsets.fromLTRB(20, 10, 15, 10),
                          alignment: Alignment.topRight,
                          decoration: BoxDecoration(
                              color: Colors.grey[200] ?? Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          width: width > 1350
                              ? width * 0.14
                              : width > 1000
                                  ? width * 0.19
                                  : width * 0.24,
                          child: Column(
                            children: [
                              /* *SECTION - Apartement Link */
                              TextTile(
                                width: 200,
                                height: 100,
                                textController: apartementLinkTextController,
                                hintText: 'انتظهر ظهور الرابط',
                                icon: Icons.link,
                                onTap: () {},
                                title: 'رابط الدخول',
                              ),
                              /* *!SECTION */
                            ],
                          )),
                      /* *!SECTION */
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  /* *SECTION - Apartement Postion */

                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 15, 10),
                    alignment: Alignment.topRight,
                    decoration: BoxDecoration(
                        color: Colors.grey[200] ?? Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
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
                                    alignmentDuration:
                                        const Duration(seconds: 1),
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
                                                            apartementBuildingPositionTextController
                                                                    .text =
                                                                realEstates
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .id ==
                                                                        index +
                                                                            1)
                                                                    .buildingName;
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          title: realEstates
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      index + 1)
                                                              .buildingName);
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
                                    alignmentDuration:
                                        const Duration(seconds: 1),
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
                                              itemCount:
                                                  realEstateFloors.length,
                                              itemBuilder: (context, index) {
                                                /* *SECTION - Floor Item With Hover */
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
                                                            apartementBuildingFloorPositionTextController
                                                                    .text =
                                                                realEstateFloors
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .id ==
                                                                        index +
                                                                            1)
                                                                    .floorName;
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          title: realEstateFloors
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      index + 1)
                                                              .floorName);
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
                                    alignmentDuration:
                                        const Duration(seconds: 1),
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
                                                            apartementStateTextController
                                                                    .text =
                                                                apartementState
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .id ==
                                                                        index +
                                                                            1)
                                                                    .state;
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          title: apartementState
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      index + 1)
                                                              .state);
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
                ],
              ),

              /* *!SECTION */
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          /* *SECTION - Action Buttons */
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* *SECTION -  Add Apartement button */
              widget.windowState == 'AddOwner'
                  ? ValueListenableBuilder(
                      valueListenable: onSaveButtonHoverValueNotifier,
                      builder: (context, value, _) {
                        return MouseRegion(
                            onEnter: (details) {
                              onSaveButtonHoverValueNotifier
                                  .changeOnHoverState(true);
                            },
                            onExit: (details) {
                              onSaveButtonHoverValueNotifier
                                  .changeOnHoverState(false);
                            },
                            child: Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: onSaveButtonHoverValueNotifier.onHover
                                      ? Colors.grey[500]
                                      : Colors.white,
                                  border: Border.all(
                                      color: Colors.grey[500] ?? Colors.white),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  'حفظ الوحدة',
                                  style:
                                      GoogleFonts.notoSansArabic(fontSize: 18),
                                ),
                              ),
                            ));
                      })
                  : const SizedBox(),
              const SizedBox(
                width: 20,
              ),
              /* *!SECTION */

              /* *SECTION - Edit Apartement Button */
              widget.windowState == 'EditOwner'
                  ? ValueListenableBuilder(
                      valueListenable: onEditButtonHoverValueNotifier,
                      builder: (context, value, _) {
                        return GestureDetector(
                          child: MouseRegion(
                            onEnter: (details) {
                              onEditButtonHoverValueNotifier
                                  .changeOnHoverState(true);
                            },
                            onExit: (details) {
                              onEditButtonHoverValueNotifier
                                  .changeOnHoverState(false);
                            },
                            child: Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: onEditButtonHoverValueNotifier.onHover
                                      ? Colors.grey[500]
                                      : Colors.white,
                                  border: Border.all(
                                      color: Colors.grey[500] ?? Colors.white),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  'تعديل الوحدة',
                                  style:
                                      GoogleFonts.notoSansArabic(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  : const SizedBox(),
              const SizedBox(
                width: 20,
              ),
              /* *!SECTION */
              /* *SECTION - Cancel Button */
              ValueListenableBuilder(
                  valueListenable: onCancelButtonHoverValueNotifier,
                  builder: (context, value, _) {
                    return MouseRegion(
                      onEnter: (details) {
                        onCancelButtonHoverValueNotifier
                            .changeOnHoverState(true);
                      },
                      onExit: (details) {
                        onCancelButtonHoverValueNotifier
                            .changeOnHoverState(false);
                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                            color: onCancelButtonHoverValueNotifier.onHover
                                ? Colors.grey[500]
                                : Colors.transparent,
                            border: Border.all(
                                color: Colors.grey[500] ?? Colors.white),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            'الغاء',
                            style: GoogleFonts.notoSansArabic(fontSize: 18),
                          ),
                        ),
                      ),
                    );
                  }),
              /* *!SECTION */
            ],
          )
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
    this.height = 50,
  });

  final double width;
  final double height;
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
          height: height,
          child: TextField(
            onTap: () {
              if (expandable) {
                onTap!();
              }
            },
            readOnly: expandable,
            maxLines: height != 50 ? 3 : 1,
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
