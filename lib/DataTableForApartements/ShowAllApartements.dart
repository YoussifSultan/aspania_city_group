import 'dart:async';
import 'dart:convert';

import 'package:aspania_city_group/Dashboard/menu_card_button.dart';
import 'package:aspania_city_group/class/realestate.dart';
import 'package:aspania_city_group/Common_Used/sql_functions.dart';
import 'package:davi/davi.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Common_Used/button_tile.dart';
import '../class/buidlingproperties.dart';
import '../Common_Used/navigation.dart';

class ShowwAllAprtementsPage extends StatefulWidget {
  const ShowwAllAprtementsPage({super.key});

  @override
  State<ShowwAllAprtementsPage> createState() => _ShowwAllAprtementsPageState();
}

class _ShowwAllAprtementsPageState extends State<ShowwAllAprtementsPage> {
  DaviModel<RealEstateData>? _model;
  int lastindexOfRealEstateLoaded = 0;
  List<RealEstateData> _realEstates = [];
  late ScrollController horizontalScrollControllerOfDataTable =
      ScrollController(initialScrollOffset: 1000);
  int buildingId = NavigationProperties.selectedTabNeededParamters[0];
  String allApartementsOrFullyRecordedOnly =
      NavigationProperties.selectedTabNeededParamters[1];
  bool _loading = false;
  bool reahedTheEndOfTable = false;
  int selectedRow = 0;
  Future<void> getData() async {
    var getDataResponse;
    if (allApartementsOrFullyRecordedOnly == 'All_Apartements') {
      getDataResponse = await SQLFunctions.sendQuery(
          query:
              "SELECT * FROM SpainCity.RealEstates where apartementPostionInBuildingId = $buildingId");
    } else if (allApartementsOrFullyRecordedOnly == 'Recorded_Apartements') {
      getDataResponse = await SQLFunctions.sendQuery(
          query:
              "SELECT * FROM SpainCity.RealEstates where apartementPostionInBuildingId = $buildingId and isApartementHasEnoughData =1");
    } else if (allApartementsOrFullyRecordedOnly == 'All_Owners') {
      getDataResponse = await SQLFunctions.sendQuery(
          query:
              "SELECT * FROM SpainCity.RealEstates where isApartementHasEnoughData = 1");
    }
    List<RealEstateData> apartements = [];

    if (getDataResponse.statusCode == 200) {
      var data = json.decode(getDataResponse.body);
      for (var element in data) {
        apartements.add(RealEstateData(
            id: element[0],
            apartementStatusId: element[12],
            apartementPostionInFloorId: element[11],
            apartementPostionInBuildingId: element[10],
            apartementLink: element[9],
            isApartementHasEnoughData: element[1] == 1 ? true : false,
            apartementName: element[13],
            ownerName: element[2],
            ownerPhoneNumber: element[3],
            responsibleName: element[7],
            responsiblePhone: element[8]));
      }
    } else {
      apartements.add(RealEstateData(
          id: 400,
          apartementStatusId: 400,
          apartementPostionInFloorId: 400,
          apartementPostionInBuildingId: 400,
          apartementLink: getDataResponse.body,
          isApartementHasEnoughData: false,
          apartementName: getDataResponse.body));
    }
    if (_model != null && apartements.isNotEmpty) {
      selectedRow = apartements.first.id;
      _realEstates = apartements;
      _model!.notifyUpdate();
    }
  }

  void _onLastRowWidget(bool visible) {
    if (visible && !_loading) {
      setState(() {
        _loading = true;
      });
      if (_realEstates.length > lastindexOfRealEstateLoaded + 5) {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _loading = false;
            List<RealEstateData> newValues = _realEstates
                .getRange(lastindexOfRealEstateLoaded,
                    lastindexOfRealEstateLoaded + 5)
                .toList();
            lastindexOfRealEstateLoaded += 5;
            _model!.addRows(newValues);
          });
        });
      } else if ((_realEstates.length - lastindexOfRealEstateLoaded) <= 4) {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _loading = false;
            List<RealEstateData> newValues = _realEstates
                .getRange(
                    lastindexOfRealEstateLoaded,
                    lastindexOfRealEstateLoaded +
                        (_realEstates.length - lastindexOfRealEstateLoaded))
                .toList();
            lastindexOfRealEstateLoaded = _realEstates.length;
            _model!.addRows(newValues);
            reahedTheEndOfTable = true;
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    getData();

    _model = returnTheTableUX();
  }

  DaviModel<RealEstateData> returnTheTableUX() {
    /* *SECTION - Important Lists */
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
      ApartementStatus(state: 'تحت التشطيب', id: 2),
      ApartementStatus(state: 'مباعة \\ مغلق', id: 3),
      ApartementStatus(state: 'طرف الشركة', id: 4),
    ];
    /* *!SECTION */
    return DaviModel(
      rows: _realEstates.getRange(0, lastindexOfRealEstateLoaded).toList(),
      onSort: (sortedColumns) {},
      columns: [
        // Set the name of the column

        DaviColumn(
          width: 150,
          name: 'حالة الوحدة',
          cellBuilder: (context, row) {
            return Center(
              child: Container(
                width: 100,
                height: 25,
                decoration: BoxDecoration(
                  color: row.data.apartementStatusId == 1
                      ? Colors.greenAccent.withOpacity(0.2)
                      : row.data.apartementStatusId == 2
                          ? Colors.yellowAccent.withOpacity(0.2)
                          : row.data.apartementStatusId == 3
                              ? Colors.blueAccent.withOpacity(0.2)
                              : Colors.redAccent.withOpacity(0.2),
                  border: Border.all(
                    color: row.data.apartementStatusId == 1
                        ? Colors.green.shade900
                        : row.data.apartementStatusId == 2
                            ? Colors.yellow.shade900
                            : row.data.apartementStatusId == 3
                                ? Colors.blue.shade900
                                : Colors.red.shade900,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Text(
                    apartementState
                        .firstWhere((element) =>
                            element.id == row.data.apartementStatusId)
                        .state,
                    style: TextStyle(
                      color: row.data.apartementStatusId == 1
                          ? Colors.green.shade900
                          : row.data.apartementStatusId == 2
                              ? Colors.yellow.shade900
                              : row.data.apartementStatusId == 3
                                  ? Colors.blue.shade900
                                  : Colors.red.shade900,
                    ),
                  ),
                ),
              ),
            );
          },
          sortable: true,
          intValue: (row) => row.apartementStatusId,
        ),
        DaviColumn(
            width: 300,
            name: 'اسم المسئول',
            stringValue: (row) => row.responsibleName,
            sortable: true),
        DaviColumn(
            width: 200,
            name: 'رقم التليفون المالك',
            stringValue: (row) => row.ownerPhoneNumber,
            sortable: true),
        DaviColumn(
            width: 300,
            name: 'اسم المالك',
            stringValue: (row) => row.ownerName,
            sortable: true),
        DaviColumn(
            stringValue: (row) => row.apartementName,
            name: 'رقم الوحدة',
            width: 100,
            sortable: true),
        DaviColumn(
            intValue: (row) => realEstateFloors
                .firstWhere(
                    (element) => element.id == row.apartementPostionInFloorId)
                .id,
            cellBuilder: (context, row) {
              return Text(realEstateFloors
                  .firstWhere((element) =>
                      element.id == row.data.apartementPostionInFloorId)
                  .floorName);
            },
            name: 'الدور',
            width: 150,
            sortable: true),
        DaviColumn(
            width: 200,
            intValue: (row) => buildings
                .firstWhere((element) =>
                    element.id == row.apartementPostionInBuildingId)
                .id,
            cellBuilder: (context, row) {
              return Text(
                buildings
                    .firstWhere((element) =>
                        element.id == row.data.apartementPostionInBuildingId)
                    .buildingName,
              );
            },
            name: 'العمارة',
            sortable: true),
      ],
    );
  }

  Future<void> deleteData(int id) async {
    var deleteResponse = await SQLFunctions.sendQuery(
        query:
            "DELETE FROM `SpainCity`.`RealEstates` WHERE (`idRealEstates` = $id);");

    if (deleteResponse.statusCode == 200) {
      setState(() {
        _model!.removeRow(
            _realEstates.firstWhere((element) => element.id == selectedRow));
      });

      Get.showSnackbar(const GetSnackBar(
        message: 'تم الحذف بنجاح',
      ));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
        /* *SECTION - Dialog */
        children: [
          const SizedBox(
            height: 20,
          ),
          /* *SECTION - Top Part */
          Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  child: RoutesBuilder(
                    routeLabels: [
                      'الوحدات',
                      buildingId != -1
                          ? 'عرض وحدات العمارة $buildingId'
                          : 'عرض جميع الملاك',
                    ],
                    routeScreen: [
                      NavigationProperties.realEstateSummaryPageRoute,
                      NavigationProperties.nonePageRoute
                    ],
                  ),
                ),
                Row(
                  children: [
                    /* *SECTION - edit Button */

                    ButtonTile(
                      buttonText: 'تعديل الوحدة',
                      onTap: () {
                        NavigationProperties.selectedTabNeededParamters = [
                          -1,
                          'EditOwner',
                          _realEstates.firstWhere(
                              (element) => element.id == selectedRow)
                        ];
                        NavigationProperties.selectedTabVaueNotifier(
                            NavigationProperties.addNewRealEstatePageRoute);
                      },
                    ),
                    /* *!SECTION */
                    const SizedBox(
                      width: 20,
                    ),
                    /* *SECTION - Delete Button */
                    ButtonTile(
                      buttonText: 'حذف الوحدة',
                      onTap: () async {
                        await deleteData(selectedRow);
                      },
                    ),
                    /* *!SECTION */
                    const SizedBox(
                      width: 20,
                    ),
                    /* *SECTION - Add Button */
                    ButtonTile(
                      buttonText: 'اضافة الوحدة',
                      onTap: () async {
                        NavigationProperties.selectedTabNeededParamters = [
                          buildingId,
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
                    ),
                    /* *!SECTION */
                  ],
                ),

                /* *!SECTION */
              ]),
          const SizedBox(
            height: 30,
          ),
          DaviTheme(
            data: DaviThemeData(
                columnDividerThickness: 0,
                scrollbar: const TableScrollbarThemeData(
                    horizontalOnlyWhenNeeded: false,
                    verticalOnlyWhenNeeded: true),
                header: const HeaderThemeData(
                    color: Colors.grey,
                    bottomBorderHeight: 4,
                    bottomBorderColor: Colors.white),
                headerCell: HeaderCellThemeData(
                    height: 40,
                    alignment: Alignment.center,
                    textStyle: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    resizeAreaWidth: 10,
                    resizeAreaHoverColor: Colors.blue.withOpacity(.5),
                    sortPriorityGap: 20,
                    sortIconColors: SortIconColors.all(Colors.white),
                    expandableName: false)),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Davi<RealEstateData>(
                _model,
                unpinnedHorizontalScrollController:
                    horizontalScrollControllerOfDataTable,
                onLastRowWidget: _onLastRowWidget,
                tapToSortEnabled: true,
                rowColor: (row) {
                  if (row.data.id == selectedRow) {
                    return Colors.yellowAccent[100];
                  }
                  if (row.index.isEven) {
                    return Colors.grey.withOpacity(0.2);
                  } else {
                    return Colors.white;
                  }
                },
                lastRowWidget: !reahedTheEndOfTable
                    ? const Center(
                        child: SizedBox(
                          height: 100,
                          width: 50,
                          child: CircularProgressIndicator(
                              color: Colors.black, strokeWidth: 1),
                        ),
                      )
                    : _realEstates.isEmpty
                        ? Center(
                            child: Text(
                              'لا يوجد بيانات مسجلة',
                              style: GoogleFonts.notoSansArabic(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              'تم تحميل البيانات',
                              style: GoogleFonts.notoSansArabic(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                visibleRowsCount: int.parse((height / 50).toStringAsFixed(0)),
                columnWidthBehavior: ColumnWidthBehavior.scrollable,
                onRowTap: (data) {
                  setState(() {
                    selectedRow = data.id;
                  });
                },
                onRowSecondaryTap: (data) {
                  RxBool onDeleteHover = false.obs;
                  RxBool onEditHover = false.obs;

                  showMenu(
                      context: context,
                      color: Colors.white,
                      position: RelativeRect.fromLTRB(
                          width / 2, height / 2, width / 2, height / 2),
                      items: [
                        PopupMenuItem<int>(
                          value: 0,
                          child: MenuButtonCard(
                            onTap: () {
                              deleteData(data.id);
                              Navigator.of(context).pop();
                            },
                            icon: Icons.delete_forever_outlined,
                            title: 'حذف الوحدة',
                            onHover: (ishovered) {
                              onDeleteHover(ishovered);
                            },
                            backgroundColor: onDeleteHover.value
                                ? Colors.grey[500]
                                : Colors.white,
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: MenuButtonCard(
                            onTap: () {
                              NavigationProperties.selectedTabNeededParamters =
                                  [
                                -1,
                                'EditOwner',
                                _realEstates.firstWhere(
                                    (element) => element.id == data.id)
                              ];
                              NavigationProperties.selectedTabVaueNotifier(
                                  NavigationProperties
                                      .addNewRealEstatePageRoute);
                              Navigator.of(context).pop();
                            },
                            icon: Icons.miscellaneous_services_outlined,
                            title: 'تعديل الوحدة',
                            onHover: (ishovered) {
                              onEditHover(ishovered);
                            },
                            backgroundColor: onEditHover.value
                                ? Colors.grey[500]
                                : Colors.white,
                          ),
                        ),
                      ]);
                },
              ),
            ),
          ),
        ]);
  }
}
