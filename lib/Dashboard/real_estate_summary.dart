import 'dart:convert';

import 'package:aspania_city_group/Common_Used/button_tile.dart';
import 'package:aspania_city_group/Common_Used/dialog_tile.dart';
import 'package:aspania_city_group/Common_Used/global_class.dart';
import 'package:aspania_city_group/Common_Used/navigation.dart';
import 'package:aspania_city_group/Common_Used/sql_functions.dart';
import 'package:aspania_city_group/class/realestate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:selector_wheel/selector_wheel/models/selector_wheel_value.dart';
import 'package:selector_wheel/selector_wheel/selector_wheel.dart';

import '../class/buidlingproperties.dart';
import 'menu_card_button.dart';
import 'package:excel/excel.dart' as xlsx;
import 'package:intl/intl.dart' as intl;

class RealEstatesPage extends StatefulWidget {
  const RealEstatesPage({
    super.key,
  });

  @override
  State<RealEstatesPage> createState() => _RealEstatesPageState();
}

class _RealEstatesPageState extends State<RealEstatesPage> {
  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

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
    if (GlobalClass.sizingInformation.deviceScreenType ==
            DeviceScreenType.tablet ||
        GlobalClass.sizingInformation.deviceScreenType ==
            DeviceScreenType.mobile) {
      GlobalClass.menuOptionsMobile = [
        MenuOption(
            menuTitle: 'اضافة وحدة جديدة',
            onMenuTapButton: () {
              NavigationProperties.selectedTabNeededParamters = [
                -1,
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
            })
      ];

      return Scaffold(
        body: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
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
                        width: GlobalClass.sizingInformation.screenSize.width,
                        realEstateName: realEstates
                            .firstWhere((element) => element.id == index + 1)
                            .buildingName,
                        onShowAllCitzensInBuildingButtonTap: () {
                          NavigationProperties.selectedTabNeededParamters = [
                            '''SELECT 
    *
FROM
    SpainCity.RealEstates realestate
WHERE
    realestate.apartementPostionInBuildingId = '${index + 1}'
        AND realestate.apartementStatusId = '1';'''
                          ];
                          NavigationProperties.selectedTabVaueNotifier(
                              NavigationProperties.dataTableOfApartements);
                        },
                        ononShowAllNonCitzensInBuildingButtonTapButtonTap: () {
                          NavigationProperties.selectedTabNeededParamters = [
                            '''SELECT 
    *
FROM
    SpainCity.RealEstates realestate
WHERE
    realestate.apartementPostionInBuildingId = '${index + 1}'
        AND realestate.apartementStatusId != '1';'''
                          ];
                          NavigationProperties.selectedTabVaueNotifier(
                              NavigationProperties.dataTableOfApartements);
                        },
                        onPrintPaymentsReportButtonTap: () {
                          showBottomSheetForPrintingPaymentsAccordingToBuildingNoAndMonthAndYear(
                              context, index);
                        });
                  },
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            )),
      );
    }
    /* *!SECTION */
    /* *SECTION - Desktop View */
    else if (GlobalClass.sizingInformation.deviceScreenType ==
        DeviceScreenType.desktop) {
      /*  return ListView(
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
    */
    }
    /* *!SECTION */
    return const SizedBox();
  }

  Future<dynamic>
      showBottomSheetForPrintingPaymentsAccordingToBuildingNoAndMonthAndYear(
          BuildContext context, int index) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                color: Colors.grey[100],
              ),
              padding: const EdgeInsets.all(10),
              height: GlobalClass.sizingInformation.screenSize.height * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* *SECTION - Get All Payments Wether owner payed or no & within month */
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'عرض كشف السدادات خلال الشهر لعمارة رقم ${index + 1}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansArabic(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const Text(
                            'اسم المالك| رقم التليفون| الدور| رقم العمارة حالة الوحدة| رقم الوحدة| تاريخ السداد| قيمة المسدد',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          ButtonTile(
                              onTap: () {
                                Navigator.of(context).pop();

                                DialogTile.showMonthAndDateSelectorBottomSheet(
                                        context)
                                    .then((value) async {
                                  int selectedYear = value[0];
                                  int selectedMonth = value[1];
                                  String selectedMonthFomratted =
                                      selectedMonth.toString().padLeft(2, '0');
                                  var getDataResponse =
                                      await SQLFunctions.sendQuery(
                                          query:
                                              '''SELECT      realestate.ownerName AS 'اسم المالك',     realestate.ownerPhoneNumber AS 'رقم التليفون', 	realestate.apartementPostionInFloorId As 'الدور',     realestate.apartementPostionInBuildingId As 'رقم العمارة', 	realestate.apartementStatusId As 'حالة الوحدة', 	realestate.apartementName AS 'رقم الوحدة', 	payments.paymentDate AS 'تاريخ السداد',     CASE         WHEN ISNULL(payments.paymentAmount) THEN 'غير مسدد'         ELSE payments.paymentAmount     END AS 'قيمة المسدد' FROM     SpainCity.RealEstates realestate         LEFT OUTER JOIN     SpainCity.PaymentsOfRealEsate payments ON realestate.idRealEstates = payments.realEstateId         AND payments.paymentDate BETWEEN concat($selectedYear,'-',$selectedMonthFomratted,'-01') AND concat($selectedYear,'-',$selectedMonthFomratted,'-31')          where realestate.apartementPostionInBuildingId =${index + 1}  order by realestate.apartementName ''');
                                  if (getDataResponse.statusCode == 200) {
                                    var data =
                                        json.decode(getDataResponse.body);
                                    exportXLSXOfData(data,
                                        'عرض كشف السدادات خلال  $selectedYear/$selectedMonthلعمارة رقم ${index + 1}');
                                  } else {}
                                });
                              },
                              buttonText: 'طباعة التقرير')
                        ]),
                  ),
                  /* *!SECTION */
                ],
              ));
        });
  }

  /* *SECTION - Export Excel */
  void exportXLSXOfData(data, String title) {
    final List<Building> buildings = [
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
      ApartementStatus(state: 'test', id: 4),
    ];
    var aprtartementExcel =
        xlsx.Excel.createExcel(); // automatically creates 1 empty sheet: Sheet1
    xlsx.Sheet aprtartementsExcelSheet =
        aprtartementExcel['كشف السدادات خلال الشهر لعمارة رقم'];
    xlsx.CellStyle headerStyle = xlsx.CellStyle(
        bottomBorder: xlsx.Border(borderStyle: xlsx.BorderStyle.Thick),
        fontSize: 14,
        fontFamily: xlsx.getFontFamily(xlsx.FontFamily.Al_Nile));
    //o--g
    /* *SECTION - Initiate Column Names */
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('N7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('N7')).value =
        'اسم المالك';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('M7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('M7')).value =
        'رقم تليفون المالك';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('L7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('L7')).value =
        ' رقم العمارة';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('K7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('K7')).value =
        'الدور';

    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('J7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('J7')).value =
        'رقم الوحدة';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('I7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('I7')).value =
        'حالة الوحدة';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('H7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('H7')).value =
        'تاريخ السداد';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('G7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('G7')).value =
        'قيمة المسدد';

/* *!SECTION */
/* *SECTION - Set Values */
    int i = 0;
    for (var element in data) {
      String ownerName = element[0];
      String ownerTelephoneNumber = element[1];
      int floorNumber = element[2];
      int buildingNumber = element[3];
      int apartementStatus = element[4];
      String apartementNumber = element[5];
      String paymentDate = element[6] != null
          ? intl.DateFormat("E, d MMM yyyy hh:mm:ss")
              .parse(element[6].toString().replaceAll(' GMT', ''))
              .toString()
          : '';
      String paymentAmount = element[7];
      //اسم المالك
      aprtartementsExcelSheet
          .cell(xlsx.CellIndex.indexByString('N${i + 8}'))
          .value = ownerName;
      // رقم تليفون المالك
      aprtartementsExcelSheet
          .cell(xlsx.CellIndex.indexByString('M${i + 8}'))
          .value = ownerTelephoneNumber;
      // رقم العمارة
      aprtartementsExcelSheet
              .cell(xlsx.CellIndex.indexByString('L${i + 8}'))
              .value =
          buildings
              .firstWhere((element) => element.id == buildingNumber)
              .buildingName;
      // الدور
      aprtartementsExcelSheet
              .cell(xlsx.CellIndex.indexByString('K${i + 8}'))
              .value =
          realEstateFloors
              .firstWhere((element) => element.id == floorNumber)
              .floorName;

      // رقم الوحدة
      aprtartementsExcelSheet
          .cell(xlsx.CellIndex.indexByString('J${i + 8}'))
          .value = apartementNumber;
      // حالة الوحدة
      aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('I${i + 8}')).cellStyle =
          xlsx.CellStyle(
              backgroundColorHex: apartementStatus == 1
                  ? '#c6e0b4'
                  : apartementStatus == 2
                      ? '#ffe699'
                      : '#f8cbad');
      aprtartementsExcelSheet
              .cell(xlsx.CellIndex.indexByString('I${i + 8}'))
              .value =
          apartementState
              .firstWhere((element) => element.id == apartementStatus)
              .state;
      // تاريخ السداد
      aprtartementsExcelSheet
          .cell(xlsx.CellIndex.indexByString('H${i + 8}'))
          .value = paymentDate;

      // مبلغ المسدد
      aprtartementsExcelSheet
              .cell(xlsx.CellIndex.indexByString('G${i + 8}'))
              .cellStyle =
          xlsx.CellStyle(
              backgroundColorHex: paymentAmount.isNum ? '#c6e0b4' : '#f8cbad');
      aprtartementsExcelSheet
          .cell(xlsx.CellIndex.indexByString('G${i + 8}'))
          .value = paymentAmount;
      i = i + 1;
    }
    aprtartementExcel.save(fileName: '$title.xlsx');
/* *!SECTION */
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
    required this.onShowAllCitzensInBuildingButtonTap,
    required this.ononShowAllNonCitzensInBuildingButtonTapButtonTap,
    required this.onPrintPaymentsReportButtonTap,
  });

  final double width;
  final String realEstateName;
  final Function onShowAllCitzensInBuildingButtonTap;
  final Function ononShowAllNonCitzensInBuildingButtonTapButtonTap;
  final Function onPrintPaymentsReportButtonTap;
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
                /* *SECTION - Show Citzens in Building */
                MenuButtonCard(
                  icon: Icons.local_hotel_outlined,
                  title: 'عرض المقيمين ',
                  menuCardRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  backgroundColor: Colors.grey[50],
                  onTap: () {
                    onShowAllCitzensInBuildingButtonTap();
                  },
                ),
                /* *!SECTION */
                /* *SECTION - Show people who aren't citzens */
                MenuButtonCard(
                  icon: Icons.directions_walk_outlined,
                  title: 'عرض الغير مقيمين ',
                  menuCardRadius: const BorderRadius.only(),
                  backgroundColor: Colors.grey[50],
                  onTap: () {
                    ononShowAllNonCitzensInBuildingButtonTapButtonTap();
                  },
                ),
                /* *!SECTION */
                /* *SECTION - Payments */
                MenuButtonCard(
                  icon: Icons.document_scanner_outlined,
                  title: 'تقرير سداد',
                  menuCardRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  backgroundColor: Colors.grey[50],
                  onTap: () {
                    onPrintPaymentsReportButtonTap();
                  },
                ),
                /* *!SECTION */
              ],
            )),
        /* *!SECTION */
      ],
    );
  }
}
