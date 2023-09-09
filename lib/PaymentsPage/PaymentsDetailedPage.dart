import 'dart:convert';

import 'package:aspania_city_group/Common_Used/navigation.dart';
import 'package:aspania_city_group/Common_Used/sql_functions.dart';
import 'package:aspania_city_group/Common_Used/text_tile.dart';
import 'package:aspania_city_group/DataTableForApartements/ApartementSelector.dart';
import 'package:aspania_city_group/PaymentsPage/AddPaymentDialog.dart';
import 'package:aspania_city_group/class/payment.dart';
import 'package:aspania_city_group/class/realestate.dart';
import 'package:davi/davi.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:excel/excel.dart' as xlsx;
import 'package:intl/date_symbol_data_local.dart';

import '../Common_Used/button_tile.dart';
import '../Dashboard/menu_card_button.dart';
import '../class/buidlingproperties.dart';
import 'package:intl/intl.dart' as intl;

class PaymentsPageOfSpecifiedApartement extends StatefulWidget {
  const PaymentsPageOfSpecifiedApartement({super.key});

  @override
  State<PaymentsPageOfSpecifiedApartement> createState() =>
      _PaymentsPageOfSpecifiedApartementState();
}

class _PaymentsPageOfSpecifiedApartementState
    extends State<PaymentsPageOfSpecifiedApartement> {
  /* *SECTION - Filters Variables */
  Rx<DateTime> fromDatePaymentFilter =
      DateTime.now().subtract(const Duration(days: 32)).obs;
  Rx<DateTime> toDatePaymentFilter = DateTime.now().obs;
  /* *SECTION - Required to be a Pararmeter */
  Rx<RealEstateData> selectedRealEstateData = RealEstateData(
          id: -1,
          apartementStatusId: -1,
          apartementPostionInFloorId: -1,
          apartementPostionInBuildingId: -1,
          apartementLink: '',
          isApartementHasEnoughData: true,
          apartementName: '',
          ownerName: '',
          ownerPhoneNumber: '',
          responsibleName: '',
          responsiblePhone: '')
      .obs;

  /* *!SECTION */
  /* *!SECTION */

  /* *SECTION - TextControllers */
  late TextEditingController selectedApartementTextController;
  late TextEditingController fromDateOfPaymentsFilterTextController;
  late TextEditingController toDateOfPaymentsFilterTextController;
  /* *!SECTION */
  /* *SECTION - Table Data */
  DaviModel<PaymentData>? _model;
  List<PaymentData> _payments = [];
  bool _loading = false;
  bool reahedTheEndOfTable = false;
  int lastindexOfPaymentsLoaded = 0;

  /* *!SECTION */
  /* *SECTION - Loading With Async */
  DaviModel<PaymentData> returnTheTableUX() {
    return DaviModel(
        rows: _payments.getRange(0, lastindexOfPaymentsLoaded).toList(),
        onSort: (sortedColumns) {},
        columns: [
          DaviColumn(
              width: 500,
              headerAlignment: Alignment.center,
              name: 'ملاحظات',
              stringValue: (row) => row.paymentNote,
              sortable: false),
          DaviColumn(
              headerAlignment: Alignment.center,
              width: 150,
              name: 'المبلغ',
              doubleValue: (row) => row.paymentAmount,
              sortable: true),
          DaviColumn(
              headerAlignment: Alignment.center,
              width: 200,
              cellBuilder: (context, row) {
                return Text(
                    '${row.data.paymentDate.year} / ${row.data.paymentDate.month} / ${row.data.paymentDate.day}');
              },
              name: 'تاريخ السداد',
              intValue: (row) => row.paymentDate.millisecondsSinceEpoch,
              sortable: true),
        ]);
  }

  void _onLastRowWidget(bool visible) {
    if (visible && !_loading) {
      setState(() {
        _loading = true;
      });
      if (_payments.length > lastindexOfPaymentsLoaded + 5) {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _loading = false;
            List<PaymentData> newValues = _payments
                .getRange(
                    lastindexOfPaymentsLoaded, lastindexOfPaymentsLoaded + 5)
                .toList();
            lastindexOfPaymentsLoaded += 5;
            _model!.addRows(newValues);
          });
        });
      } else if ((_payments.length - lastindexOfPaymentsLoaded) <= 4) {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _loading = false;
            List<PaymentData> newValues = _payments
                .getRange(
                    lastindexOfPaymentsLoaded,
                    lastindexOfPaymentsLoaded +
                        (_payments.length - lastindexOfPaymentsLoaded))
                .toList();
            lastindexOfPaymentsLoaded = _payments.length;
            _model!.addRows(newValues);
            reahedTheEndOfTable = true;
          });
        });
      }
    }
  }

  /* *!SECTION */
  /* *SECTION - Exporting To Excel */
  void exportXLSXOfData() {
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
    var aprtartementExcel =
        xlsx.Excel.createExcel(); // automatically creates 1 empty sheet: Sheet1
    /* *SECTION - Title */
    xlsx.Sheet aprtartementsExcelSheet = aprtartementExcel[
        'فواتير سداد المالك (${selectedRealEstateData.value.ownerName})'];
    xlsx.CellStyle headerStyle = xlsx.CellStyle(
        bottomBorder: xlsx.Border(borderStyle: xlsx.BorderStyle.Thick),
        fontSize: 14,
        fontFamily: xlsx.getFontFamily(xlsx.FontFamily.Al_Nile));
    xlsx.CellStyle apartementDetailsStyle = xlsx.CellStyle(
        bottomBorder: xlsx.Border(borderStyle: xlsx.BorderStyle.Dotted),
        fontSize: 15,
        fontFamily: xlsx.getFontFamily(xlsx.FontFamily.Al_Nile));
    /* *!SECTION */
    /* *SECTION - Initiate Column Names */
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('O7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('O7')).value =
        'تاريخ السداد';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('N7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('N7')).value =
        'المبلغ';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('M7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('M7')).value =
        'ملاحظات';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('H7')).cellStyle =
        apartementDetailsStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('H7')).value =
        ' : اسم المالك ${selectedRealEstateData.value.ownerName}';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('H9')).cellStyle =
        apartementDetailsStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('H9')).value =
        ' : رقم تليفون المالك ${selectedRealEstateData.value.ownerPhoneNumber}';
    aprtartementsExcelSheet
        .cell(xlsx.CellIndex.indexByString('H11'))
        .cellStyle = apartementDetailsStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('H11')).value =
        ' : اسم المسئول ${selectedRealEstateData.value.responsibleName}';
    aprtartementsExcelSheet
        .cell(xlsx.CellIndex.indexByString('H13'))
        .cellStyle = apartementDetailsStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('H13')).value =
        ' : رقم تليفون المسئول ${selectedRealEstateData.value.responsiblePhone}';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('E7')).cellStyle =
        apartementDetailsStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('E7')).value =
        ' : العمارة ${buildings.firstWhere((element) => element.id == selectedRealEstateData.value.apartementPostionInBuildingId).buildingName}';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('E9')).cellStyle =
        apartementDetailsStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('E9')).value =
        "${realEstateFloors.firstWhere((element) => element.id == selectedRealEstateData.value.apartementPostionInFloorId).floorName} الدور : ";
    aprtartementsExcelSheet
        .cell(xlsx.CellIndex.indexByString('E11'))
        .cellStyle = apartementDetailsStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('H11')).value =
        ' : رقم الوحدة ${selectedRealEstateData.value.apartementName}';
    aprtartementsExcelSheet
        .cell(xlsx.CellIndex.indexByString('H13'))
        .cellStyle = apartementDetailsStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('H13')).value =
        ' : حالة الوحدة ${apartementState.firstWhere((element) => element.id == selectedRealEstateData.value.apartementStatusId).state}';
/* *!SECTION */
/* *SECTION - Set Payment Values */
    for (var i = 0; i < _payments.length; i++) {
      PaymentData payment = _payments[i];
      // تاريخ التسديد
      aprtartementsExcelSheet
              .cell(xlsx.CellIndex.indexByString('O${i + 8}'))
              .value =
          '${payment.paymentDate.year} / ${payment.paymentDate.month} / ${payment.paymentDate.day}';
      // المبلغ
      aprtartementsExcelSheet
          .cell(xlsx.CellIndex.indexByString('N${i + 8}'))
          .value = '${payment.paymentAmount}';
      // الملاحظة
      aprtartementsExcelSheet
          .cell(xlsx.CellIndex.indexByString('M${i + 8}'))
          .value = payment.paymentNote;
    }
    aprtartementExcel.save(
        fileName:
            'فواتير سداد المالك (${selectedRealEstateData.value.ownerName}).xlsx');
/* *!SECTION */
  }

  /* *!SECTION */
/* *SECTION - SQL Backend */
  /* *SECTION - get Payment Payments Of Selected Owner */
  Future<void> getPaymentsOfOwner() async {
    var getDataResponse = await SQLFunctions.sendQuery(
        query:
            'SELECT * FROM SpainCity.PaymentsOfRealEsate where realEstateId = ${selectedRealEstateData.value.id};');
    List<PaymentData> payments = [];

    if (getDataResponse.statusCode == 200) {
      var data = json.decode(getDataResponse.body);
      for (var element in data) {
        DateTime date = intl.DateFormat("E, d MMM yyyy hh:mm:ss")
            .parse(element[5].toString().replaceAll(' GMT', ''));
        payments.add(PaymentData(
            id: element[0],
            apartementId: element[1],
            paymentDate: date,
            paymentAmount: element[6],
            paymentNote: element[7],
            ownerName: element[2],
            apartementName: element[4],
            ownerPhoneNumber: element[3]));
      }
    } else {
      payments.add(PaymentData(
          id: getDataResponse.statusCode,
          apartementId: getDataResponse.statusCode,
          paymentDate: DateTime.now(),
          paymentAmount: double.parse(getDataResponse.body),
          paymentNote: getDataResponse.body));
    }
    if (_model != null && payments.isNotEmpty) {
      _payments = payments;
      _model!.notifyUpdate();
    } else if (payments.isEmpty) {
      _payments = payments;
    }
  }

/* *SECTION - Delete Payment */
  Future<int> deletePaymentData(int id) async {
    var deleteResponse = await SQLFunctions.sendQuery(
        query:
            "DELETE FROM `SpainCity`.`PaymentsOfRealEsate` WHERE (`id` = $id);");

    return deleteResponse.statusCode;
  }

/* *!SECTION */
/* *!SECTION */

/* *!SECTION */
  @override
  void initState() {
    initializeDateFormatting();
    try {
      selectedRealEstateData(
          NavigationProperties.selectedTabNeededParamters[0]);
    } catch (e) {
      selectedRealEstateData = selectedRealEstateData;
    }
    fromDateOfPaymentsFilterTextController = TextEditingController(
        text: intl.DateFormat.yMMMMEEEEd('ar')
            .format(fromDatePaymentFilter.value));
    toDateOfPaymentsFilterTextController = TextEditingController(
        text:
            intl.DateFormat.yMMMMEEEEd('ar').format(toDatePaymentFilter.value));
    selectedApartementTextController =
        TextEditingController(text: selectedRealEstateData.value.ownerName);
    _model = returnTheTableUX();
    getPaymentsOfOwner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    final List<Building> buildings = [
      Building(buildingName: ' رقم ۱', id: 1),
      Building(buildingName: ' رقم ۲', id: 2),
      Building(buildingName: ' رقم ۳', id: 3),
      Building(buildingName: ' رقم ٤', id: 4),
      Building(buildingName: ' رقم ٥', id: 5),
      Building(buildingName: ' رقم ٦', id: 6),
      Building(buildingName: ' رقم ۷', id: 7),
    ];
    final List<Floor> realEstateFloors = [
      Floor(floorName: 'الارضي المنخفض', id: 1),
      Floor(floorName: 'الارضي مرتفع', id: 2),
      Floor(floorName: 'الاول', id: 3),
      Floor(floorName: 'الثاني', id: 4),
      Floor(floorName: 'الثالث', id: 5),
      Floor(floorName: 'الرابع', id: 6),
    ];
    RxBool onMoreButtonHover = false.obs;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
        color: Colors.white,
        child: ListView(shrinkWrap: true, children: [
          /* *SECTION - Top Part */
          Container(
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.only(top: 10, right: 0),
            child: Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* *SECTION - Routes */
                Obx(
                  () => RoutesBuilder(routeLabels: [
                    'الوحدات',
                    'سداد المالك (${selectedRealEstateData.value.ownerName})'
                  ], routeScreen: [
                    NavigationProperties.realEstateSummaryPageRoute,
                    NavigationProperties.nonePageRoute
                  ]),
                ),
                /* *!SECTION */
                /* *SECTION - Action Button */
                Row(
                  children: [
                    Obx(
                      () => GestureDetector(
                          onTap: () {
                            showMenu(
                                context: context,
                                color: Colors.white,
                                position:
                                    const RelativeRect.fromLTRB(50, 125, 50, 0),
                                items: [
                                  PopupMenuItem<int>(
                                    value: 0,
                                    child: ButtonTile(
                                      buttonText: 'تسجيل فاتورة',
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return FluidDialog(
                                                rootPage: FluidDialogPage(
                                              builder: (context) {
                                                return AddPaymentDialog(
                                                  state: 'Add',
                                                  selectedOwner:
                                                      selectedRealEstateData
                                                          .value,
                                                );
                                              },
                                            ));
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  PopupMenuItem<int>(
                                      value: 1,
                                      child: ButtonTile(
                                        buttonText: 'اصدار تقرير',
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          exportXLSXOfData();
                                        },
                                      )),
                                ]);
                          },
                          child: MouseRegion(
                            onEnter: (details) {
                              onMoreButtonHover(true);
                            },
                            onExit: (details) {
                              onMoreButtonHover(false);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey[500] ?? Colors.white),
                                  borderRadius: BorderRadius.circular(60),
                                  color: onMoreButtonHover.value
                                      ? Colors.grey[500]
                                      : Colors.transparent),
                              child: const Icon(
                                Icons.more_horiz_outlined,
                                size: 35,
                                color: Colors.black,
                              ),
                            ),
                          )),
                    ),
                  ],
                )
                /* *!SECTION */
              ],
            ),
          ),
          /* *!SECTION */
          /* *SECTION - Real Estate Data && Filters*/
          Container(
            margin: const EdgeInsets.only(top: 10, right: 20),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextTile(
                            width: 435,
                            textController: selectedApartementTextController,
                            title: "مالك الوحدة",
                            hintText: "اختر المالك الوحدة",
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: ((context) => FluidDialog(
                                        rootPage: FluidDialogPage(
                                          builder: (context) {
                                            return const ApartementSelector();
                                          },
                                        ),
                                      ))).then((value) async {
                                selectedApartementTextController.text =
                                    value == null
                                        ? selectedRealEstateData.value.ownerName
                                        : value.ownerName;
                                selectedRealEstateData(value);
                                _model!.removeRows();
                                await getPaymentsOfOwner();
                                _model!.addRow(_payments.first);
                              });
                            },
                            icon: Icons.person_search_outlined),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            TextTile(
                                width: 250,
                                textController:
                                    fromDateOfPaymentsFilterTextController,
                                title: "عرض السدادات من تاريخ",
                                hintText: "اختر التاريخ",
                                onTap: () {
                                  showDatePicker(
                                          textDirection: TextDirection.rtl,
                                          cancelText: "الغاء",
                                          confirmText: "تأكيد",
                                          context: context,
                                          initialDate:
                                              fromDatePaymentFilter.value,
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime.now())
                                      .then((value) {
                                    if (!value!
                                        .isAfter(toDatePaymentFilter.value)) {
                                      fromDatePaymentFilter(value);
                                      _model!.removeRows();

                                      for (var element in _payments) {
                                        if (element.paymentDate.isAfter(
                                                fromDatePaymentFilter.value
                                                    .subtract(const Duration(
                                                        days: 1))) &&
                                            element.paymentDate.isBefore(
                                                toDatePaymentFilter.value.add(
                                                    const Duration(days: 1)))) {
                                          _model!.addRow(element);
                                          _model!.notifyUpdate();
                                        }
                                      }
                                      fromDateOfPaymentsFilterTextController
                                          .text = intl.DateFormat.yMMMMEEEEd(
                                              'ar')
                                          .format(fromDatePaymentFilter.value);
                                    } else {
                                      Get.showSnackbar(const GetSnackBar(
                                        animationDuration: Duration(seconds: 1),
                                        duration: Duration(seconds: 2),
                                        message:
                                            'لا يمكن ادخال تاريخ بعد خانة (الى تاريخ)',
                                      ));
                                    }
                                  });
                                },
                                icon: Icons.calendar_today_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '~',
                              style: GoogleFonts.notoSansArabic(fontSize: 25),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            TextTile(
                                width: 250,
                                textController:
                                    toDateOfPaymentsFilterTextController,
                                title: "عرض السدادات الى تاريخ",
                                hintText: "اختر التاريخ",
                                onTap: () {
                                  showDatePicker(
                                          textDirection: TextDirection.rtl,
                                          cancelText: "الغاء",
                                          confirmText: "تأكيد",
                                          context: context,
                                          initialDate:
                                              toDatePaymentFilter.value,
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime.now())
                                      .then((value) {
                                    if (!value!.isBefore(
                                        fromDatePaymentFilter.value)) {
                                      toDatePaymentFilter(value);
                                      _model!.removeRows();

                                      for (var element in _payments) {
                                        if (element.paymentDate.isAfter(
                                                fromDatePaymentFilter.value
                                                    .subtract(const Duration(
                                                        days: 1))) &&
                                            element.paymentDate.isBefore(
                                                toDatePaymentFilter.value.add(
                                                    const Duration(days: 1)))) {
                                          _model!.addRow(element);
                                          _model!.notifyUpdate();
                                        }
                                      }
                                      toDateOfPaymentsFilterTextController
                                          .text = intl.DateFormat.yMMMMEEEEd(
                                              'ar')
                                          .format(toDatePaymentFilter.value);
                                    } else {
                                      Get.showSnackbar(const GetSnackBar(
                                        animationDuration: Duration(seconds: 1),
                                        duration: Duration(seconds: 2),
                                        message:
                                            'لا يمكن ادخال تاريخ قبل خانة (من تاريخ)',
                                      ));
                                    }
                                  });
                                },
                                icon: Icons.calendar_today_outlined),
                          ],
                        )
                      ],
                    ),
                    /* *SECTION - Data */
                    Obx(
                      () => SizedBox(
                        width: 500,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textDirection: TextDirection.rtl,
                          children: [
                            /* *SECTION - Apartement Data */
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'تفاصيل الشقة',
                                  style: GoogleFonts.notoSansArabic(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  selectedRealEstateData.value.id == -1
                                      ? ''
                                      : "عمارة : ${buildings.firstWhere((element) => element.id == selectedRealEstateData.value.apartementPostionInBuildingId).buildingName}",
                                  style: GoogleFonts.notoSansArabic(
                                    fontSize: 18,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  selectedRealEstateData.value.id == -1
                                      ? ''
                                      : "الدور : ${realEstateFloors.firstWhere((element) => element.id == selectedRealEstateData.value.apartementPostionInFloorId).floorName}",
                                  style: GoogleFonts.notoSansArabic(
                                      color: Colors.grey[500], fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  selectedRealEstateData.value.id == -1
                                      ? ''
                                      : "رقم الوحدة : ${selectedRealEstateData.value.apartementName}",
                                  style: GoogleFonts.notoSansArabic(
                                      color: Colors.grey[500], fontSize: 18),
                                ),
                              ],
                            ),
                            /* *!SECTION */
                            /* *SECTION - Owner Data */
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'تفاصيل المالك',
                                  style: GoogleFonts.notoSansArabic(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  selectedRealEstateData.value.id == -1
                                      ? ''
                                      : 'رقم المالك : ${selectedRealEstateData.value.ownerPhoneNumber}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.notoSansArabic(
                                    fontSize: 18,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  selectedRealEstateData.value.id == -1
                                      ? ''
                                      : 'اسم المسئول : ${selectedRealEstateData.value.responsibleName}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.notoSansArabic(
                                      color: Colors.grey[500], fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  selectedRealEstateData.value.id == -1
                                      ? ''
                                      : 'رقم المسئول : ${selectedRealEstateData.value.responsiblePhone}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.notoSansArabic(
                                      color: Colors.grey[500], fontSize: 18),
                                ),
                              ],
                            )
                            /* *!SECTION */
                          ],
                        ),
                      ),
                    )
                    /* *!SECTION */
                  ],
                ),
              ],
            ),
          ),
          /* *!SECTION */
          const SizedBox(
            height: 20,
          ),
          /* *SECTION - Payments */
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
              height: height / 4,
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Davi<PaymentData>(
                _model,
                onLastRowWidget: _onLastRowWidget,
                tapToSortEnabled: true,
                lastRowWidget: !reahedTheEndOfTable
                    ? const Center(
                        child: SizedBox(
                          height: 100,
                          width: 50,
                          child: CircularProgressIndicator(
                              color: Colors.black, strokeWidth: 1),
                        ),
                      )
                    : _payments.isEmpty
                        ? Center(
                            child: Text(
                              'لا يوجد بيانات مسجلة',
                              style: GoogleFonts.notoSansArabic(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return FluidDialog(rootPage: FluidDialogPage(
                                    builder: (context) {
                                      return AddPaymentDialog(
                                        state: 'Add',
                                        selectedOwner:
                                            selectedRealEstateData.value,
                                      );
                                    },
                                  ));
                                },
                              );
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                textDirection: TextDirection.rtl,
                                children: [
                                  const Icon(
                                    Icons.add,
                                    size: 25,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'اضف سداد جديد',
                                    style: GoogleFonts.notoSansArabic(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                visibleRowsCount: int.parse((height / 50).toStringAsFixed(0)),
                columnWidthBehavior: ColumnWidthBehavior.scrollable,
                onRowTap: (data) {},
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
                            onTap: () async {
                              Navigator.of(context).pop();
                              await deletePaymentData(data.id);
                              _model!.removeRow(data);
                              _model!.notifyUpdate();
                              Get.showSnackbar(const GetSnackBar(
                                animationDuration: Duration(seconds: 1),
                                duration: Duration(seconds: 2),
                                message: 'تم الحذف بنجاح',
                              ));
                            },
                            icon: Icons.delete_forever_outlined,
                            title: 'حذف الفاتورة',
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
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return FluidDialog(rootPage: FluidDialogPage(
                                    builder: (context) {
                                      return AddPaymentDialog(
                                        state: 'Edit',
                                        paymentData: data,
                                        selectedOwner:
                                            selectedRealEstateData.value,
                                      );
                                    },
                                  ));
                                },
                              );
                            },
                            icon: Icons.miscellaneous_services_outlined,
                            title: 'تعديل الفاتورة',
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

          /* *!SECTION */
        ]),
      ),
    );
  }
}
