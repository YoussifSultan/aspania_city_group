import 'package:aspania_city_group/Common_Used/button_tile.dart';
import 'package:aspania_city_group/Common_Used/dialog_tile.dart';
import 'package:aspania_city_group/Common_Used/global_class.dart';
import 'package:aspania_city_group/Common_Used/navigation.dart';
import 'package:aspania_city_group/Common_Used/sql_functions.dart';
import 'package:aspania_city_group/Common_Used/text_tile.dart';
import 'package:aspania_city_group/class/buidlingproperties.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterPaymentsPage extends StatefulWidget {
  const FilterPaymentsPage({super.key});

  @override
  State<FilterPaymentsPage> createState() => _FilterPaymentsPageState();
}

class _FilterPaymentsPageState extends State<FilterPaymentsPage> {
  /* *SECTION - TextControllers */
  TextEditingController buildingNoTextController = TextEditingController();
  TextEditingController fromDateOfPaymentsFilterTextController =
      TextEditingController();
  TextEditingController toDateOfPaymentsFilterTextController =
      TextEditingController();
  TextEditingController ownerNameFilterTextController = TextEditingController();
  /* *!SECTION */
  /* *SECTION - Variables */
  int buildingNo = -1;
  DateTime fromDateFilter = DateTime.now().subtract(const Duration(days: 32));
  DateTime toDateFilter = DateTime.now();
  /* *!SECTION */
  final List<Building> buildings = [
    Building(buildingName: 'عمارة رقم ۱', id: 1),
    Building(buildingName: 'عمارة رقم ۲', id: 2),
    Building(buildingName: 'عمارة رقم ۳', id: 3),
    Building(buildingName: 'عمارة رقم ٤', id: 4),
    Building(buildingName: 'عمارة رقم ٥', id: 5),
    Building(buildingName: 'عمارة رقم ٦', id: 6),
    Building(buildingName: 'عمارة رقم ۷', id: 7),
    Building(buildingName: 'جميع العمارات', id: -1),
  ];
  @override
  void initState() {
    initializeDateFormatting();
    buildingNoTextController.text = buildings
        .firstWhere((element) => element.id == buildingNo)
        .buildingName;
    toDateOfPaymentsFilterTextController.text =
        intl.DateFormat.yMMMMEEEEd('ar').format(toDateFilter);
    fromDateOfPaymentsFilterTextController.text =
        intl.DateFormat.yMMMMEEEEd('ar').format(fromDateFilter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        /* *SECTION - Buidling Filter TextTile */
        TextTile(
            width: GlobalClass.sizingInformation.screenSize.width * 0.8,
            textController: buildingNoTextController,
            title: 'رقم العمارة',
            onTap: () {
              DialogTile.bottomSheetTile(
                  context: context,
                  width: GlobalClass.sizingInformation.screenSize.width,
                  height: GlobalClass.sizingInformation.screenSize.height,
                  menuText: buildings.map((e) => e.buildingName).toList(),
                  onMenuButtonTap: (index) {
                    Building building;
                    if (index == 7) {
                      building =
                          buildings.firstWhere((element) => element.id == -1);
                    } else {
                      building = buildings
                          .firstWhere((element) => element.id == index + 1);
                    }
                    buildingNo = building.id;
                    buildingNoTextController.text = building.buildingName;
                    Navigator.of(context).pop();
                  });
            },
            hintText: 'اختر العمارة',
            icon: Icons.apartment_outlined),
        /* *!SECTION */
        /* *SECTION - Date */
        /* *SECTION - From Date Filter */
        TextTile(
            width: GlobalClass.sizingInformation.screenSize.width * 0.8,
            textController: fromDateOfPaymentsFilterTextController,
            title: "عرض السدادات من تاريخ",
            hintText: "اختر التاريخ",
            onTap: () {
              showDatePicker(
                      textDirection: TextDirection.rtl,
                      cancelText: "الغاء",
                      confirmText: "تأكيد",
                      context: context,
                      initialDate: fromDateFilter,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now())
                  .then((value) {
                if (!value!.isAfter(toDateFilter)) {
                  fromDateFilter = value;

                  fromDateOfPaymentsFilterTextController.text =
                      intl.DateFormat.yMMMMEEEEd('ar').format(fromDateFilter);
                } else {
                  Get.showSnackbar(const GetSnackBar(
                    animationDuration: Duration(seconds: 1),
                    duration: Duration(seconds: 2),
                    message: 'لا يمكن ادخال تاريخ بعد خانة (الى تاريخ)',
                  ));
                }
              });
            },
            icon: Icons.calendar_today_outlined),
        /* *!SECTION */
        /* *SECTION - To Date Filter */
        TextTile(
            width: GlobalClass.sizingInformation.screenSize.width * 0.8,
            textController: toDateOfPaymentsFilterTextController,
            title: "عرض السدادات الى تاريخ",
            hintText: "اختر التاريخ",
            onTap: () {
              showDatePicker(
                      textDirection: TextDirection.rtl,
                      cancelText: "الغاء",
                      confirmText: "تأكيد",
                      context: context,
                      initialDate: toDateFilter,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now())
                  .then((value) {
                if (!value!.isBefore(fromDateFilter)) {
                  toDateFilter = value;

                  toDateOfPaymentsFilterTextController.text =
                      intl.DateFormat.yMMMMEEEEd('ar').format(toDateFilter);
                } else {
                  Get.showSnackbar(const GetSnackBar(
                    animationDuration: Duration(seconds: 1),
                    duration: Duration(seconds: 2),
                    message: 'لا يمكن ادخال تاريخ قبل خانة (من تاريخ)',
                  ));
                }
              });
            },
            icon: Icons.calendar_today_outlined),
        /* *!SECTION */
        /* *!SECTION */
        /* *SECTION - Owner Name Filter */
        TextTile(
            width: GlobalClass.sizingInformation.screenSize.width * 0.8,
            textController: ownerNameFilterTextController,
            title: "اسم المالك",
            hintText: "ادخل اسم المالك",
            icon: Icons.person_outlined),
        /* *!SECTION */
        /* *SECTION - Filter Button */
        ButtonTile(
          onTap: () async {
            String fromDatePaymentFilterString =
                "${fromDateFilter.year.toString()}-${fromDateFilter.month.toString().padLeft(2, '0')}-${fromDateFilter.day.toString().padLeft(2, '0')} ";
            String toDatePaymentFilterString =
                "${toDateFilter.year.toString()}-${toDateFilter.month.toString().padLeft(2, '0')}-${toDateFilter.day.toString().padLeft(2, '0')} ";
            if (buildingNo != -1) {
              NavigationProperties.selectedTabNeededParamters = [
                'PaymentsWithFilters',
                '''SELECT      payments.Id,     realestate.idRealEstates,     realestate.apartementPostionInBuildingId,
                         realestate.ownerName,     realestate.apartementName,     realestate.apartementPostionInFloorId,     
                    realestate.ownerPhoneNumber,     payments.paymentAmount,     payments.paymentDate,    
                   payments.paymentNote FROM     SpainCity.RealEstates realestate         JOIN    
                     SpainCity.PaymentsOfRealEsate payments ON realestate.idRealEstates = payments.realEstateId 
                            AND payments.paymentDate BETWEEN '$fromDatePaymentFilterString' AND '$toDatePaymentFilterString'      
                      AND apartementPostionInBuildingId = '$buildingNo'    
                       AND realestate.ownerName like '%${ownerNameFilterTextController.text}%' ORDER BY realestate.apartementPostionInBuildingId
              '''
              ];
            } else {
              NavigationProperties.selectedTabNeededParamters = [
                'PaymentsWithFilters',
                '''SELECT      payments.Id,     realestate.idRealEstates,     realestate.apartementPostionInBuildingId,
                         realestate.ownerName,     realestate.apartementName,     realestate.apartementPostionInFloorId,     
                    realestate.ownerPhoneNumber,     payments.paymentAmount,     payments.paymentDate,    
                   payments.paymentNote FROM     SpainCity.RealEstates realestate         JOIN    
                     SpainCity.PaymentsOfRealEsate payments ON realestate.idRealEstates = payments.realEstateId 
                            AND payments.paymentDate BETWEEN '$fromDatePaymentFilterString' AND '$toDatePaymentFilterString'       
                       AND realestate.ownerName like '%${ownerNameFilterTextController.text}%' ORDER BY realestate.apartementPostionInBuildingId
              '''
              ];
            }
            NavigationProperties.selectedTabVaueNotifier(
                NavigationProperties.overallPaymentsThroughPeriodPageRoute);
          },
          buttonText: 'تحديد البيانات',
        )
        /* *!SECTION */
      ],
    );
  }
}
