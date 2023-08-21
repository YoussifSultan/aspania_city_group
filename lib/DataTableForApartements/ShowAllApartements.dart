import 'dart:convert';

import 'package:aspania_city_group/class/realestate.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../class/buidlingproperties.dart';
import '../class/navigation.dart';
import 'package:http/http.dart' as http;

class ShowwAllAprtementsPage extends StatefulWidget {
  const ShowwAllAprtementsPage({super.key});

  @override
  State<ShowwAllAprtementsPage> createState() => _ShowwAllAprtementsPageState();
}

class _ShowwAllAprtementsPageState extends State<ShowwAllAprtementsPage> {
  DaviModel<RealEstateData>? _model;
  int lastindexOfRealEstateLoaded = 10;
  final List<RealEstateData> _realEstates = [
    RealEstateData(
        id: 19,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: true,
        apartementName: '125',
        ownerName: 'يوسف اسامة',
        ownerPhoneNumber: '01020314813',
        responsibleName: 'اسامة خليل',
        responsiblePhone: '0111657889'),
    RealEstateData(
        id: 19,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: true,
        apartementName: '125',
        ownerName: 'يوسف اسامة',
        ownerPhoneNumber: '01020314813',
        responsibleName: 'اسامة خليل',
        responsiblePhone: '0111657889'),
    RealEstateData(
        id: 19,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: true,
        apartementName: '125',
        ownerName: 'يوسف اسامة',
        ownerPhoneNumber: '01020314813',
        responsibleName: 'اسامة خليل',
        responsiblePhone: '0111657889'),
    RealEstateData(
        id: 19,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: true,
        apartementName: '125',
        ownerName: 'يوسف اسامة',
        ownerPhoneNumber: '01020314813',
        responsibleName: 'اسامة خليل',
        responsiblePhone: '0111657889'),
    RealEstateData(
        id: 19,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: true,
        apartementName: '125',
        ownerName: 'يوسف اسامة',
        ownerPhoneNumber: '01020314813',
        responsibleName: 'اسامة خليل',
        responsiblePhone: '0111657889'),
    RealEstateData(
        id: 19,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: true,
        apartementName: '125',
        ownerName: 'يوسف اسامة',
        ownerPhoneNumber: '01020314813',
        responsibleName: 'اسامة خليل',
        responsiblePhone: '0111657889'),
    RealEstateData(
        id: 19,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: true,
        apartementName: '125',
        ownerName: 'يوسف اسامة',
        ownerPhoneNumber: '01020314813',
        responsibleName: 'اسامة خليل',
        responsiblePhone: '0111657889'),
    RealEstateData(
        id: 19,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: true,
        apartementName: '125',
        ownerName: 'يوسف اسامة',
        ownerPhoneNumber: '01020314813',
        responsibleName: 'اسامة خليل',
        responsiblePhone: '0111657889'),
    RealEstateData(
        id: 19,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: true,
        apartementName: '125',
        ownerName: 'يوسف اسامة',
        ownerPhoneNumber: '01020314813',
        responsibleName: 'اسامة خليل',
        responsiblePhone: '0111657889'),
    RealEstateData(
        id: 19,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: true,
        apartementName: '125',
        ownerName: 'يوسف اسامة',
        ownerPhoneNumber: '01020314813',
        responsibleName: 'اسامة خليل',
        responsiblePhone: '0111657889'),
    RealEstateData(
        id: 19,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: true,
        apartementName: '125',
        ownerName: 'يوسف اسامة',
        ownerPhoneNumber: '01020314813',
        responsibleName: 'اسامة خليل',
        responsiblePhone: '0111657889'),
  ];
  Future<String> getData() async {
    final queryParameters = {
      'acc': 'n1yrefrb0p0tyoussif26dec',
    };
    var url = Uri.https(
        'www.spain-city.com',
        '/SQLFunctions/'
            'INSERT INTO `Floors` (`idFloor`, `FloorName`) VALUES (\'5\', \'Update\');',
        queryParameters);
    print("link : $url");
    var response = await http.get(url);
    print('Status Code :${response.statusCode}');
    print('Data : ${response.body}');
    return response.body;
  }

  @override
  void initState() {
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
            name: 'الوحدة',
            stringValue: (row) => apartementState
                .firstWhere((element) => element.id == row.apartementStatusId)
                .state,
            sortable: true),
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    RxBool onEditButtonHover = false.obs;

    int selectedRow = 1;
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
              /* *SECTION - edit Button */
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    NavigationProperties.selectedTabNeededParamters = [
                      -1,
                      'EditOwner',
                      _realEstates[selectedRow]
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
                      height: 50,
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
                          style: GoogleFonts.notoSansArabic(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              /* *!SECTION */
              /* *!SECTION */
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          DaviTheme(
            data: DaviThemeData(
                scrollbar: const TableScrollbarThemeData(
                    horizontalOnlyWhenNeeded: false,
                    verticalOnlyWhenNeeded: false),
                header: HeaderThemeData(
                    color: Colors.green[50],
                    bottomBorderHeight: 4,
                    bottomBorderColor: Colors.blue),
                headerCell: HeaderCellThemeData(
                    height: 40,
                    alignment: Alignment.center,
                    textStyle: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                    resizeAreaWidth: 10,
                    resizeAreaHoverColor: Colors.blue.withOpacity(.5),
                    sortIconColors: SortIconColors.all(Colors.green),
                    expandableName: false)),
            child: Davi<RealEstateData>(
              _model,
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
          )
          /* *!SECTION */
        ]);
  }
}
