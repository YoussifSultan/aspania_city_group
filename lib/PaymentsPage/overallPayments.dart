import 'dart:convert';
import 'dart:typed_data';

import 'package:aspania_city_group/Common_Used/button_tile.dart';
import 'package:aspania_city_group/Common_Used/dialog_tile.dart';
import 'package:aspania_city_group/Common_Used/global_class.dart';
import 'package:aspania_city_group/Common_Used/navigation.dart';
import 'package:aspania_city_group/Common_Used/show_data_tile.dart';
import 'package:aspania_city_group/Common_Used/sql_functions.dart';
import 'package:aspania_city_group/Common_Used/useful_functions.dart';
import 'package:aspania_city_group/PaymentsPage/AddPaymentDialog.dart';
import 'package:aspania_city_group/class/buidlingproperties.dart';
import 'package:aspania_city_group/class/payment.dart';
import 'package:aspania_city_group/class/realestate.dart';
import 'package:excel/excel.dart' as xlsx;
import 'package:davi/davi.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:printing/printing.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:number_to_word_arabic/number_to_word_arabic.dart';
import '../Common_Used/text_tile.dart';
import '../Dashboard/menu_card_button.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class OverallPaymentsThroughPeriod extends StatefulWidget {
  const OverallPaymentsThroughPeriod(
      {super.key,
      this.status = 'PaymentsDuringMonth',
      required this.queryStatement});
  final String status;
  final String queryStatement;

  @override
  State<OverallPaymentsThroughPeriod> createState() =>
      _OverallPaymentsThroughPeriodState();
}

class _OverallPaymentsThroughPeriodState
    extends State<OverallPaymentsThroughPeriod> {
  /* *SECTION - Table Data */
  DaviModel<PaymentData>? _model;
  List<PaymentData> _payments = [];
  bool _loading = false;
  bool reahedTheEndOfTable = false;
  int lastindexOfPaymentsLoaded = 0;
  RxInt selectedPaymentForDetails = (-1).obs;
  RxBool updateMobileListWhenDataIsPopulated = false.obs;
  /* *!SECTION */
  /* *SECTION - TextControllers */
  late TextEditingController fromDateOfPaymentsFilterTextController;
  late TextEditingController toDateOfPaymentsFilterTextController;
  /* *!SECTION */
  /* *SECTION - Dates Filter */
  Rx<DateTime> fromDatePaymentFilter =
      DateTime.now().subtract(const Duration(days: 32)).obs;
  Rx<DateTime> toDatePaymentFilter = DateTime.now().obs;
  /* *!SECTION */
  /* *SECTION - Loading With Async */
  DaviModel<PaymentData> returnTheTableUX() {
    return DaviModel(
        // rows: _payments.getRange(0, lastindexOfPaymentsLoaded).toList(),
        onSort: (sortedColumns) {},
        columns: [
          DaviColumn(
              width: 200,
              headerAlignment: Alignment.center,
              name: 'ملاحظات',
              stringValue: (row) => row.paymentNote,
              sortable: false),
          DaviColumn(
              headerAlignment: Alignment.center,
              width: 100,
              name: 'المبلغ',
              doubleValue: (row) => row.paymentAmount,
              sortable: true),
          DaviColumn(
              headerAlignment: Alignment.center,
              width: 300,
              cellBuilder: (context, row) {
                return Text(intl.DateFormat.yMMMMEEEEd('ar')
                    .format(row.data.paymentDate));
              },
              name: 'تاريخ السداد',
              intValue: (row) => row.paymentDate.millisecondsSinceEpoch,
              sortable: true),
          DaviColumn(
              headerAlignment: Alignment.center,
              width: 150,
              name: 'العمارة',
              cellBuilder: (context, row) {
                final List<Building> buildings = [
                  Building(buildingName: 'عمارة رقم ۱', id: 1),
                  Building(buildingName: 'عمارة رقم ۲', id: 2),
                  Building(buildingName: 'عمارة رقم ۳', id: 3),
                  Building(buildingName: 'عمارة رقم ٤', id: 4),
                  Building(buildingName: 'عمارة رقم ٥', id: 5),
                  Building(buildingName: 'عمارة رقم ٦', id: 6),
                  Building(buildingName: 'عمارة رقم ۷', id: 7),
                ];

                int buildingNo = row.data.apartementPostionInBuildingId;

                return Text(buildings
                    .firstWhere((element) => element.id == buildingNo)
                    .buildingName);
              },
              intValue: (row) {
                int buildingNo = row.apartementPostionInBuildingId;

                return buildingNo;
              },
              sortable: true),
          DaviColumn(
              headerAlignment: Alignment.center,
              width: 150,
              name: 'رقم تليفون المالك',
              stringValue: (row) => row.ownerPhoneNumber,
              sortable: true),
          DaviColumn(
              headerAlignment: Alignment.center,
              width: 200,
              name: 'اسم المالك',
              stringValue: (row) => row.ownerName,
              sortable: true),
        ]);
  }

  /* *!SECTION */

/* *SECTION - Export Excel */
  Future<void> exportXLSXOfData() async {
    var aprtartementExcel =
        xlsx.Excel.createExcel(); // automatically creates 1 empty sheet: Sheet1
    xlsx.Sheet aprtartementsExcelSheet =
        aprtartementExcel['فواتير السداد خلال هذا الشهر'];
    xlsx.CellStyle headerStyle = xlsx.CellStyle(
        bottomBorder: xlsx.Border(borderStyle: xlsx.BorderStyle.Thick),
        fontSize: 14,
        fontFamily: xlsx.getFontFamily(xlsx.FontFamily.Al_Nile));
    /* *SECTION - Initiate Column Names */
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('O7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('O7')).value =
        'اسم المالك';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('N7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('N7')).value =
        'رقم تليفون المالك';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('M7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('M7')).value =
        'رقم الوحدة';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('L7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('L7')).value =
        'العمارة';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('K7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('K7')).value =
        'تاريخ السداد';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('J7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('J7')).value =
        'قيمة المسدد';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('I7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('I7')).value =
        'ملاحظات';

/* *!SECTION */
/* *SECTION - Set Values */

    for (var i = 0; i < _model!.rowsLength; i++) {
      PaymentData payment = _model!.rowAt(i);
      //اسم المالك
      aprtartementsExcelSheet
          .cell(xlsx.CellIndex.indexByString('O${i + 8}'))
          .value = payment.ownerName;
      // رقم تليفون المالك
      aprtartementsExcelSheet
          .cell(xlsx.CellIndex.indexByString('N${i + 8}'))
          .value = payment.ownerPhoneNumber;
      //  رقم الوحدة
      aprtartementsExcelSheet
          .cell(xlsx.CellIndex.indexByString('M${i + 8}'))
          .value = payment.apartementId;

      //  العمارة
      final List<Building> buildings = [
        Building(buildingName: 'عمارة رقم ۱', id: 1),
        Building(buildingName: 'عمارة رقم ۲', id: 2),
        Building(buildingName: 'عمارة رقم ۳', id: 3),
        Building(buildingName: 'عمارة رقم ٤', id: 4),
        Building(buildingName: 'عمارة رقم ٥', id: 5),
        Building(buildingName: 'عمارة رقم ٦', id: 6),
        Building(buildingName: 'عمارة رقم ۷', id: 7),
      ];

      int buildingNo = payment.apartementPostionInBuildingId;
      aprtartementsExcelSheet
              .cell(xlsx.CellIndex.indexByString('L${i + 8}'))
              .value =
          buildings
              .firstWhere((element) => element.id == buildingNo)
              .buildingName;
      // تاريخ السداد
      aprtartementsExcelSheet
              .cell(xlsx.CellIndex.indexByString('K${i + 8}'))
              .value =
          '${payment.paymentDate.year} / ${payment.paymentDate.month} / ${payment.paymentDate.day}';
      // مبلغ الفاتورة
      aprtartementsExcelSheet
          .cell(xlsx.CellIndex.indexByString('J${i + 8}'))
          .value = payment.paymentAmount;
      // ملاحظات
      aprtartementsExcelSheet
          .cell(xlsx.CellIndex.indexByString('I${i + 8}'))
          .value = payment.paymentNote;
    }
    aprtartementExcel.save(fileName: 'فواتير السداد .xlsx');
/* *!SECTION */
  }

/* *!SECTION */
/* *SECTION - SQL Backend */
/* *SECTION - get Payment During Dates */
  Future<void> getPaymentsDuringDates() async {
    String fromDatePaymentFilterString =
        "${fromDatePaymentFilter.value.year.toString()}-${fromDatePaymentFilter.value.month.toString().padLeft(2, '0')}-${fromDatePaymentFilter.value.day.toString().padLeft(2, '0')} ";
    String toDatePaymentFilterString =
        "${toDatePaymentFilter.value.year.toString()}-${toDatePaymentFilter.value.month.toString().padLeft(2, '0')}-${toDatePaymentFilter.value.day.toString().padLeft(2, '0')} ";
    var getDataResponse = await SQLFunctions.sendQuery(
        query:
            'SELECT      payments.Id, 	realestate.idRealEstates,     realestate.apartementPostionInBuildingId,     realestate.ownerName,     realestate.apartementName,     realestate.apartementPostionInFloorId,     realestate.ownerPhoneNumber,     payments.paymentAmount,     payments.paymentDate,     payments.paymentNote FROM     SpainCity.RealEstates realestate         JOIN     SpainCity.PaymentsOfRealEsate payments ON realestate.idRealEstates = payments.realEstateId         AND payments.paymentDate BETWEEN \'$fromDatePaymentFilterString\' and \'$toDatePaymentFilterString\' ORDER BY realestate.apartementPostionInBuildingId');
    List<PaymentData> payments = [];

    if (getDataResponse.statusCode == 200) {
      var data = json.decode(getDataResponse.body);
      for (var element in data) {
        DateTime date = intl.DateFormat("E, d MMM yyyy hh:mm:ss")
            .parse(element[8].toString().replaceAll(' GMT', ''));

        payments.add(PaymentData(
            id: element[0],
            apartementId: element[1],
            apartementPostionInBuildingId: element[2],
            paymentDate: date,
            paymentAmount: element[7],
            paymentNote: element[9],
            ownerName: element[3],
            apartementName: element[4].toString(),
            ownerPhoneNumber: element[6].toString()));
      }
    } else {
      payments.add(PaymentData(
          apartementPostionInBuildingId: getDataResponse.statusCode,
          id: getDataResponse.statusCode,
          apartementId: getDataResponse.statusCode,
          paymentDate: DateTime.now(),
          paymentAmount: double.parse(getDataResponse.body),
          paymentNote: getDataResponse.body));
    }
    if (_model != null && payments.isNotEmpty) {
      _model!.addRows(payments);
      _payments.addAll(payments);
      _model!.notifyUpdate();
      updateMobileListWhenDataIsPopulated(true);
    }
  }

/* *!SECTION */
/* *SECTION - get Payment With Specific Query */
  Future<void> getPaymentsWithSpecificQuery(String query) async {
    var getDataResponse = await SQLFunctions.sendQuery(query: query);
    List<PaymentData> payments = [];

    if (getDataResponse.statusCode == 200) {
      var data = json.decode(getDataResponse.body);
      for (var element in data) {
        DateTime date = intl.DateFormat("E, d MMM yyyy hh:mm:ss")
            .parse(element[8].toString().replaceAll(' GMT', ''));

        payments.add(PaymentData(
            id: element[0],
            apartementId: element[1],
            apartementPostionInBuildingId: element[2],
            paymentDate: date,
            paymentAmount: element[7],
            paymentNote: element[9],
            ownerName: element[3],
            apartementName: element[4].toString(),
            ownerPhoneNumber: element[6].toString()));
      }
    } else {
      payments.add(PaymentData(
          apartementPostionInBuildingId: getDataResponse.statusCode,
          id: getDataResponse.statusCode,
          apartementId: getDataResponse.statusCode,
          paymentDate: DateTime.now(),
          paymentAmount: double.parse(getDataResponse.body),
          paymentNote: getDataResponse.body));
    }
    if (_model != null && payments.isNotEmpty) {
      _model!.addRows(payments);
      _payments.addAll(payments);
      _model!.notifyUpdate();
      updateMobileListWhenDataIsPopulated(true);
    }
  }

/* *!SECTION */
/* *SECTION - Delete Payment */
  Future<int> deletePaymentData(int id) async {
    var deleteResponse = await SQLFunctions.sendQuery(
        query:
            "DELETE FROM `SpainCity`.`PaymentsOfRealEsate` WHERE (`id` = $id);");

    return deleteResponse.statusCode;
  }

/* *!SECTION */
/* *!SECTION */
  /* *SECTION - Print Receit Of Payment */
  /// This method takes a page format and generates the Pdf file data
  Future<Uint8List> createPDFReceit(
      PdfPageFormat format, PaymentData payment) async {
    // Create the Pdf document
    final pw.Document doc = pw.Document();
    final arabicLabel = await PdfGoogleFonts.notoSansArabicLight();
    final arabicData = await PdfGoogleFonts.notoSansArabicBold();
    final arabicHeader = await PdfGoogleFonts.notoSansArabicExtraBold();
    final englishData = await PdfGoogleFonts.notoSansAdlamBold();

    // Add one page with centered text "Hello World"
    doc.addPage(
      pw.Page(
        pageFormat: format,
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          return pw.Column(children: [
            /* *SECTION - Header */
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(children: [
                    pw.Container(
                        width: 175,
                        child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('اتحاد ملاك كمبوند',
                                  style: pw.TextStyle(font: arabicLabel)),
                              pw.Text('/'),
                              pw.Text('اسبانيا سيتي',
                                  style: pw.TextStyle(font: arabicData)),
                            ])),
                    pw.Text('مشهر برقم 11-2013  العمرانية',
                        style: pw.TextStyle(font: arabicLabel)),
                  ]),
                  pw.Container(
                      width: 150,
                      child: pw.Text(
                          'لا يعتد بهذا الإيصال إلا إذا كان مختوماً بخاتم اتحاد الشاغلين',
                          style: pw.TextStyle(font: arabicLabel)))
                ]),
            /* *!SECTION */
            pw.SizedBox(height: 20),
            /* *SECTION - Title & ApartementName */
            pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('إيصال تحصيل نقدية',
                      style: pw.TextStyle(font: arabicHeader)),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text('رقم الوحدة :   ',
                            style: pw.TextStyle(font: arabicLabel)),
                        pw.Text(payment.apartementName,
                            style: pw.TextStyle(font: englishData))
                      ])
                ]),
            /* *!SECTION */
            pw.SizedBox(height: 20),
            /* *SECTION - Date Of Report & Amount */
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text('تحرير في :   ',
                            style: pw.TextStyle(font: arabicLabel)),
                        pw.Text(
                            intl.DateFormat.yMMMMEEEEd('ar')
                                .format(payment.paymentDate)
                                .toString(),
                            style: pw.TextStyle(font: arabicData))
                      ]),
                  pw.Column(children: [
                    pw.Text('قيمة السداد',
                        style: pw.TextStyle(font: arabicLabel)),
                    pw.Text(
                        UsefulFunctions.replaceArabicNumber(
                            payment.paymentAmount.toStringAsFixed(2)),
                        style: pw.TextStyle(font: arabicData)),
                  ]),
                ]),
            /* *!SECTION */
            pw.SizedBox(height: 20),
            /* *SECTION - Owner Who Payed & Amount Written & The Reason */
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(children: [
                    pw.Text('استلمنا من :   استاذ ',
                        style: pw.TextStyle(font: arabicLabel)),
                    pw.Text(payment.ownerName,
                        style: pw.TextStyle(font: arabicData))
                  ]),
                  pw.SizedBox(height: 20),
                  pw.Row(children: [
                    pw.Text('قيمة السداد مكتوبة :   ',
                        style: pw.TextStyle(font: arabicLabel)),
                    pw.Text(
                        '${Tafqeet.convert(payment.paymentAmount.toString())}جنيهاً لا غير',
                        style: pw.TextStyle(font: arabicData))
                  ]),
                  pw.SizedBox(height: 20),
                  pw.Row(children: [
                    pw.Text('وذلك قيمة :   ',
                        style: pw.TextStyle(font: arabicLabel)),
                    pw.Text(payment.paymentNote,
                        style: pw.TextStyle(font: arabicData))
                  ]),
                ])
            /* *!SECTION */
          ]);
        },
      ),
    );

    // Build and return the final Pdf file data
    return await doc.save();
  }

  /* *!SECTION */

  @override
  void initState() {
    initializeDateFormatting();
    fromDateOfPaymentsFilterTextController = TextEditingController(
        text: intl.DateFormat.yMMMMEEEEd('ar')
            .format(fromDatePaymentFilter.value));
    toDateOfPaymentsFilterTextController = TextEditingController(
        text:
            intl.DateFormat.yMMMMEEEEd('ar').format(toDatePaymentFilter.value));

    _model = returnTheTableUX();
    if (widget.status == 'PaymentsDuringMonth') {
      getPaymentsDuringDates();
    } else if (widget.status == 'PaymentsWithFilters') {
      getPaymentsWithSpecificQuery(widget.queryStatement);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RxBool onMoreButtonHover = false.obs;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    /* *SECTION - Mobile View */
    if (GlobalClass.sizingInformation.deviceScreenType ==
            DeviceScreenType.tablet ||
        GlobalClass.sizingInformation.deviceScreenType ==
            DeviceScreenType.mobile) {
      GlobalClass.menuOptionsMobile = [
        MenuOption(
            menuTitle: 'تسجيل سداد',
            onMenuTapButton: () {
              NavigationProperties.selectedTabNeededParamters = [
                'Add',
                RealEstateData(
                    id: -1,
                    apartementStatusId: -1,
                    apartementPostionInFloorId: -1,
                    apartementPostionInBuildingId: -1,
                    apartementLink: '',
                    isApartementHasEnoughData: false,
                    apartementName: ''),
                PaymentData(
                    id: -1,
                    apartementId: -1,
                    apartementPostionInBuildingId: -1,
                    paymentDate: DateTime.now(),
                    paymentAmount: -1,
                    paymentNote: '')
              ];
              NavigationProperties.selectedTabVaueNotifier(
                  NavigationProperties.addPaymentMobilePage);
            }),
        MenuOption(
            menuTitle: 'طباعة تقرير',
            onMenuTapButton: () {
              exportXLSXOfData();
            }),
        MenuOption(
            menuTitle: 'تحديد البيانات',
            onMenuTapButton: () {
              NavigationProperties.selectedTabVaueNotifier(
                  NavigationProperties.filterPaymentsPage);
            })
      ];

      return Scaffold(
        backgroundColor: Colors.white,
        body: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView(children: [
              const SizedBox(
                height: 20,
              ),
              Obx(() {
                if (updateMobileListWhenDataIsPopulated.value == false) {
                  return const Center(
                      child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator()));
                }
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: _payments.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    PaymentData currentPayment = _payments[index];
                    return Obx(
                      () => PaymentMobileTile(
                        currentPayment: currentPayment,
                        index: index,
                        selectedPaymentForDetails:
                            selectedPaymentForDetails.value,
                        onTapDeleteButton: () async {
                          if (await deletePaymentData(_payments[index].id) ==
                              200) {
                            Get.showSnackbar(const GetSnackBar(
                              message: 'تم الحذف بنجاح',
                            ));
                          }
                        },
                        onTapEditButton: () async {
                          var getDataResponse = await SQLFunctions.sendQuery(
                              query:
                                  'SELECT * FROM SpainCity.RealEstates where idRealEstates = ${currentPayment.apartementId}');
                          List<RealEstateData> selectedApartement = [];

                          if (getDataResponse.statusCode == 200) {
                            var data = json.decode(getDataResponse.body);
                            for (var element in data) {
                              selectedApartement.add(RealEstateData(
                                  id: element[0],
                                  apartementStatusId: element[12],
                                  apartementPostionInFloorId: element[11],
                                  apartementPostionInBuildingId: element[10],
                                  apartementLink: element[9],
                                  isApartementHasEnoughData:
                                      element[1] == 1 ? true : false,
                                  apartementName: element[13],
                                  ownerName: element[2],
                                  ownerPhoneNumber: element[3],
                                  responsibleName: element[7],
                                  responsiblePhone: element[8]));
                            }
                          } else {
                            selectedApartement.add(RealEstateData(
                                id: 400,
                                apartementStatusId: 400,
                                apartementPostionInFloorId: 400,
                                apartementPostionInBuildingId: 400,
                                apartementLink: getDataResponse.body,
                                isApartementHasEnoughData: false,
                                apartementName: getDataResponse.body));
                          }
                          NavigationProperties.selectedTabNeededParamters = [
                            'Edit',
                            selectedApartement.first,
                            currentPayment
                          ];
                          NavigationProperties.selectedTabVaueNotifier(
                              NavigationProperties.addPaymentMobilePage);
                        },
                        onTapMoreButton: () {
                          selectedPaymentForDetails(index);
                        },
                        onTapPrintButton: () {
                          Printing.layoutPdf(
                            // [onLayout] will be called multiple times
                            // when the user changes the printer or printer settings
                            onLayout: (PdfPageFormat format) {
                              // Any valid Pdf document can be returned here as a list of int
                              return createPDFReceit(
                                  PdfPageFormat.a4, currentPayment);
                            },
                          );
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                );
              }),
              const SizedBox(
                height: 20,
              )
            ])),
      );
    }
    /* *!SECTION */
    /* *SECTION - Desktop View */
    else if (GlobalClass.sizingInformation.deviceScreenType ==
        DeviceScreenType.desktop) {
      /*      return Scaffold(
          body: Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              color: Colors.white,
              child: ListView(shrinkWrap: true, children: [
                /* *SECTION - Top Part */
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.only(top: 10, right: 0),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /* *SECTION - Routes */
                      RoutesBuilder(
                          routeLabels: const ['سداد الملاك خلال فترة محددة'],
                          routeScreen: [NavigationProperties.nonePageRoute]),
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
                                      position: const RelativeRect.fromLTRB(
                                          50, 125, 50, 0),
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
                                                          selectedOwner: RealEstateData(
                                                              id: -1,
                                                              apartementStatusId:
                                                                  -1,
                                                              apartementPostionInFloorId:
                                                                  -1,
                                                              apartementPostionInBuildingId:
                                                                  -1,
                                                              apartementLink:
                                                                  '',
                                                              isApartementHasEnoughData:
                                                                  false,
                                                              apartementName:
                                                                  ''));
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
                                            color: Colors.grey[500] ??
                                                Colors.white),
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
                const SizedBox(
                  height: 20,
                ),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    TextTile(
                        width: 250,
                        textController: fromDateOfPaymentsFilterTextController,
                        title: "عرض السدادات من تاريخ",
                        hintText: "اختر التاريخ",
                        onTap: () {
                          showDatePicker(
                                  textDirection: TextDirection.rtl,
                                  cancelText: "الغاء",
                                  confirmText: "تأكيد",
                                  context: context,
                                  initialDate: fromDatePaymentFilter.value,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now())
                              .then((value) {
                            if (!value!.isAfter(toDatePaymentFilter.value)) {
                              fromDatePaymentFilter(value);
                              _model!.removeRows();

                              getPaymentsDuringDates();

                              fromDateOfPaymentsFilterTextController.text =
                                  intl.DateFormat.yMMMMEEEEd('ar')
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
                        textController: toDateOfPaymentsFilterTextController,
                        title: "عرض السدادات الى تاريخ",
                        hintText: "اختر التاريخ",
                        onTap: () {
                          showDatePicker(
                                  textDirection: TextDirection.rtl,
                                  cancelText: "الغاء",
                                  confirmText: "تأكيد",
                                  context: context,
                                  initialDate: toDatePaymentFilter.value,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now())
                              .then((value) {
                            if (!value!.isBefore(fromDatePaymentFilter.value)) {
                              toDatePaymentFilter(value);
                              _model!.removeRows();

                              getPaymentsDuringDates();

                              toDateOfPaymentsFilterTextController.text =
                                  intl.DateFormat.yMMMMEEEEd('ar')
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
                ),
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
                    height: height / 1.3,
                    clipBehavior: Clip.hardEdge,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Davi<PaymentData>(
                      _model,
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
                                        return FluidDialog(
                                            rootPage: FluidDialogPage(
                                          builder: (context) {
                                            return AddPaymentDialog(
                                              state: 'Add',
                                              selectedOwner: RealEstateData(
                                                  id: -1,
                                                  apartementStatusId: -1,
                                                  apartementPostionInFloorId:
                                                      -1,
                                                  apartementPostionInBuildingId:
                                                      -1,
                                                  apartementLink: '',
                                                  isApartementHasEnoughData:
                                                      false,
                                                  apartementName: ''),
                                            );
                                          },
                                        ));
                                      },
                                    );
                                  },
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                      visibleRowsCount:
                          int.parse((height / 50).toStringAsFixed(0)),
                      columnWidthBehavior: ColumnWidthBehavior.scrollable,
                      onRowTap: (data) {},
                      onRowSecondaryTap: (data) async {
                        RxBool onDeleteHover = false.obs;
                        RxBool onEditHover = false.obs;
                        var getDataResponse = await SQLFunctions.sendQuery(
                            query:
                                'SELECT * FROM SpainCity.RealEstates where idRealEstates = ${data.apartementId}');
                        List<RealEstateData> selectedApartement = [];

                        if (getDataResponse.statusCode == 200) {
                          var data = json.decode(getDataResponse.body);
                          for (var element in data) {
                            selectedApartement.add(RealEstateData(
                                id: element[0],
                                apartementStatusId: element[12],
                                apartementPostionInFloorId: element[11],
                                apartementPostionInBuildingId: element[10],
                                apartementLink: element[9],
                                isApartementHasEnoughData:
                                    element[1] == 1 ? true : false,
                                apartementName: element[13],
                                ownerName: element[2],
                                ownerPhoneNumber: element[3],
                                responsibleName: element[7],
                                responsiblePhone: element[8]));
                          }
                        } else {
                          selectedApartement.add(RealEstateData(
                              id: 400,
                              apartementStatusId: 400,
                              apartementPostionInFloorId: 400,
                              apartementPostionInBuildingId: 400,
                              apartementLink: getDataResponse.body,
                              isApartementHasEnoughData: false,
                              apartementName: getDataResponse.body));
                        }
                        if (mounted) {
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
                                          return FluidDialog(
                                              rootPage: FluidDialogPage(
                                            builder: (context) {
                                              return AddPaymentDialog(
                                                state: 'Edit',
                                                paymentData: data,
                                                selectedOwner:
                                                    selectedApartement.first,
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
                        }
                      },
                    ),
                  ),
                ),

                /* *!SECTION */
              ])));
    */
    }
    /* *!SECTION */
    return const SizedBox();
  }
}

class PaymentMobileTile extends StatefulWidget {
  const PaymentMobileTile(
      {super.key,
      required this.currentPayment,
      required this.index,
      required this.selectedPaymentForDetails,
      required this.onTapMoreButton,
      required this.onTapDeleteButton,
      required this.onTapEditButton,
      required this.onTapPrintButton});

  final PaymentData currentPayment;
  final int selectedPaymentForDetails;
  final int index;
  final Function onTapMoreButton;
  final Function onTapDeleteButton;
  final Function onTapEditButton;
  final Function onTapPrintButton;
  @override
  State<PaymentMobileTile> createState() => _PaymentMobileTileState();
}

class _PaymentMobileTileState extends State<PaymentMobileTile> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        height: widget.selectedPaymentForDetails == widget.index ? 300 : 190,
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(24),
        ),
        duration: const Duration(milliseconds: 500),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            /* *SECTION - Owner Name */
            Text(widget.currentPayment.ownerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoSansArabic(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                )),
            /* *!SECTION */
            const SizedBox(
              height: 10,
            ),
            /* *SECTION - Apartement Details */
            Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /* *SECTION - Realestate BuildingNo */
                  LabelAndDataVerticalWidget(
                      labelText: 'عمارة',
                      dataText: UsefulFunctions.replaceArabicNumber(widget
                          .currentPayment.apartementPostionInBuildingId
                          .toString())),
                  /* *!SECTION */
                  /* *SECTION - Apaartement Number */
                  LabelAndDataVerticalWidget(
                      labelText: 'الوحدة',
                      dataText: widget.currentPayment.apartementName),
                  /* *!SECTION */
                  /* *SECTION - Payment Amount */
                  LabelAndDataVerticalWidget(
                      labelText: 'التاريخ',
                      dataText: intl.DateFormat.yMd('ar')
                          .format(widget.currentPayment.paymentDate),
                      dataTextDirection: TextDirection.rtl),

                  /* *!SECTION */
                  /* *SECTION - Payment Amount */
                  LabelAndDataVerticalWidget(
                      labelText: 'المبلغ',
                      dataText: UsefulFunctions.replaceArabicNumber(
                          widget.currentPayment.paymentAmount.toString())),
                  /* *!SECTION */
                ]),
            const Divider(),
            /* *SECTION - See More */
            Visibility(
              visible: widget.selectedPaymentForDetails == widget.index
                  ? false
                  : true,
              child: AnimatedOpacity(
                opacity:
                    widget.selectedPaymentForDetails == widget.index ? 0 : 1,
                duration: const Duration(milliseconds: 500),
                child: MenuButtonCard(
                  icon: Icons.open_in_new,
                  title: 'المزيد',
                  onTap: () {
                    widget.onTapMoreButton();
                  },
                ),
              ),
            ),
            /* *!SECTION */
            /* *SECTION - Details Of Real Estate */
            Visibility(
                visible: widget.selectedPaymentForDetails == widget.index
                    ? true
                    : false,
                child: AnimatedOpacity(
                    opacity: widget.selectedPaymentForDetails == widget.index
                        ? 1
                        : 0,
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LabelAndDataHorizontalWidget(
                            labelText: 'رقم تليفون',
                            dataText: widget.currentPayment.ownerPhoneNumber,
                          ),
                          LabelAndDataHorizontalWidget(
                            labelText: 'الملاحظة',
                            dataText: widget.currentPayment.paymentNote,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MenuButtonCard(
                              icon: Icons.print_outlined,
                              title: 'طباعة ايصال',
                              onTap: () {
                                widget.onTapPrintButton();
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          MenuButtonCard(
                            icon: Icons.delete_outline,
                            title: 'حذف السداد',
                            onTap: () {
                              DialogTile.bottomSheetTile(
                                  context: context,
                                  width: GlobalClass
                                      .sizingInformation.screenSize.width,
                                  height: GlobalClass
                                      .sizingInformation.screenSize.height,
                                  onMenuButtonTap: (index) {
                                    if (index == 0) {
                                      widget.onTapDeleteButton();
                                      Navigator.of(context).pop();
                                    } else if (index == 1) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  menuText: [
                                    ' ${widget.currentPayment.paymentAmount} حذف السداد بقيمة',
                                    'الغاء الحذف'
                                  ]);
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MenuButtonCard(
                              icon: Icons.edit_outlined,
                              title: 'تعديل السداد',
                              onTap: () {
                                widget.onTapEditButton();
                              }),
                        ])))
          ]),
        ));
  }
}
