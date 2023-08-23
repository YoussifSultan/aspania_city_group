import 'dart:async';
import 'dart:convert';

import 'package:aspania_city_group/class/realestate.dart';
import 'package:aspania_city_group/sql_functions.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../class/buidlingproperties.dart';
import '../class/navigation.dart';

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

  Future<void> getData() async {
    var getDataResponse =
        await SQLFunctions.sendQuery(query: "SELECT * FROM `RealEstates`");

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
    print('fetched data');
    if (_model != null) {
      print(apartements);
      _realEstates = apartements;
      _model!.notifyUpdate();
    }
  }

  @override
  void initState() {
    super.initState();

    getData();

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
    _model = DaviModel(
      rows: _realEstates.getRange(0, lastindexOfRealEstateLoaded).toList(),
      onSort: (sortedColumns) {},
      columns: [
        // Set the name of the column

        DaviColumn(
            stringValue: (row) => row.apartementName,
            name: 'رقم الوحدة',
            width: 100,
            sortable: true),
        DaviColumn(
            stringValue: (row) => realEstateFloors
                .firstWhere(
                    (element) => element.id == row.apartementPostionInFloorId)
                .floorName,
            name: 'الدور',
            width: 150,
            sortable: true),
        DaviColumn(
            width: 200,
            stringValue: (row) => buildings
                .firstWhere((element) =>
                    element.id == row.apartementPostionInBuildingId)
                .buildingName,
            name: 'العمارة',
            sortable: true),
        DaviColumn(
            width: 200,
            name: 'رقم التليفون المسئول',
            stringValue: (row) => row.responsiblePhone,
            sortable: true),
        DaviColumn(
            width: 300,
            name: 'اسم المسئول',
            stringValue: (row) => row.responsibleName,
            sortable: true),
        DaviColumn(
            width: 300,
            name: 'اسم المالك',
            stringValue: (row) => row.ownerName,
            sortable: true),
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
            name: 'التسلسل',
            width: 75,
            intValue: (row) => row.id,
            sortable: true),
      ],
    );
  }

  bool _loading = false;

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
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    RxBool onEditButtonHover = false.obs;
    RxBool onDeleteButtonHover = false.obs;
    int selectedRow = 1;
    return Column(
        /* *SECTION - Dialog */
        children: [
          const SizedBox(
            height: 20,
          ),
          /* *SECTION - Top Part */
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: 60,
              width: MediaQuery.sizeOf(context).width * 0.75,
              child: Row(
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
                      const RouteTextWIthHover(routeName: 'عرض جميع الوحدات'),
                    ],
                  ),
                  Row(
                    children: [
                      /* *SECTION - edit Button */
                      Obx(() {
                        return GestureDetector(
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
                          child: MouseRegion(
                            onEnter: (details) {
                              onEditButtonHover(true);
                            },
                            onExit: (details) {
                              onEditButtonHover(false);
                            },
                            child: Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: onEditButtonHover.value
                                      ? Colors.grey[500]
                                      : Colors.transparent,
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
                      }),
                      /* *!SECTION */
                      const SizedBox(
                        width: 20,
                      ),
                      /* *SECTION - Delete Button */
                      Obx(() {
                        return GestureDetector(
                          onTap: () async {
                            var deleteResponse = await SQLFunctions.sendQuery(
                                query:
                                    "DELETE FROM `SpainCity`.`RealEstates` WHERE (`idRealEstates` = $selectedRow);");

                            if (deleteResponse.statusCode == 200) {
                              await getData();
                              _model!.notifyUpdate();
                              Get.showSnackbar(const GetSnackBar(
                                message: 'تم الحذف بنجاح',
                              ));
                            } else {}
                          },
                          child: MouseRegion(
                            onEnter: (details) {
                              onDeleteButtonHover(true);
                            },
                            onExit: (details) {
                              onDeleteButtonHover(false);
                            },
                            child: Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: onDeleteButtonHover.value
                                      ? Colors.grey[500]
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: Colors.grey[500] ?? Colors.white),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  'حذف الوحدة',
                                  style:
                                      GoogleFonts.notoSansArabic(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      /* *!SECTION */
                      /* *!SECTION */
                    ],
                  )
                ],
              ),
            ),
          ),
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
                    return Colors.grey;
                  }
                  if (row.index.isEven) {
                    return Colors.grey.withOpacity(0.2);
                  } else {
                    return Colors.white;
                  }
                },
                lastRowWidget: const Center(
                  child: SizedBox(
                    height: 100,
                    width: 50,
                    child: CircularProgressIndicator(
                        color: Colors.black, strokeWidth: 1),
                  ),
                ),
                visibleRowsCount: int.parse((height / 50).toStringAsFixed(0)),
                columnWidthBehavior: ColumnWidthBehavior.scrollable,
                onRowTap: (data) {
                  selectedRow = data.id;
                },
              ),
            ),
          ),
        ]);
  }
}
