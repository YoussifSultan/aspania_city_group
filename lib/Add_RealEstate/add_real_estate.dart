import 'package:aspania_city_group/Dashboard/menu_card_button.dart';
import 'package:aspania_city_group/class/buidlingproperties.dart';
import 'package:aspania_city_group/class/realestate.dart';
import 'package:aspania_city_group/class/validators.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'package:google_fonts/google_fonts.dart';

import '../class/navigation.dart';
import '../class/role.dart';

class AddRealEstate extends StatefulWidget {
  const AddRealEstate({
    super.key,
    this.buildingNumber = -1,
    required this.windowState,
  });
  final int buildingNumber;
  static String routeName = '/AddRealEstate';
  final String windowState;
  @override
  State<AddRealEstate> createState() => _AddRealEstateState();
}

class _AddRealEstateState extends State<AddRealEstate> {
  /* *SECTION - Text Controllers */
  TextEditingController apartementBuildingPositionTextController =
      TextEditingController();
  TextEditingController apartementBuildingFloorPositionTextController =
      TextEditingController();
  TextEditingController apartementStateTextController = TextEditingController();
  TextEditingController apartementNumberTextController =
      TextEditingController();
  TextEditingController ownerNameTextController = TextEditingController();
  TextEditingController responsibleNameTextController = TextEditingController();
  TextEditingController responsiblePhoneNumberTextController =
      TextEditingController();
  TextEditingController apartementLinkTextController = TextEditingController();
  TextEditingController ownerEmailTextController = TextEditingController();
  TextEditingController ownerPhoneNumberTextController =
      TextEditingController();
  TextEditingController ownerRoleTextController = TextEditingController();
  TextEditingController ownerPasswordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  /* *!SECTION */
  /* *SECTION - ValueNotfiers */
  RxBool onSaveButtonHover = false.obs;
  RxBool onCancelButtonHover = false.obs;
  RxString onApartementLinkUpdated = ''.obs;
  RxBool onEditButtonHover = false.obs;
  RxBool onAddRealEstateRouteHover = false.obs;

  /* *!SECTION */
  /* *SECTION - Data Saved */

  int? buildingID;
  int? floorID;
  int? apartementID;
  int? apartementStatusID;

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
  /* *SECTION -  initstate*/
  @override
  void initState() {
    if (widget.windowState == 'EditOwner') {}
    if (widget.buildingNumber != -1) {
      buildingID = realEstates
          .firstWhere((element) => element.id == widget.buildingNumber)
          .id;
      apartementBuildingPositionTextController.text = realEstates
          .firstWhere((element) => element.id == widget.buildingNumber)
          .buildingName;
      onApartementLinkUpdated(
          'www.aspaniacity.com/id?${buildingID ?? ''}${floorID ?? ''}${apartementID ?? ''}');
      apartementLinkTextController.text = onApartementLinkUpdated.value;
    }
    super.initState();
  }

  /* *!SECTION */
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> ErrorsofTextController = [];
    /* *SECTION - Dialog */
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        /* *SECTION - Top Part */
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                Text(
                  ' / ',
                  style: GoogleFonts.notoSansArabic(
                      color: Colors.black, fontSize: 28),
                ),
                const RouteTextWIthHover(routeName: 'اضافة وحدة'),
              ],
            ),
            /* *!SECTION */
            /* *SECTION - Action Buttons */
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /* *SECTION -  Add Apartement button */
                widget.windowState == 'AddOwner'
                    ? Obx(() {
                        return GestureDetector(
                          onTap: () {
                            /* *SECTION - If There Is an Error */
                            if (ErrorsofTextController.isEmpty) {
                              /* *SECTION - Text Controllers 
  TextEditingController apartementBuildingPositionTextController =
      TextEditingController();
  TextEditingController apartementBuildingFloorPositionTextController =
      TextEditingController();
  TextEditingController apartementStateTextController = TextEditingController();
  TextEditingController apartementNumberTextController =
      TextEditingController();
  TextEditingController ownerNameTextController = TextEditingController();
  TextEditingController responsibleNameTextController = TextEditingController();
  TextEditingController responsiblePhoneNumberTextController =
      TextEditingController();
  TextEditingController apartementLinkTextController = TextEditingController();
  TextEditingController ownerEmailTextController = TextEditingController();
  TextEditingController ownerPhoneNumberTextController =
      TextEditingController();
  TextEditingController ownerRoleTextController = TextEditingController();
  TextEditingController ownerPasswordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
   *!SECTION */
                              if (buildingID != null &&
                                  floorID != null &&
                                  apartementID != null &&
                                  apartementStateTextController
                                      .text.isNotEmpty &&
                                  apartementNumberTextController
                                      .text.isNotEmpty &&
                                  !Validators.isAllElementsInListNotEmpty([
                                    ownerNameTextController.text,
                                    ownerPhoneNumberTextController.text,
                                    responsibleNameTextController.text,
                                    responsiblePhoneNumberTextController.text,
                                  ])) {
                                //TODO - Get The Last Id
                                RealEstateData realEstateData = RealEstateData(
                                    id: 1,
                                    apartementStatusId: apartementStatusID ?? 0,
                                    apartementPostionInFloorId: floorID ?? 0,
                                    apartementPostionInBuildingId:
                                        buildingID ?? 0,
                                    apartementLink:
                                        apartementLinkTextController.text,
                                    isApartementHasEnoughData: false,
                                    apartementName: apartementID.toString());

                                Get.closeAllSnackbars();
                                NavigationProperties.selectedTabVaueNotifier(
                                    NavigationProperties
                                        .realEstateSummaryPageRoute);
                                Get.showSnackbar(const GetSnackBar(
                                  animationDuration: Duration(seconds: 1),
                                  duration: Duration(seconds: 2),
                                  message: 'تم الحفظ بنجاح',
                                ));
                              } else if (buildingID != null &&
                                  floorID != null &&
                                  apartementID != null &&
                                  apartementStateTextController
                                      .text.isNotEmpty &&
                                  apartementNumberTextController
                                      .text.isNotEmpty &&
                                  ownerNameTextController.text.isNotEmpty &&
                                  ownerPhoneNumberTextController
                                      .text.isNotEmpty &&
                                  responsibleNameTextController
                                      .text.isNotEmpty &&
                                  responsiblePhoneNumberTextController
                                      .text.isNotEmpty) {
                                //TODO - Get The Last Id
                                RealEstateData realEstateData = RealEstateData(
                                    id: 1,
                                    apartementStatusId: apartementStatusID ?? 0,
                                    apartementPostionInFloorId: floorID ?? 0,
                                    apartementPostionInBuildingId:
                                        buildingID ?? 0,
                                    apartementLink:
                                        apartementLinkTextController.text,
                                    isApartementHasEnoughData: false,
                                    apartementName: apartementID.toString());

                                Get.closeAllSnackbars();
                                NavigationProperties.selectedTabVaueNotifier(
                                    NavigationProperties
                                        .realEstateSummaryPageRoute);
                                Get.showSnackbar(const GetSnackBar(
                                  animationDuration: Duration(seconds: 1),
                                  duration: Duration(seconds: 2),
                                  message: 'تم الحفظ بنجاح',
                                ));
                              } else if (buildingID == null ||
                                  floorID == null ||
                                  apartementID == null ||
                                  apartementStateTextController.text.isEmpty ||
                                  apartementNumberTextController.text.isEmpty) {
                                Get.closeAllSnackbars();
                                Get.showSnackbar(const GetSnackBar(
                                  animationDuration: Duration(seconds: 1),
                                  duration: Duration(seconds: 2),
                                  message:
                                      '(رقم العمارة \\ رقم الدور \\ حالة الوحدة \\ رقم الوحدة) قم باملاء البيانات الوحدة ',
                                ));
                              } else if (ownerNameTextController.text.isEmpty ||
                                  ownerPhoneNumberTextController.text.isEmpty ||
                                  responsibleNameTextController.text.isEmpty ||
                                  responsiblePhoneNumberTextController
                                      .text.isEmpty) {
                                Get.closeAllSnackbars();
                                Get.showSnackbar(const GetSnackBar(
                                  animationDuration: Duration(seconds: 1),
                                  duration: Duration(seconds: 2),
                                  message:
                                      'قم باملاء بيانات المالك ( اسم المالك \\ رقم تليفون المالك \\ اسم المسئول \\ رقم المسئول)',
                                ));
                              }
                            }

                            /* *!SECTION */
                          },
                          child: MouseRegion(
                              onEnter: (details) {
                                onSaveButtonHover(true);
                              },
                              onExit: (details) {
                                onSaveButtonHover(false);
                              },
                              child: Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: onSaveButtonHover.value
                                        ? Colors.grey[500]
                                        : Colors.white,
                                    border: Border.all(
                                        color:
                                            Colors.grey[500] ?? Colors.white),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Text(
                                    'حفظ الوحدة',
                                    style: GoogleFonts.notoSansArabic(
                                        fontSize: 18),
                                  ),
                                ),
                              )),
                        );
                      })
                    : const SizedBox(),
                const SizedBox(
                  width: 20,
                ),
                /* *!SECTION */

                /* *SECTION - Edit Apartement Button */
                widget.windowState == 'EditOwner'
                    ? Obx(() {
                        return GestureDetector(
                          onTap: () {
                            NavigationProperties.selectedTabVaueNotifier(
                                NavigationProperties
                                    .realEstateSummaryPageRoute);
                            Get.showSnackbar(const GetSnackBar(
                              animationDuration: Duration(seconds: 1),
                              duration: Duration(seconds: 2),
                              message: 'تم التعديل بنجاح',
                            ));
                          },
                          child: MouseRegion(
                            onEnter: (details) {
                              onEditButtonHover(true);
                            },
                            onExit: (details) {
                              onEditButtonHover(false);
                            },
                            child: Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: onEditButtonHover.value
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
                Obx(() {
                  return GestureDetector(
                    onTap: () {
                      NavigationProperties.selectedTabVaueNotifier(
                          NavigationProperties.realEstateSummaryPageRoute);
                    },
                    child: MouseRegion(
                      onEnter: (details) {
                        onCancelButtonHover(true);
                      },
                      onExit: (details) {
                        onCancelButtonHover(false);
                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                            color: onCancelButtonHover.value
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
                    ),
                  );
                }),
                /* *!SECTION */
              ],
            )
            /* *!SECTION */
          ],
        ),
        /* *!SECTION */
        const SizedBox(
          height: 30,
        ),
        /* *SECTION - Adding the Owner Section */
        Expanded(
            child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* *SECTION - Owner Data */
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
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

                  /* *SECTION - Owner Phone And Owner Name*/
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      /* *SECTION - Owner Name */
                      TextTile(
                        width: width > 1350 ? width * 0.25 : width * 0.33,
                        onChange: (text, errorText) {
                          if (!Validators.isArabicOnly(text)) {
                            errorText('ادخل حروف فقط');
                            ErrorsofTextController.addIf(
                                !ErrorsofTextController.contains('ownerName'),
                                'ownerName');
                          } else {
                            errorText('');
                            ErrorsofTextController.remove('ownerName');
                          }
                        },
                        textController: ownerNameTextController,
                        hintText: 'ادخل اسم الماك',
                        icon: Icons.person_outlined,
                        title: 'اسم المالك',
                      ),
                      const SizedBox(
                        width: 20,
                      ),

                      /* *!SECTION */
                      /* *SECTION - Owner Phone */
                      TextTile(
                        width: width > 1350 ? width * 0.17 : width * 0.23,
                        onChange: (text, errorText) {
                          if (!Validators.isNumericOrEmptyOnly(text)) {
                            errorText('ادخل ارقام فقط');
                            ErrorsofTextController.addIf(
                                !ErrorsofTextController.contains('ownerName'),
                                'ownerPhone');
                          } else {
                            errorText('');
                            ErrorsofTextController.remove('ownerPhone');
                          }
                        },
                        textController: ownerPhoneNumberTextController,
                        hintText: 'ادخل رقم تلفون',
                        icon: Icons.phone_outlined,
                        title: 'رقم تليفون المالك',
                      ),
                      /* *!SECTION */
                    ],
                  ),
                  /* *!SECTION */
                  /* *SECTION - Responsible Phone And Resopnsible Name*/
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      /* *SECTION - Responsible Name */
                      TextTile(
                        width: width > 1350 ? width * 0.25 : width * 0.33,
                        onChange: (text, errorText) {
                          if (!Validators.isArabicOnly(text)) {
                            errorText('ادخل حروف فقط');
                            ErrorsofTextController.addIf(
                                !ErrorsofTextController.contains(
                                    'responsibleName'),
                                'responsibleName');
                          } else {
                            errorText('');
                            ErrorsofTextController.remove('responsibleName');
                          }
                        },
                        textController: responsibleNameTextController,
                        hintText: 'ادخل اسم المسئول عن الوحدة',
                        icon: Icons.handshake_outlined,
                        title: 'اسم المسئول',
                      ),
                      const SizedBox(
                        width: 20,
                      ),

                      /* *!SECTION */
                      /* *SECTION - responsible Phone */
                      TextTile(
                        width: width > 1350 ? width * 0.17 : width * 0.23,
                        onChange: (text, errorText) {
                          if (!Validators.isNumericOrEmptyOnly(text)) {
                            errorText('ادخل ارقام فقط');
                            ErrorsofTextController.addIf(
                                !ErrorsofTextController.contains(
                                    'responsiblePhone'),
                                'responsiblePhone');
                          } else {
                            errorText('');
                            ErrorsofTextController.remove('responsiblePhone');
                          }
                        },
                        textController: responsiblePhoneNumberTextController,
                        hintText: 'ادخل رقم تليفون',
                        icon: Icons.mobile_friendly_outlined,
                        title: 'رقم تليفون المسئول',
                      ),
                      /* *!SECTION */
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  /* *!SECTION */

                  /* *SECTION - apartement buiding Position */
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      TextTile(
                        width: width > 1350 ? width * 0.17 : width * 0.23,
                        onChange: (text, errorText) {},
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
                                          RxBool onHoverOfBuildingItem =
                                              false.obs;
                                          return Obx(() {
                                            return MenuButtonCard(
                                                backgroundColor:
                                                    onHoverOfBuildingItem.value
                                                        ? Colors.grey[500]
                                                        : Colors.white,
                                                icon: Icons.abc,
                                                hasIcon: false,
                                                onHover: (isHovering) {
                                                  onHoverOfBuildingItem(
                                                      isHovering);
                                                },
                                                onTap: () {
                                                  Building building =
                                                      realEstates.firstWhere(
                                                          (element) =>
                                                              element.id ==
                                                              index + 1);
                                                  buildingID = building.id;
                                                  apartementBuildingPositionTextController
                                                          .text =
                                                      building.buildingName;

                                                  onApartementLinkUpdated(
                                                      'www.aspaniacity.com/id?${buildingID ?? ''}${floorID ?? ''}${apartementID ?? ''}');
                                                  apartementLinkTextController
                                                          .text =
                                                      onApartementLinkUpdated
                                                          .value;
                                                  Navigator.of(context).pop();
                                                },
                                                title: realEstates
                                                    .firstWhere((element) =>
                                                        element.id == index + 1)
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
                        width: width > 1350 ? width * 0.17 : width * 0.23,
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
                                          RxBool onHoverOfFloorItem = false.obs;
                                          return Obx(() {
                                            return MenuButtonCard(
                                                backgroundColor:
                                                    onHoverOfFloorItem.value
                                                        ? Colors.grey[500]
                                                        : Colors.white,
                                                icon: Icons.abc,
                                                hasIcon: false,
                                                onHover: (isHovering) {
                                                  onHoverOfFloorItem(
                                                      isHovering);
                                                },
                                                onTap: () {
                                                  Floor floor = realEstateFloors
                                                      .firstWhere((element) =>
                                                          element.id ==
                                                          index + 1);
                                                  floorID = floor.id;
                                                  apartementBuildingFloorPositionTextController
                                                      .text = floor.floorName;

                                                  onApartementLinkUpdated(
                                                      'www.aspaniacity.com/id?${buildingID ?? ''}${floorID ?? ''}${apartementID ?? ''}');
                                                  apartementLinkTextController
                                                          .text =
                                                      onApartementLinkUpdated
                                                          .value;
                                                  Navigator.of(context).pop();
                                                },
                                                title: realEstateFloors
                                                    .firstWhere((element) =>
                                                        element.id == index + 1)
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
                  /* *SECTION - apartement number with apartement State  */
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      /* *SECTION - Apartement State */
                      TextTile(
                        width: width > 1350 ? width * 0.17 : width * 0.23,
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
                                          RxBool onHoverOfStatesItem =
                                              false.obs;
                                          return Obx(() {
                                            return MenuButtonCard(
                                                backgroundColor:
                                                    onHoverOfStatesItem.value
                                                        ? Colors.grey[500]
                                                        : Colors.white,
                                                icon: Icons.abc,
                                                hasIcon: false,
                                                onHover: (isHovering) {
                                                  onHoverOfStatesItem(
                                                      isHovering);
                                                },
                                                onTap: () {
                                                  apartementStateTextController
                                                          .text =
                                                      apartementState
                                                          .firstWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  index + 1)
                                                          .state;
                                                  Navigator.of(context).pop();
                                                },
                                                title: apartementState
                                                    .firstWhere((element) =>
                                                        element.id == index + 1)
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
                        width: width > 1350 ? width * 0.17 : width * 0.23,
                        onChange: (text, errorText) {
                          if (!Validators.isNumericOrEmptyOnly(text)) {
                            errorText('ادخل ارقام فقط');
                          } else {
                            apartementID = int.parse(text);
                            onApartementLinkUpdated(
                                'www.aspaniacity.com/id?${buildingID ?? ''}${floorID ?? ''}${apartementID ?? ''}');
                            apartementLinkTextController.text =
                                onApartementLinkUpdated.value;
                          }
                        },
                        textController: apartementNumberTextController,
                        hintText: 'ادخل رقم الوحدة',
                        icon: Icons.numbers_outlined,
                        title: 'رقم الوحدة',
                      ),
                      /* *!SECTION */
                    ],
                  )

                  /* *!SECTION */
                ]),
                const SizedBox(
                  height: 20,
                ),
                /* *!SECTION */
                /* *SECTION - Apartement Position And Qr Code */
                Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /* *SECTION -  Apartement Postion header*/
                    Text(
                      'بيانات الدخول المالك',
                      style: GoogleFonts.notoSansArabic(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    /* *!SECTION */
                    const SizedBox(
                      height: 20,
                    ),
                    /* *SECTION - Owner Email with owner Role    */
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        TextTile(
                          width: width > 1350 ? width * 0.25 : width * 0.33,
                          onChange: (text, errorText) {
                            if (!GetUtils.isEmail(text)) {
                              errorText('ادخل البريد صحيحا');
                              ErrorsofTextController.addIf(
                                  !ErrorsofTextController.contains('email'),
                                  'email');
                            } else {
                              errorText('');
                              ErrorsofTextController.remove('email');
                            }
                          },
                          textController: ownerEmailTextController,
                          hintText: 'ادخل البريد الالكتروني الماك',
                          icon: Icons.email_outlined,
                          title: 'البريد الالكتروني',
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        TextTile(
                          width: width > 1350 ? width * 0.17 : width * 0.23,
                          textController: ownerRoleTextController,
                          hintText: 'اختر الصلاحيات ',
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
                                      /* *SECTION - Role Selection */
                                      return Container(
                                        padding: const EdgeInsets.all(10),
                                        width: width * 0.3,
                                        height: height * 0.2,
                                        child: ListView.builder(
                                          itemCount: ownerRole.length,
                                          itemBuilder: (context, index) {
                                            /* *SECTION - Roles Item With Hover */
                                            RxBool onHoverOfFloorItem =
                                                false.obs;
                                            return Obx(() {
                                              return MenuButtonCard(
                                                  backgroundColor:
                                                      onHoverOfFloorItem.value
                                                          ? Colors.grey[500]
                                                          : Colors.white,
                                                  icon: Icons.abc,
                                                  hasIcon: false,
                                                  onHover: (isHovering) {
                                                    onHoverOfFloorItem(
                                                        isHovering);
                                                  },
                                                  onTap: () {
                                                    ownerRoleTextController
                                                            .text =
                                                        ownerRole
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    index + 1)
                                                            .ownerRole;
                                                    //NOTE - Change this if it doesn;t work
                                                    Get.back();
                                                  },
                                                  title: ownerRole
                                                      .firstWhere((element) =>
                                                          element.id ==
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

                    /* *SECTION - Owner Password And Owner Confrim Password*/
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        TextTile(
                          width: width > 1350 ? width * 0.17 : width * 0.23,
                          textController: ownerPasswordTextController,
                          hintText: 'ادخل الكلمة السرية',
                          isPassword: true,
                          onChange: (text, errorText) {
                            if (text != confirmPasswordTextController.text) {
                              errorText('ادخل كلمة سرية مطابقة للخانة الاولة');
                              ErrorsofTextController.addIf(
                                  !ErrorsofTextController.contains('password'),
                                  'password');
                            } else {
                              errorText('');
                              ErrorsofTextController.remove('password');
                            }
                          },
                          icon: Icons.password_outlined,
                          title: 'الكلمة السرية',
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        TextTile(
                          width: width > 1350 ? width * 0.17 : width * 0.23,
                          textController: confirmPasswordTextController,
                          hintText: 'كلمة السرية',
                          onChange: (text, errorText) {
                            if (text != ownerPasswordTextController.text) {
                              errorText('ادخل كلمة سرية مطابقة للخانة الاولة');
                              ErrorsofTextController.addIf(
                                  !ErrorsofTextController.contains(
                                      'confirmpassword'),
                                  'confirmpassword');
                            } else {
                              errorText('');
                              ErrorsofTextController.remove('confirmpassword');
                            }
                          },
                          isPassword: true,
                          icon: Icons.password_sharp,
                          title: 'تاكيد كلمة السرية',
                        ),
                      ],
                    ),
                    /* *!SECTION */
                  ],
                ),

                /* *SECTION - Link And Qrcode */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.rtl,
                  children: [
                    /* *SECTION - Link  */
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
                    /* *SECTION - Qr Code */
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        height: 200,
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
                        child: Obx(() {
                          return BarcodeWidget(
                            barcode: Barcode.qrCode(),
                            data: onApartementLinkUpdated.value,
                          );
                        }),
                      ),
                    ),
                    /* *!SECTION */
                  ],
                ),
                /* *!SECTION */
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ))
        /* *!SECTION */
      ],
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
    this.onChange,
    this.isPassword = false,
  });

  final double width;
  final double height;
  final bool isPassword;
  final String title;
  final String hintText;
  final IconData icon;
  final Function? onTap;
  final Function? onChange;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    final RxString errorText = ''.obs;
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
          height: 10,
        ),
        Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /* *SECTION - TextField */
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey[500] ?? Colors.black),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
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
                    onChanged: (value) {
                      if (onChange != null) {
                        onChange!(value, errorText);
                      }
                    },
                    obscureText: isPassword,
                    enableSuggestions: isPassword ? false : true,
                    autocorrect: isPassword ? false : true,
                    decoration: InputDecoration(
                        hintText: hintText,
                        suffixIcon: Icon(icon),
                        border: InputBorder.none,
                        hintTextDirection: TextDirection.rtl),
                  )),
              /* *!SECTION */
              const SizedBox(
                height: 5,
              ),
              /* *SECTION - Error Text */
              Visibility(
                  visible: errorText.isNotEmpty,
                  child: Text(
                    errorText.value,
                    style: GoogleFonts.notoSansArabic(
                        color: Colors.red, fontSize: 14),
                  )),
              SizedBox(
                height: errorText.isNotEmpty ? 5 : 15,
              )
              /* *!SECTION */
            ],
          );
        }),
      ],
    );
  }
}
