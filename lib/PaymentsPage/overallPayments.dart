import 'dart:convert';

import 'package:aspania_city_group/Common_Used/button_tile.dart';
import 'package:aspania_city_group/Common_Used/navigation.dart';
import 'package:aspania_city_group/Common_Used/sql_functions.dart';
import 'package:aspania_city_group/PaymentsPage/AddPaymentDialog.dart';
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

import '../Common_Used/text_tile.dart';
import '../Dashboard/menu_card_button.dart';

class OverallPaymentsThroughPeriod extends StatefulWidget {
  const OverallPaymentsThroughPeriod({super.key});

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
        rows: _payments.getRange(0, lastindexOfPaymentsLoaded).toList(),
        onSort: (sortedColumns) {},
        columns: [
          DaviColumn(
              width: 400,
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

/* *SECTION - Export Excel */
  void exportXLSXOfData() {
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
        'تاريخ السداد';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('K7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('K7')).value =
        'مبلغ الفاتورة';
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('J7')).cellStyle =
        headerStyle;
    aprtartementsExcelSheet.cell(xlsx.CellIndex.indexByString('J7')).value =
        'ملاحظات';

/* *!SECTION */
/* *SECTION - Set Values */
    for (var i = 0; i < _payments.length; i++) {
      PaymentData payment = _payments[i];
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
      // تاريخ السداد
      aprtartementsExcelSheet
              .cell(xlsx.CellIndex.indexByString('L${i + 8}'))
              .value =
          '${payment.paymentDate.year} / ${payment.paymentDate.month} / ${payment.paymentDate.day}';
      // مبلغ الفاتورة
      aprtartementsExcelSheet
          .cell(xlsx.CellIndex.indexByString('K${i + 8}'))
          .value = payment.paymentAmount;
      // ملاحظات
      aprtartementsExcelSheet
          .cell(xlsx.CellIndex.indexByString('J${i + 8}'))
          .value = payment.paymentNote;
    }
    aprtartementExcel.save(fileName: 'فواتير السداد خلال هذا الشهر.xlsx');
/* *!SECTION */
  }

/* *!SECTION */
/* *SECTION - SQL Backend */
/* *SECTION - get Payment During The Month */
  Future<void> getPaymentsDuringTheMonth() async {
    var getDataResponse = await SQLFunctions.sendQuery(
        query: 'SELECT * FROM SpainCity.PaymentsOfRealEsate;');
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
    getPaymentsDuringTheMonth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RxBool onMoreButtonHover = false.obs;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                                                            apartementLink: '',
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
                                          color:
                                              Colors.grey[500] ?? Colors.white),
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

                            for (var element in _payments) {
                              if (element.paymentDate.isAfter(
                                      fromDatePaymentFilter.value
                                          .subtract(const Duration(days: 1))) &&
                                  element.paymentDate.isBefore(
                                      toDatePaymentFilter.value
                                          .add(const Duration(days: 1)))) {
                                _model!.addRow(element);
                                _model!.notifyUpdate();
                              }
                            }
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

                            for (var element in _payments) {
                              if (element.paymentDate.isAfter(
                                      fromDatePaymentFilter.value
                                          .subtract(const Duration(days: 1))) &&
                                  element.paymentDate.isBefore(
                                      toDatePaymentFilter.value
                                          .add(const Duration(days: 1)))) {
                                _model!.addRow(element);
                                _model!.notifyUpdate();
                              }
                            }
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
                                      return FluidDialog(
                                          rootPage: FluidDialogPage(
                                        builder: (context) {
                                          return AddPaymentDialog(
                                            state: 'Add',
                                            selectedOwner: RealEstateData(
                                                id: -1,
                                                apartementStatusId: -1,
                                                apartementPostionInFloorId: -1,
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
  }
}
