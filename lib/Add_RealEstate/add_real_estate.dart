import 'dart:convert';

import 'package:aspania_city_group/Common_Used/button_tile.dart';
import 'package:aspania_city_group/Common_Used/text_tile.dart';
import 'package:aspania_city_group/class/buidlingproperties.dart';
import 'package:aspania_city_group/class/realestate.dart';
import 'package:aspania_city_group/class/validators.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../Common_Used/dialog_tile.dart';
import '../Common_Used/navigation.dart';
import '../class/role.dart';

import '../Common_Used/sql_functions.dart';

class AddRealEstate extends StatefulWidget {
  const AddRealEstate({
    super.key,
    this.buildingNumber = -1,
    required this.windowState,
    this.dataToEdit,
  });
  final int buildingNumber;
  final String windowState;
  final RealEstateData? dataToEdit;
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
  RxString onApartementLinkUpdated = ''.obs;
  RxInt onApartementGarageState = 0.obs;
  /* *SECTION - Edit Data */
  RealEstateData realEstateDataToEdit = RealEstateData(
      id: 0,
      apartementStatusId: 0,
      apartementPostionInFloorId: 1,
      apartementPostionInBuildingId: 2,
      apartementLink: 'None',
      isApartementHasEnoughData: false,
      apartementName: '126');
  /* *!SECTION */
  /* *SECTION - Data Saved */

  int? buildingID;
  int? floorID;
  String? apartementID;
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
    ApartementStatus(state: 'غير مقيم', id: 2),
    ApartementStatus(state: 'طرف الشركة', id: 3),
  ];
  final List<OwnerRole> ownerRole = [
    const OwnerRole(
        id: 1, ownerRole: 'Admin', roles: ['ssss', 'sss', 'sscsmahbchs']),
    const OwnerRole(
        id: 2, ownerRole: 'Owner', roles: ['ssss', 'sss', 'sscsmahbchs']),
  ];
  List<String> errorsofTextController = [];

  /* *!SECTION */
  /* *SECTION -  initstate*/
  @override
  void initState() {
    if (widget.windowState == 'EditOwner') {
      if (widget.dataToEdit != null) {
        realEstateDataToEdit = widget.dataToEdit!;

        apartementBuildingPositionTextController.text = realEstates
            .firstWhere((element) =>
                element.id ==
                realEstateDataToEdit.apartementPostionInBuildingId)
            .buildingName;
        apartementBuildingFloorPositionTextController.text = realEstateFloors
            .firstWhere((element) =>
                element.id == realEstateDataToEdit.apartementPostionInFloorId)
            .floorName;
        apartementStateTextController.text = apartementState
            .firstWhere((element) =>
                element.id == realEstateDataToEdit.apartementStatusId)
            .state;
        apartementNumberTextController.text =
            realEstateDataToEdit.apartementName;
        buildingID = realEstateDataToEdit.apartementPostionInBuildingId;
        floorID = realEstateDataToEdit.apartementPostionInFloorId;
        apartementID = realEstateDataToEdit.apartementName;
        apartementStatusID = realEstateDataToEdit.apartementStatusId;
        onApartementLinkUpdated(
            'www.spain-city.com/id?${buildingID ?? ''}${floorID ?? ''}${apartementID ?? ''}');
        onApartementGarageState(realEstateDataToEdit.apartementGarage);
        apartementLinkTextController.text = realEstateDataToEdit.apartementLink;
        if (realEstateDataToEdit.isApartementHasEnoughData) {
          ownerNameTextController.text = realEstateDataToEdit.ownerName;
          responsibleNameTextController.text =
              realEstateDataToEdit.responsibleName;
          ownerPhoneNumberTextController.text =
              realEstateDataToEdit.ownerPhoneNumber;
          responsiblePhoneNumberTextController.text =
              realEstateDataToEdit.responsiblePhone;
          ownerEmailTextController.text = realEstateDataToEdit.ownerMail;
          ownerPasswordTextController.text = realEstateDataToEdit.ownerPassword;
          confirmPasswordTextController.text =
              realEstateDataToEdit.ownerPassword;
        }
      }
    }
    if (widget.buildingNumber != -1) {
      buildingID = realEstates
          .firstWhere((element) => element.id == widget.buildingNumber)
          .id;
      apartementBuildingPositionTextController.text = realEstates
          .firstWhere((element) => element.id == widget.buildingNumber)
          .buildingName;
      onApartementLinkUpdated(
          'www.spain-city.com/id?${buildingID ?? ''}${floorID ?? ''}${apartementID ?? ''}');
      apartementLinkTextController.text = onApartementLinkUpdated.value;
    }
    super.initState();
  }

  Future<String> insertData(RealEstateData apartement) async {
    int newID = await getLastID() + 1;
    var insertDataResponse = await SQLFunctions.sendQuery(
      query:
          "INSERT INTO `SpainCity`.`RealEstates` (`idRealEstates`, `isApartementHasEnoughData`, `ownerName`,`ownerPhoneNumber`, `ownerRole`, `ownerMail`, `ownerPassword`,`responsibleName`, `responsiblePhone`, `apartementLink`, `apartementPostionInBuildingId`, `apartementPostionInFloorId`, `apartementStatusId`, `apartementName`,`apartementGarage`) VALUES (${newID.toString()}, ${apartement.isApartementHasEnoughData == true ? 1 : 0}, \'${apartement.ownerName}\', \'${apartement.ownerPhoneNumber}\', ${apartement.ownerRole}, \'${apartement.ownerMail}\', \'${apartement.ownerPassword}\', \'${apartement.responsibleName}\', \'${apartement.responsiblePhone}\', \'${apartement.apartementLink}\',  ${apartement.apartementPostionInBuildingId}, ${apartement.apartementPostionInFloorId}, ${apartement.apartementStatusId}, \'${apartement.apartementName}\', ${apartement.apartementGarage});",
    );

    if (insertDataResponse.statusCode == 200) {
      return insertDataResponse.body;
    } else {
      return insertDataResponse.body;
    }
  }

  Future<String> editData(RealEstateData apartement) async {
    var updateDataResponse = await SQLFunctions.sendQuery(
      query:
          "UPDATE `SpainCity`.`RealEstates` SET `idRealEstates` = ${apartement.id}, `isApartementHasEnoughData` = ${apartement.isApartementHasEnoughData == true ? 1 : 0}, `ownerName` = \'${apartement.ownerName}\', `ownerPhoneNumber` = \'${apartement.ownerPhoneNumber}\', `ownerRole` = ${apartement.ownerRole}, `ownerMail` = \'${apartement.ownerMail}\', `ownerPassword` = \'${apartement.ownerPassword}\', `responsibleName` = \'${apartement.responsibleName}\', `responsiblePhone` = \'${apartement.responsiblePhone}\', `apartementLink` = \'${apartement.apartementLink}\', `apartementPostionInBuildingId` = ${apartement.apartementPostionInBuildingId}, `apartementPostionInFloorId` = ${apartement.apartementPostionInFloorId}, `apartementStatusId` = ${apartement.apartementStatusId}, `apartementName` = \'${apartement.apartementName}\' ,`apartementGarage` = ${apartement.apartementGarage} WHERE (`idRealEstates` = ${apartement.id});",
    );

    if (updateDataResponse.statusCode == 200) {
      return updateDataResponse.body;
    } else {
      return updateDataResponse.body;
    }
  }

  Future<int> getLastID() async {
    var getLastIDResponse = await SQLFunctions.sendQuery(
        query: "SELECT MAX(idRealEstates) FROM RealEstates;");

    if (getLastIDResponse.statusCode == 200) {
      var data = json.decode(getLastIDResponse.body);
      return data[0][0];
    } else {
      return int.parse(getLastIDResponse.body);
    }
  }

  Future<bool> getApartementLinksToRepeat() async {
    var getDataResponse;
    getDataResponse = await SQLFunctions.sendQuery(
        query:
            "SELECT * FROM SpainCity.RealEstates Where apartementPostionInBuildingId =$buildingID and apartementPostionInFloorId =$floorID and apartementName =$apartementID");
    bool isThereADuplicateApartement = false;

    if (getDataResponse.statusCode == 200) {
      var data = json.decode(getDataResponse.body);
      if (data == [] || data.isEmpty) {
        isThereADuplicateApartement = false;
      } else {
        isThereADuplicateApartement = true;
      }
    } else {
      isThereADuplicateApartement = false;
    }
    return isThereADuplicateApartement;
  }

  void validateAndSendData(String state) async {
    if (errorsofTextController.isEmpty) {
      if (buildingID != null &&
          floorID != null &&
          apartementID != null &&
          apartementStateTextController.text.isNotEmpty &&
          apartementNumberTextController.text.isNotEmpty &&
          !Validators.isAllElementsInListNotEmpty([
            ownerNameTextController.text,
            ownerPhoneNumberTextController.text,
            responsibleNameTextController.text,
            responsiblePhoneNumberTextController.text,
          ])) {
        if (await getApartementLinksToRepeat() && state == 'Add') {
          Get.showSnackbar(const GetSnackBar(
            animationDuration: Duration(seconds: 1),
            duration: Duration(seconds: 2),
            message: 'هذة الوحدة مسجلة من قبل',
          ));
          return;
        }
        RealEstateData realEstateData = RealEstateData(
            id: widget.dataToEdit!.id,
            apartementGarage: onApartementGarageState.value,
            apartementStatusId: apartementStatusID ?? 1,
            apartementPostionInFloorId: floorID ?? 1,
            apartementPostionInBuildingId: buildingID ?? 1,
            apartementLink: apartementLinkTextController.text,
            isApartementHasEnoughData: false,
            apartementName: apartementID.toString());
        state == 'Add'
            ? await insertData(realEstateData)
            : await editData(realEstateData);
        Get.closeAllSnackbars();
        if (state == 'Edit') {
          NavigationProperties.selectedTabVaueNotifier(
              NavigationProperties.realEstateSummaryPageRoute);
        } else {
          apartementBuildingPositionTextController.text = "";
          apartementBuildingFloorPositionTextController.text = "";
          apartementStateTextController.text = "";
          apartementNumberTextController.text = "";
          ownerNameTextController.text = "";
          responsibleNameTextController.text = "";
          responsiblePhoneNumberTextController.text = "";
          apartementLinkTextController.text = "";
          ownerEmailTextController.text = "";
          ownerPhoneNumberTextController.text = "";
          ownerRoleTextController.text = "";
          ownerPasswordTextController.text = "";
          confirmPasswordTextController.text = "";
          /* *!SECTION */
          NavigationProperties.selectedTabNeededParamters = [
            buildingID,
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
        }
        Get.showSnackbar(GetSnackBar(
          animationDuration: const Duration(seconds: 1),
          duration: const Duration(seconds: 2),
          message: state == 'Add' ? 'تم الحفظ بنجاح' : 'تم التعديل بنجاح',
        ));
      } else if (buildingID != null &&
          floorID != null &&
          apartementID != null &&
          apartementStateTextController.text.isNotEmpty &&
          apartementNumberTextController.text.isNotEmpty &&
          ownerNameTextController.text.isNotEmpty &&
          ownerPhoneNumberTextController.text.isNotEmpty) {
        if (await getApartementLinksToRepeat() && state == 'Add') {
          Get.showSnackbar(const GetSnackBar(
            animationDuration: Duration(seconds: 1),
            duration: Duration(seconds: 2),
            message: 'هذة الوحدة مسجلة من قبل',
          ));
          return;
        }
        RealEstateData realEstateData = RealEstateData(
            id: widget.dataToEdit!.id,
            ownerName: ownerNameTextController.text,
            apartementGarage: onApartementGarageState.value,
            ownerPhoneNumber: ownerPhoneNumberTextController.text,
            responsibleName: responsibleNameTextController.text.isEmpty
                ? ownerNameTextController.text
                : responsibleNameTextController.text,
            responsiblePhone: responsiblePhoneNumberTextController.text.isEmpty
                ? ownerPhoneNumberTextController.text
                : responsiblePhoneNumberTextController.text,
            apartementStatusId: apartementStatusID ?? 1,
            apartementPostionInFloorId: floorID ?? 1,
            apartementPostionInBuildingId: buildingID ?? 1,
            apartementLink: apartementLinkTextController.text,
            isApartementHasEnoughData: true,
            apartementName: apartementID.toString());
        state == 'Add'
            ? await insertData(realEstateData)
            : await editData(realEstateData);
        Get.closeAllSnackbars();
        if (state == 'Edit') {
          NavigationProperties.selectedTabVaueNotifier(
              NavigationProperties.realEstateSummaryPageRoute);
        } else {
          NavigationProperties.selectedTabNeededParamters = [
            buildingID,
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
          apartementBuildingPositionTextController.text = "";
          apartementBuildingFloorPositionTextController.text = "";
          apartementStateTextController.text = "";
          apartementNumberTextController.text = "";
          ownerNameTextController.text = "";
          responsibleNameTextController.text = "";
          responsiblePhoneNumberTextController.text = "";
          apartementLinkTextController.text = "";
          ownerEmailTextController.text = "";
          ownerPhoneNumberTextController.text = "";
          ownerRoleTextController.text = "";
          ownerPasswordTextController.text = "";
          confirmPasswordTextController.text = "";
          onApartementGarageState(0);
        }
        Get.showSnackbar(GetSnackBar(
          animationDuration: const Duration(seconds: 1),
          duration: const Duration(seconds: 2),
          message: state == 'Add' ? 'تم الحفظ بنجاح' : 'تم التعديل بنجاح',
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
          responsiblePhoneNumberTextController.text.isEmpty) {
        Get.closeAllSnackbars();
        Get.showSnackbar(const GetSnackBar(
          animationDuration: Duration(seconds: 1),
          duration: Duration(seconds: 2),
          message:
              'قم باملاء بيانات المالك ( اسم المالك \\ رقم تليفون المالك \\ اسم المسئول \\ رقم المسئول)',
        ));
      }
    }
  }

  /* *!SECTION */
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    /* *SECTION - Mobile view */
    if (NavigationProperties.sizingInformation.deviceScreenType ==
            DeviceScreenType.tablet ||
        NavigationProperties.sizingInformation.deviceScreenType ==
            DeviceScreenType.mobile) {
      return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView(children: [
            /* *SECTION -  Apartement Postion header*/
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'بيانات المالك',
                style: GoogleFonts.notoSansArabic(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            /* *!SECTION */
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /* *SECTION - Owner Name */
                TextTile(
                  width: width * 0.8,
                  onChange: (text, errorText) {
                    if (!Validators.isArabicOnly(text)) {
                      errorText('ادخل حروف فقط');
                      errorsofTextController.addIf(
                          !errorsofTextController.contains('ownerName'),
                          'ownerName');
                    } else {
                      errorText('');
                      errorsofTextController.remove('ownerName');
                    }
                  },
                  textController: ownerNameTextController,
                  hintText: 'ادخل اسم الماك',
                  icon: Icons.person_outlined,
                  title: 'اسم المالك',
                ),

                /* *!SECTION */
                /* *SECTION - Owner Phone */
                TextTile(
                  width: width * 0.8,
                  onChange: (text, errorText) {
                    if (!Validators.isNumericOrEmptyOnly(text)) {
                      errorText('ادخل ارقام فقط');
                      errorsofTextController.addIf(
                          !errorsofTextController.contains('ownerName'),
                          'ownerPhone');
                    } else {
                      errorText('');
                      errorsofTextController.remove('ownerPhone');
                    }
                  },
                  textController: ownerPhoneNumberTextController,
                  hintText: 'ادخل رقم تلفون',
                  icon: Icons.phone_outlined,
                  title: 'رقم تليفون المالك',
                ),
                /* *!SECTION */
                /* *SECTION - Responsible Name */
                TextTile(
                  width: width * 0.8,
                  onChange: (text, errorText) {
                    if (!Validators.isArabicOnly(text)) {
                      errorText('ادخل حروف فقط');
                      errorsofTextController.addIf(
                          !errorsofTextController.contains('responsibleName'),
                          'responsibleName');
                    } else {
                      errorText('');
                      errorsofTextController.remove('responsibleName');
                    }
                  },
                  textController: responsibleNameTextController,
                  hintText: 'ادخل اسم المسئول عن الوحدة',
                  icon: Icons.handshake_outlined,
                  title: 'اسم المسئول',
                ),

                /* *!SECTION */
                /* *SECTION - responsible Phone */
                TextTile(
                  width: width * 0.8,
                  onChange: (text, errorText) {
                    if (!Validators.isNumericOrEmptyOnly(text)) {
                      errorText('ادخل ارقام فقط');
                      errorsofTextController.addIf(
                          !errorsofTextController.contains('responsiblePhone'),
                          'responsiblePhone');
                    } else {
                      errorText('');
                      errorsofTextController.remove('responsiblePhone');
                    }
                  },
                  textController: responsiblePhoneNumberTextController,
                  hintText: 'ادخل رقم تليفون',
                  icon: Icons.mobile_friendly_outlined,
                  title: 'رقم تليفون المسئول',
                ),
                /* *!SECTION */
              ],
            ),
            /* *SECTION -  Apartement Data header*/
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                'بيانات الوحدة',
                style: GoogleFonts.notoSansArabic(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            /* *!SECTION */
            Column(
              children: [
                /* *SECTION - apartement buiding Position */

                TextTile(
                  width: width * 0.8,
                  onChange: (text, errorText) {},
                  onTap: () {
                    List<String> realEstateNames = [];
                    for (var element in realEstates) {
                      realEstateNames.add(element.buildingName);
                    }
                    DialogOfTile.bottomSheetTile(
                        context: context,
                        width: width,
                        height: height,
                        menuStrings: realEstateNames,
                        onMenuButtonTap: (index) {
                          Building building = realEstates
                              .firstWhere((element) => element.id == index + 1);
                          buildingID = building.id;
                          apartementBuildingPositionTextController.text =
                              building.buildingName;

                          onApartementLinkUpdated(
                              'www.www.spain-city.com/id?${buildingID ?? ''}${floorID ?? ''}${apartementID ?? ''}');
                          apartementLinkTextController.text =
                              onApartementLinkUpdated.value;
                          Navigator.of(context).pop();
                        });
                  },
                  textController: apartementBuildingPositionTextController,
                  hintText: 'ادخل رقم العمارة',
                  icon: Icons.home_filled,
                  title: 'رقم العمارة',
                ),
                /* *!SECTION */
                /* *SECTION - Floor Tile */
                TextTile(
                  width: width * 0.8,
                  textController: apartementBuildingFloorPositionTextController,
                  hintText: 'ادخل رقم الدور',
                  icon: Icons.file_upload_outlined,
                  onTap: () {
                    /* *SECTION - Show Floor Selection */
                    List<String> realEstateFloorsNames = [];
                    for (var element in realEstateFloors) {
                      realEstateFloorsNames.add(element.floorName);
                    }
                    DialogOfTile.bottomSheetTile(
                        context: context,
                        width: width,
                        height: height,
                        menuStrings: realEstateFloorsNames,
                        onMenuButtonTap: (index) {
                          Floor floor = realEstateFloors
                              .firstWhere((element) => element.id == index + 1);
                          floorID = floor.id;
                          apartementBuildingFloorPositionTextController.text =
                              floor.floorName;

                          onApartementLinkUpdated(
                              'www.spain-city.com/id?${buildingID ?? ''}${floorID ?? ''}${apartementID ?? ''}');
                          apartementLinkTextController.text =
                              onApartementLinkUpdated.value;
                          Navigator.of(context).pop();
                        });
                    /* *!SECTION */
                  },
                  title: 'رقم الدور',
                ),
                /* *!SECTION */
                /* *SECTION - apartement State  */
                TextTile(
                  width: width * 0.8,
                  onTap: () {
                    List<String> stateNames = [];
                    for (var element in apartementState) {
                      stateNames.add(element.state);
                    }
                    DialogOfTile.bottomSheetTile(
                        context: context,
                        width: width,
                        height: height,
                        menuStrings: stateNames,
                        onMenuButtonTap: (index) {
                          apartementStateTextController.text = apartementState
                              .firstWhere((element) => element.id == index + 1)
                              .state;
                          apartementStatusID = apartementState
                              .firstWhere((element) => element.id == index + 1)
                              .id;
                          Navigator.of(context).pop();
                        });
                  },
                  textController: apartementStateTextController,
                  hintText: 'اختر حالة الوحدة',
                  icon: Icons.build_outlined,
                  title: 'حالة الوحدة',
                ),

                /* *!SECTION */
                /* *SECTION - Apartement Number */
                TextTile(
                  width: width * 0.8,
                  onChange: (text, errorText) {
                    apartementID = text;
                    onApartementLinkUpdated(
                        'www.spain-city.com/id?${buildingID ?? ''}${floorID ?? ''}${apartementID ?? ''}');
                    apartementLinkTextController.text =
                        onApartementLinkUpdated.value;
                  },
                  textController: apartementNumberTextController,
                  hintText: 'ادخل رقم الوحدة',
                  icon: Icons.numbers_outlined,
                  title: 'رقم الوحدة',
                ),
                /* *!SECTION */
                /* *SECTION - Garage State */
                Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /* *SECTION - title */
                    Text(
                      'حالة الجراج',
                      style: GoogleFonts.notoSansArabic(
                          fontSize: 18, color: Colors.grey[500]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    /* *!SECTION */
                    /* *SECTION - State Selector */
                    Obx(() => Column(
                          textDirection: TextDirection.rtl,
                          children: [
                            /* *SECTION - No Share in Garage */
                            GestureDetector(
                              onTap: () {
                                onApartementGarageState(0);
                              },
                              child: Container(
                                height: 35,
                                margin: const EdgeInsets.only(left: 2),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: onApartementGarageState.value == 0
                                        ? Colors.grey[500]
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: Colors.grey[500] ?? Colors.white,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  'لا يوجد حصة جراج',
                                  style: GoogleFonts.notoSansArabic(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            /* *!SECTION */
                            const SizedBox(
                              height: 10,
                            ),
                            /* *SECTION - 1 Share in Garage */
                            GestureDetector(
                              onTap: () {
                                onApartementGarageState(1);
                              },
                              child: Container(
                                height: 35,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: onApartementGarageState.value == 1
                                      ? Colors.grey[500]
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.grey[500] ?? Colors.white,
                                      width: 2),
                                ),
                                child: Text(
                                  'حصة واحدة',
                                  style: GoogleFonts.notoSansArabic(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            /* *!SECTION */
                            const SizedBox(
                              height: 10,
                            ),
                            /* *SECTION - 2 Share in Garage */
                            GestureDetector(
                              onTap: () {
                                onApartementGarageState(2);
                              },
                              child: Container(
                                height: 35,
                                margin: const EdgeInsets.only(right: 2),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: onApartementGarageState.value == 2
                                        ? Colors.grey[500]
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: Colors.grey[500] ?? Colors.white,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  'حصتين',
                                  style: GoogleFonts.notoSansArabic(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                            /* *!SECTION */
                          ],
                        ))
                    /* *!SECTION */
                  ],
                )
                /* *!SECTION */
              ],
            ),

            /* *SECTION -  Data for Owner Entry header*/
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                'بيانات الدخول المالك',
                style: GoogleFonts.notoSansArabic(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            /* *!SECTION */
            Column(
              children: [
                /* *SECTION - Email */
                TextTile(
                  width: width * 0.8,
                  onChange: (text, errorText) {
                    if (!GetUtils.isEmail(text)) {
                      errorText('ادخل البريد صحيحا');
                      errorsofTextController.addIf(
                          !errorsofTextController.contains('email'), 'email');
                    } else {
                      errorText('');
                      errorsofTextController.remove('email');
                    }
                  },
                  textController: ownerEmailTextController,
                  hintText: 'ادخل البريد الالكتروني الماك',
                  icon: Icons.email_outlined,
                  title: 'البريد الالكتروني',
                ),
                /* *!SECTION */
                /* *SECTION - role */
                TextTile(
                  width: width * 0.8,
                  textController: ownerRoleTextController,
                  hintText: 'اختر الصلاحيات ',
                  onTap: () {
                    List<String> ownerRoleNames = [];
                    for (var element in ownerRole) {
                      ownerRoleNames.add(element.ownerRole);
                    }
                    DialogOfTile.bottomSheetTile(
                        context: context,
                        width: width,
                        height: height,
                        menuStrings: ownerRoleNames,
                        onMenuButtonTap: (index) {
                          ownerRoleTextController.text = ownerRole
                              .firstWhere((element) => element.id == index + 1)
                              .ownerRole;
                          Navigator.of(context).pop();
                        });
                  },
                  icon: Icons.manage_accounts_outlined,
                  title: 'صلاحيات المالك',
                ),
                /* *!SECTION */
                /* *SECTION - Password */
                TextTile(
                  width: width * 0.8,
                  textController: ownerPasswordTextController,
                  hintText: 'ادخل الكلمة السرية',
                  isPassword: true,
                  onChange: (text, errorText) {
                    if (text != confirmPasswordTextController.text) {
                      errorText('ادخل كلمة سرية مطابقة للخانة الاولة');
                      errorsofTextController.addIf(
                          !errorsofTextController.contains('password'),
                          'password');
                    } else {
                      errorText('');
                      errorsofTextController.remove('password');
                    }
                  },
                  icon: Icons.password_outlined,
                  title: 'الكلمة السرية',
                ),
                /* *!SECTION */
                /* *SECTION - Password Confirmation */
                TextTile(
                  width: width * 0.8,
                  textController: confirmPasswordTextController,
                  hintText: 'كلمة السرية',
                  onChange: (text, errorText) {
                    if (text != ownerPasswordTextController.text) {
                      errorText('ادخل كلمة سرية مطابقة للخانة الاولة');
                      errorsofTextController.addIf(
                          !errorsofTextController.contains('confirmpassword'),
                          'confirmpassword');
                    } else {
                      errorText('');
                      errorsofTextController.remove('confirmpassword');
                    }
                  },
                  isPassword: true,
                  icon: Icons.password_sharp,
                  title: 'تاكيد كلمة السرية',
                )
                /* *!SECTION */
              ],
            ),
            /* *SECTION - Qr Code */
            GestureDetector(
              onTap: () {},
              child: Container(
                clipBehavior: Clip.hardEdge,
                height: 200,
                alignment: Alignment.topRight,
                decoration: BoxDecoration(
                    color: Colors.grey[50] ?? Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                width: width * 0.4,
                child: Obx(() {
                  return BarcodeWidget(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    barcode: Barcode.qrCode(),
                    data: onApartementLinkUpdated.value,
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            /* *!SECTION */
            /* *SECTION - Action Buttons */
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /* *SECTION -  Add Apartement button */
                widget.windowState == 'AddOwner'
                    ? ButtonTile(
                        onTap: () async {
                          validateAndSendData('Add');
                        },
                        buttonText: 'حفظ الوحدة')
                    : const SizedBox(),
                /* *!SECTION */

                /* *SECTION - Edit Apartement Button */
                widget.windowState == 'EditOwner'
                    ? ButtonTile(
                        onTap: () async {
                          validateAndSendData('Edit');
                        },
                        buttonText: 'تعديل الوحدة')
                    : const SizedBox(),

                /* *!SECTION */
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            /* *!SECTION */
          ]));
    }
    /* *!SECTION */

    /* *SECTION - Desktop View */
    else if (NavigationProperties.sizingInformation.deviceScreenType ==
        DeviceScreenType.desktop) {
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
              widget.windowState == 'AddOwner'
                  ? SizedBox(
                      height: 50,
                      child: RoutesBuilder(routeLabels: const [
                        'الوحدات',
                        'اضافة وحدة',
                      ], routeScreen: [
                        NavigationProperties.realEstateSummaryPageRoute,
                        NavigationProperties.nonePageRoute
                      ]),
                    )
                  : widget.windowState == 'EditOwner'
                      ? SizedBox(
                          height: 50,
                          child: RoutesBuilder(routeLabels: const [
                            'الوحدات',
                            'عرض جميع الوحدات',
                            ' تعديل وحدة'
                          ], routeScreen: [
                            NavigationProperties.realEstateSummaryPageRoute,
                            NavigationProperties.realEstateSummaryPageRoute,
                            NavigationProperties.nonePageRoute
                          ]),
                        )
                      : const SizedBox(),
              /* *!SECTION */
              /* *SECTION - Action Buttons */
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* *SECTION -  Add Apartement button */
                  widget.windowState == 'AddOwner'
                      ? ButtonTile(
                          onTap: () async {
                            validateAndSendData('Add');
                          },
                          buttonText: 'حفظ الوحدة')
                      : const SizedBox(),
                  const SizedBox(
                    width: 20,
                  ),
                  /* *!SECTION */

                  /* *SECTION - Edit Apartement Button */
                  widget.windowState == 'EditOwner'
                      ? ButtonTile(
                          onTap: () async {
                            validateAndSendData('Edit');
                          },
                          buttonText: 'تعديل الوحدة')
                      : const SizedBox(),
                  const SizedBox(
                    width: 20,
                  ),
                  /* *!SECTION */
                  /* *SECTION - Cancel Button */
                  ButtonTile(
                      onTap: () {
                        NavigationProperties.selectedTabVaueNotifier(
                            NavigationProperties.realEstateSummaryPageRoute);
                      },
                      buttonText: 'الغاء')
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
                    /* *SECTION -  Owner Data header*/
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
                    OwnerDataFields(
                        width: width,
                        errorsofTextController: errorsofTextController,
                        ownerNameTextController: ownerNameTextController,
                        ownerPhoneNumberTextController:
                            ownerPhoneNumberTextController),
                    /* *!SECTION */
                    /* *SECTION - Responsible Phone And Resopnsible Name*/
                    ResponsibleDataFields(
                        width: width,
                        errorsofTextController: errorsofTextController,
                        responsibleNameTextController:
                            responsibleNameTextController,
                        responsiblePhoneNumberTextController:
                            responsiblePhoneNumberTextController),
                    /* *!SECTION */
                    /* *SECTION -  Apartement Data header*/
                    Text(
                      'بيانات الوحدة',
                      style: GoogleFonts.notoSansArabic(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    /* *!SECTION */
                    //LINK - Apartement Data
                    Column(
                      children: [
                        /* *SECTION - apartement buiding Position */

                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            TextTile(
                              width: width > 1350 ? width * 0.17 : width * 0.23,
                              onChange: (text, errorText) {},
                              onTap: () {
                                List<String> realEstateNames = [];
                                for (var element in realEstates) {
                                  realEstateNames.add(element.buildingName);
                                }
                                DialogOfTile.dialogMenuTile(
                                    context: context,
                                    width: width,
                                    height: height,
                                    menuStrings: realEstateNames,
                                    onMenuButtonTap: (index) {
                                      Building building =
                                          realEstates.firstWhere((element) =>
                                              element.id == index + 1);
                                      buildingID = building.id;
                                      apartementBuildingPositionTextController
                                          .text = building.buildingName;

                                      onApartementLinkUpdated(
                                          'www.www.spain-city.com/id?${buildingID ?? ''}${floorID ?? ''}${apartementID ?? ''}');
                                      apartementLinkTextController.text =
                                          onApartementLinkUpdated.value;
                                      Navigator.of(context).pop();
                                    });
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
                                List<String> realEstateFloorsNames = [];
                                for (var element in realEstateFloors) {
                                  realEstateFloorsNames.add(element.floorName);
                                }
                                DialogOfTile.dialogMenuTile(
                                    context: context,
                                    width: width,
                                    height: height,
                                    menuStrings: realEstateFloorsNames,
                                    onMenuButtonTap: (index) {
                                      Floor floor = realEstateFloors.firstWhere(
                                          (element) => element.id == index + 1);
                                      floorID = floor.id;
                                      apartementBuildingFloorPositionTextController
                                          .text = floor.floorName;

                                      onApartementLinkUpdated(
                                          'www.spain-city.com/id?${buildingID ?? ''}${floorID ?? ''}${apartementID ?? ''}');
                                      apartementLinkTextController.text =
                                          onApartementLinkUpdated.value;
                                      Navigator.of(context).pop();
                                    });
                                /* *!SECTION */
                              },
                              title: 'رقم الدور',
                            ),
                            /* *!SECTION */
                          ],
                        ),
                        /* *!SECTION */
                        /* *SECTION - apartement number with apartement State  */
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            /* *SECTION - Apartement State */
                            TextTile(
                              width: width > 1350 ? width * 0.17 : width * 0.23,
                              onTap: () {
                                List<String> stateNames = [];
                                for (var element in apartementState) {
                                  stateNames.add(element.state);
                                }
                                DialogOfTile.dialogMenuTile(
                                    context: context,
                                    width: width,
                                    height: height,
                                    menuStrings: stateNames,
                                    onMenuButtonTap: (index) {
                                      apartementStateTextController.text =
                                          apartementState
                                              .firstWhere((element) =>
                                                  element.id == index + 1)
                                              .state;
                                      apartementStatusID = apartementState
                                          .firstWhere((element) =>
                                              element.id == index + 1)
                                          .id;
                                      Navigator.of(context).pop();
                                    });
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
                                apartementID = text;
                                onApartementLinkUpdated(
                                    'www.spain-city.com/id?${buildingID ?? ''}${floorID ?? ''}${apartementID ?? ''}');
                                apartementLinkTextController.text =
                                    onApartementLinkUpdated.value;
                              },
                              textController: apartementNumberTextController,
                              hintText: 'ادخل رقم الوحدة',
                              icon: Icons.numbers_outlined,
                              title: 'رقم الوحدة',
                            ),
                            /* *!SECTION */
                          ],
                        ),
                        /* *!SECTION */
                        const SizedBox(
                          height: 20,
                        ),
                        /* *SECTION - Garage State */
                        Column(
                          textDirection: TextDirection.rtl,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /* *SECTION - title */
                            Text(
                              'حالة الجراج',
                              style: GoogleFonts.notoSansArabic(
                                  fontSize: 18, color: Colors.grey[500]),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            /* *!SECTION */
                            /* *SECTION - State Selector */
                            Obx(() => Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    /* *SECTION - No Share in Garage */
                                    GestureDetector(
                                      onTap: () {
                                        onApartementGarageState(0);
                                      },
                                      child: Container(
                                        height: 50,
                                        margin: const EdgeInsets.only(left: 2),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color:
                                                onApartementGarageState.value ==
                                                        0
                                                    ? Colors.grey[500]
                                                    : Colors.transparent,
                                            border: Border.all(
                                                color: Colors.grey[500] ??
                                                    Colors.white,
                                                width: 2),
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20))),
                                        child: Text(
                                          'لا يوجد حصة جراج',
                                          style: GoogleFonts.notoSansArabic(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    /* *!SECTION */
                                    /* *SECTION - 1 Share in Garage */
                                    GestureDetector(
                                      onTap: () {
                                        onApartementGarageState(1);
                                      },
                                      child: Container(
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color:
                                              onApartementGarageState.value == 1
                                                  ? Colors.grey[500]
                                                  : Colors.transparent,
                                          border: Border.all(
                                              color: Colors.grey[500] ??
                                                  Colors.white,
                                              width: 2),
                                        ),
                                        child: Text(
                                          'حصة واحدة',
                                          style: GoogleFonts.notoSansArabic(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    /* *!SECTION */
                                    /* *SECTION - 2 Share in Garage */
                                    GestureDetector(
                                      onTap: () {
                                        onApartementGarageState(2);
                                      },
                                      child: Container(
                                        height: 50,
                                        margin: const EdgeInsets.only(right: 2),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color:
                                                onApartementGarageState.value ==
                                                        2
                                                    ? Colors.grey[500]
                                                    : Colors.transparent,
                                            border: Border.all(
                                                color: Colors.grey[500] ??
                                                    Colors.white,
                                                width: 2),
                                            borderRadius: const BorderRadius
                                                .only(
                                                topLeft: Radius.circular(20),
                                                bottomLeft:
                                                    Radius.circular(20))),
                                        child: Text(
                                          'حصتين',
                                          style: GoogleFonts.notoSansArabic(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    )
                                    /* *!SECTION */
                                  ],
                                ))
                            /* *!SECTION */
                          ],
                        )
                        /* *!SECTION */
                      ],
                    ),
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
                      OwnerMailAndRoleFields(
                          width: width,
                          errorsofTextController: errorsofTextController,
                          ownerEmailTextController: ownerEmailTextController,
                          ownerRoleTextController: ownerRoleTextController,
                          ownerRole: ownerRole,
                          height: height),
                      /* *!SECTION */

                      /* *SECTION - Owner Password And Owner Confrim Password*/
                      PasswordAndConfirmationFields(
                          width: width,
                          ownerPasswordTextController:
                              ownerPasswordTextController,
                          confirmPasswordTextController:
                              confirmPasswordTextController,
                          errorsofTextController: errorsofTextController),
                      /* *!SECTION */
                    ],
                  ),

                  /* *SECTION - Link And Qrcode */
                  EntryDataQrcodeAndLink(
                      apartementLinkTextController:
                          apartementLinkTextController,
                      width: width,
                      onApartementLinkUpdated: onApartementLinkUpdated),
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
    }
    return const SizedBox();
    /* *!SECTION */
  }
}

class OwnerMailAndRoleFields extends StatelessWidget {
  const OwnerMailAndRoleFields({
    super.key,
    required this.width,
    required this.errorsofTextController,
    required this.ownerEmailTextController,
    required this.ownerRoleTextController,
    required this.ownerRole,
    required this.height,
  });

  final double width;
  final List<String> errorsofTextController;
  final TextEditingController ownerEmailTextController;
  final TextEditingController ownerRoleTextController;
  final List<OwnerRole> ownerRole;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        TextTile(
          width: width > 1350 ? width * 0.25 : width * 0.33,
          onChange: (text, errorText) {
            if (!GetUtils.isEmail(text)) {
              errorText('ادخل البريد صحيحا');
              errorsofTextController.addIf(
                  !errorsofTextController.contains('email'), 'email');
            } else {
              errorText('');
              errorsofTextController.remove('email');
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
            List<String> ownerRoleNames = [];
            for (var element in ownerRole) {
              ownerRoleNames.add(element.ownerRole);
            }
            DialogOfTile.dialogMenuTile(
                context: context,
                width: width,
                height: height,
                menuStrings: ownerRoleNames,
                onMenuButtonTap: (index) {
                  ownerRoleTextController.text = ownerRole
                      .firstWhere((element) => element.id == index + 1)
                      .ownerRole;
                  Navigator.of(context).pop();
                });
          },
          icon: Icons.manage_accounts_outlined,
          title: 'صلاحيات المالك',
        ),
      ],
    );
  }
}

class PasswordAndConfirmationFields extends StatelessWidget {
  const PasswordAndConfirmationFields({
    super.key,
    required this.width,
    required this.ownerPasswordTextController,
    required this.confirmPasswordTextController,
    required this.errorsofTextController,
  });

  final double width;
  final TextEditingController ownerPasswordTextController;
  final TextEditingController confirmPasswordTextController;
  final List<String> errorsofTextController;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              errorsofTextController.addIf(
                  !errorsofTextController.contains('password'), 'password');
            } else {
              errorText('');
              errorsofTextController.remove('password');
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
              errorsofTextController.addIf(
                  !errorsofTextController.contains('confirmpassword'),
                  'confirmpassword');
            } else {
              errorText('');
              errorsofTextController.remove('confirmpassword');
            }
          },
          isPassword: true,
          icon: Icons.password_sharp,
          title: 'تاكيد كلمة السرية',
        ),
      ],
    );
  }
}

class EntryDataQrcodeAndLink extends StatelessWidget {
  const EntryDataQrcodeAndLink({
    super.key,
    required this.apartementLinkTextController,
    required this.width,
    required this.onApartementLinkUpdated,
  });

  final TextEditingController apartementLinkTextController;
  final double width;
  final RxString onApartementLinkUpdated;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                borderRadius: const BorderRadius.all(Radius.circular(20))),
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
    );
  }
}

class ResponsibleDataFields extends StatelessWidget {
  const ResponsibleDataFields({
    super.key,
    required this.width,
    required this.errorsofTextController,
    required this.responsibleNameTextController,
    required this.responsiblePhoneNumberTextController,
  });

  final double width;
  final List<String> errorsofTextController;
  final TextEditingController responsibleNameTextController;
  final TextEditingController responsiblePhoneNumberTextController;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        /* *SECTION - Responsible Name */
        TextTile(
          width: width > 1350 ? width * 0.25 : width * 0.33,
          onChange: (text, errorText) {
            if (!Validators.isArabicOnly(text)) {
              errorText('ادخل حروف فقط');
              errorsofTextController.addIf(
                  !errorsofTextController.contains('responsibleName'),
                  'responsibleName');
            } else {
              errorText('');
              errorsofTextController.remove('responsibleName');
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
              errorsofTextController.addIf(
                  !errorsofTextController.contains('responsiblePhone'),
                  'responsiblePhone');
            } else {
              errorText('');
              errorsofTextController.remove('responsiblePhone');
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
    );
  }
}

class OwnerDataFields extends StatelessWidget {
  const OwnerDataFields({
    super.key,
    required this.width,
    required this.errorsofTextController,
    required this.ownerNameTextController,
    required this.ownerPhoneNumberTextController,
  });

  final double width;
  final List<String> errorsofTextController;
  final TextEditingController ownerNameTextController;
  final TextEditingController ownerPhoneNumberTextController;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        /* *SECTION - Owner Name */
        TextTile(
          width: width > 1350 ? width * 0.25 : width * 0.33,
          onChange: (text, errorText) {
            if (!Validators.isArabicOnly(text)) {
              errorText('ادخل حروف فقط');
              errorsofTextController.addIf(
                  !errorsofTextController.contains('ownerName'), 'ownerName');
            } else {
              errorText('');
              errorsofTextController.remove('ownerName');
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
              errorsofTextController.addIf(
                  !errorsofTextController.contains('ownerName'), 'ownerPhone');
            } else {
              errorText('');
              errorsofTextController.remove('ownerPhone');
            }
          },
          textController: ownerPhoneNumberTextController,
          hintText: 'ادخل رقم تلفون',
          icon: Icons.phone_outlined,
          title: 'رقم تليفون المالك',
        ),
        /* *!SECTION */
      ],
    );
  }
}
