import 'package:aspania_city_group/class/realestate.dart';
import 'package:data_table_2/data_table_2.dart';
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
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
              /* *!SECTION */
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Expanded(
              child: PaginatedDataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 1500,
                wrapInCard: true,
                horizontalScrollController: ScrollController(),
                sortArrowAlwaysVisible: true,
                autoRowsToHeight:
                    true, // Datatable widget that have the property columns and rows.
                columns: [
                  // Set the name of the column
                  DataColumn2(
                    onSort: (columnIndex, ascending) {},
                    fixedWidth: 75,
                    label: const Text('التسلسل'),
                    numeric: true,
                  ),
                  const DataColumn2(
                    fixedWidth: 100,
                    label: Text('الوحدة'),
                    numeric: true,
                  ),
                  const DataColumn2(
                    fixedWidth: 300,
                    label: Text('اسم المالك'),
                  ),
                  const DataColumn2(
                    fixedWidth: 300,
                    label: Text('اسم المسئول'),
                  ),
                  const DataColumn2(
                    fixedWidth: 150,
                    label: Text('رقم التليفون المسئول'),
                  ),
                  const DataColumn2(
                    fixedWidth: 150,
                    label: Text('العمارة'),
                  ),
                  const DataColumn2(
                    label: Text('الدور'),
                  ),
                  const DataColumn2(
                    label: Text('رقم الوحدة'),
                  ),
                ],
                source: RealEstateDataSource(context),
              ),
            ),

            /* *!SECTION */
          )
        ]);
  }
}

class RealEstateDataSource extends DataTableSource {
  final List<RealEstateData> _realEstates = [
    RealEstateData(
        id: 1,
        apartementStatusId: 1,
        apartementPostionInFloorId: 2,
        apartementPostionInBuildingId: 3,
        apartementLink: 'www.spain-city.com/id?23150',
        isApartementHasEnoughData: false,
        apartementName: '150'),
    RealEstateData(
        id: 2,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: false,
        apartementName: '125'),
    RealEstateData(
        id: 3,
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
        id: 4,
        apartementStatusId: 3,
        apartementPostionInFloorId: 4,
        apartementPostionInBuildingId: 1,
        apartementLink: 'www.spain-city.com/id?41450',
        isApartementHasEnoughData: true,
        apartementName: '450',
        ownerName: 'محمد مصطفى',
        ownerPhoneNumber: '01265789897',
        responsibleName: 'مرسي محمود',
        responsiblePhone: '0152089252'),
    RealEstateData(
        id: 1,
        apartementStatusId: 1,
        apartementPostionInFloorId: 2,
        apartementPostionInBuildingId: 3,
        apartementLink: 'www.spain-city.com/id?23150',
        isApartementHasEnoughData: false,
        apartementName: '150'),
    RealEstateData(
        id: 2,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: false,
        apartementName: '125'),
    RealEstateData(
        id: 3,
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
        id: 4,
        apartementStatusId: 3,
        apartementPostionInFloorId: 4,
        apartementPostionInBuildingId: 1,
        apartementLink: 'www.spain-city.com/id?41450',
        isApartementHasEnoughData: true,
        apartementName: '450',
        ownerName: 'محمد مصطفى',
        ownerPhoneNumber: '01265789897',
        responsibleName: 'مرسي محمود',
        responsiblePhone: '0152089252'),
    RealEstateData(
        id: 1,
        apartementStatusId: 1,
        apartementPostionInFloorId: 2,
        apartementPostionInBuildingId: 3,
        apartementLink: 'www.spain-city.com/id?23150',
        isApartementHasEnoughData: false,
        apartementName: '150'),
    RealEstateData(
        id: 2,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: false,
        apartementName: '125'),
    RealEstateData(
        id: 3,
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
        id: 4,
        apartementStatusId: 3,
        apartementPostionInFloorId: 4,
        apartementPostionInBuildingId: 1,
        apartementLink: 'www.spain-city.com/id?41450',
        isApartementHasEnoughData: true,
        apartementName: '450',
        ownerName: 'محمد مصطفى',
        ownerPhoneNumber: '01265789897',
        responsibleName: 'مرسي محمود',
        responsiblePhone: '0152089252'),
    RealEstateData(
        id: 1,
        apartementStatusId: 1,
        apartementPostionInFloorId: 2,
        apartementPostionInBuildingId: 3,
        apartementLink: 'www.spain-city.com/id?23150',
        isApartementHasEnoughData: false,
        apartementName: '150'),
    RealEstateData(
        id: 2,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: false,
        apartementName: '125'),
    RealEstateData(
        id: 3,
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
        id: 4,
        apartementStatusId: 3,
        apartementPostionInFloorId: 4,
        apartementPostionInBuildingId: 1,
        apartementLink: 'www.spain-city.com/id?41450',
        isApartementHasEnoughData: true,
        apartementName: '450',
        ownerName: 'محمد مصطفى',
        ownerPhoneNumber: '01265789897',
        responsibleName: 'مرسي محمود',
        responsiblePhone: '0152089252'),
    RealEstateData(
        id: 1,
        apartementStatusId: 1,
        apartementPostionInFloorId: 2,
        apartementPostionInBuildingId: 3,
        apartementLink: 'www.spain-city.com/id?23150',
        isApartementHasEnoughData: false,
        apartementName: '150'),
    RealEstateData(
        id: 2,
        apartementStatusId: 3,
        apartementPostionInFloorId: 1,
        apartementPostionInBuildingId: 4,
        apartementLink: 'www.spain-city.com/id?14125',
        isApartementHasEnoughData: false,
        apartementName: '125'),
    RealEstateData(
        id: 3,
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
        id: 4,
        apartementStatusId: 3,
        apartementPostionInFloorId: 4,
        apartementPostionInBuildingId: 1,
        apartementLink: 'www.spain-city.com/id?41450',
        isApartementHasEnoughData: true,
        apartementName: '450',
        ownerName: 'محمد مصطفى',
        ownerPhoneNumber: '01265789897',
        responsibleName: 'مرسي محمود',
        responsiblePhone: '0152089252'),
  ];
  RealEstateDataSource.empty(this.context) {
    realEstate = [];
  }

  RealEstateDataSource(this.context,
      [sortedByCalories = false,
      this.hasRowTaps = false,
      this.hasRowHeightOverrides = false,
      this.hasZebraStripes = false]) {
    realEstate = _realEstates;
    if (sortedByCalories) {
      sort((d) => d.ownerName, true);
    }
  }

  final BuildContext context;
  late List<RealEstateData> realEstate;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(
      Comparable<T> Function(RealEstateData d) getField, bool ascending) {
    realEstate.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  @override
  DataRow getRow(int index, [Color? color]) {
    assert(index >= 0);
    if (index >= realEstate.length) throw 'index > _desserts.length';
    final apartement = realEstate[index];
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
    /* *!SECTION */
    return DataRow2.byIndex(
      index: index,
      color: color != null
          ? MaterialStateProperty.all(color)
          : (hasZebraStripes && index.isEven
              ? MaterialStateProperty.all(Theme.of(context).highlightColor)
              : null),
      onTap: hasRowTaps
          ? () => Get.showSnackbar(
              GetSnackBar(message: 'Tapped on row ${apartement.ownerName}'))
          : null,
      onDoubleTap: hasRowTaps
          ? () => Get.showSnackbar(GetSnackBar(
              message: 'Double Tapped on row ${apartement.ownerName}'))
          : null,
      onLongPress: hasRowTaps
          ? () => Get.showSnackbar(GetSnackBar(
              message: 'Long pressed on row ${apartement.ownerName}'))
          : null,
      onSecondaryTap: hasRowTaps
          ? () => Get.showSnackbar(GetSnackBar(
              message: 'Right clicked on row ${apartement.ownerName}'))
          : null,
      onSecondaryTapDown: hasRowTaps
          ? (d) => Get.showSnackbar(GetSnackBar(
              message: 'Right button down on row ${apartement.ownerName}'))
          : null,
      cells: [
        DataCell(Text(apartement.id.toString())),
        DataCell(
          Container(
            width: 75,
            height: 25,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: apartement.isApartementHasEnoughData
                    ? const Color.fromRGBO(198, 238, 204, 1)
                    : const Color.fromRGBO(253, 200, 208, 1),
                border: Border.all(
                    color: apartement.isApartementHasEnoughData
                        ? const Color.fromRGBO(58, 107, 68, 1)
                        : const Color.fromRGBO(145, 58, 67, 1))),
            child: Center(
                child: Text(
              apartement.isApartementHasEnoughData ? 'مسجلة' : 'غير مسجلة',
            )),
          ),
        ),
        DataCell(Text(apartement.ownerName)),
        DataCell(Text(apartement.responsibleName)),
        DataCell(Text(apartement.responsiblePhone)),
        DataCell(Text(realEstates
            .firstWhere((element) =>
                element.id == apartement.apartementPostionInBuildingId)
            .buildingName)),
        DataCell(Text(realEstateFloors
            .firstWhere((element) =>
                element.id == apartement.apartementPostionInFloorId)
            .floorName)),
        DataCell(Text(apartement.apartementName)),
      ],
    );
  }

  @override
  int get rowCount => realEstate.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
