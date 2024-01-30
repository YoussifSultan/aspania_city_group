import 'dart:convert';

import 'package:aspania_city_group/Common_Used/button_tile.dart';
import 'package:aspania_city_group/Common_Used/global_class.dart';
import 'package:aspania_city_group/Common_Used/navigation.dart';
import 'package:aspania_city_group/Common_Used/sql_functions.dart';
import 'package:aspania_city_group/Common_Used/text_tile.dart';
import 'package:aspania_city_group/Dashboard/dashboard.dart';
import 'package:aspania_city_group/DataTableForApartements/ApartementSelector.dart';
import 'package:aspania_city_group/class/payment.dart';
import 'package:aspania_city_group/class/realestate.dart';
import 'package:aspania_city_group/class/validators.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddPaymentDialog extends StatefulWidget {
  const AddPaymentDialog({
    super.key,
    required this.state,
    this.selectedOwner,
    this.paymentData,
  });
  final String state;

  final RealEstateData? selectedOwner;
  final PaymentData? paymentData;

  @override
  State<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<AddPaymentDialog> {
  /* *SECTION - Varibales To Save */
  DateTime paymentDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String paymentNote = '';
  double paymentAmount = 0;
  RealEstateData selectedOwner = RealEstateData(
      id: -1,
      apartementStatusId: -1,
      apartementPostionInFloorId: -1,
      apartementPostionInBuildingId: -1,
      apartementLink: '',
      isApartementHasEnoughData: false,
      apartementName: '');
  /* *!SECTION */
  /* *SECTION - text controller */
  late TextEditingController dateOfPaymentTextController;
  TextEditingController amountOfPaymentTextController = TextEditingController();
  TextEditingController noteOfPaymentTextController = TextEditingController();
  late TextEditingController selectedOwnerToAddPaymentTextController;
  List<Validators> errors = [];
  /* *!SECTION */
  /* *SECTION - Init State */
  @override
  void initState() {
    try {
      selectedOwner = widget.selectedOwner ?? selectedOwner;
    } catch (e) {
      selectedOwner = selectedOwner;
    }
    selectedOwnerToAddPaymentTextController =
        TextEditingController(text: selectedOwner.ownerName);
    dateOfPaymentTextController = TextEditingController(
        text:
            '${paymentDate.year} / ${paymentDate.month} / ${paymentDate.day}');
    if (widget.state == 'Edit') {
      paymentDate = widget.paymentData!.paymentDate;
      paymentNote = widget.paymentData!.paymentNote;
      paymentAmount = widget.paymentData!.paymentAmount;
      dateOfPaymentTextController.text =
          '${paymentDate.year} / ${paymentDate.month} / ${paymentDate.day}';
      noteOfPaymentTextController.text = paymentNote;
      amountOfPaymentTextController.text = paymentAmount.toString();
    }
    super.initState();
  }

  Future<void> addOrEditPayment() async {
    if (errors.isEmpty) {
      if (paymentAmount != 0 && selectedOwner.id != -1) {
        PaymentData payment;
        if (widget.state == 'Edit') {
          payment = PaymentData(
              apartementPostionInBuildingId:
                  selectedOwner.apartementPostionInBuildingId,
              id: widget.paymentData!.id,
              apartementName: selectedOwner.apartementName,
              ownerName: selectedOwner.ownerName,
              ownerPhoneNumber: selectedOwner.ownerPhoneNumber,
              apartementId: selectedOwner.id,
              paymentDate: paymentDate,
              paymentAmount: paymentAmount,
              paymentNote: paymentNote);
          if (await editPayment(payment) == 200) {
            Get.showSnackbar(const GetSnackBar(
              duration: Duration(seconds: 2),
              animationDuration: Duration(seconds: 1),
              message: 'تم التعديل بنجاح',
            ));
            if (mounted && GlobalClass.sizingInformation.isDesktop) {
              Navigator.of(context).pop();
            } else if (mounted &&
                (GlobalClass.sizingInformation.isMobile ||
                    GlobalClass.sizingInformation.isTablet)) {
              NavigationProperties.selectedTabNeededParamters = [];
              NavigationProperties.selectedTabVaueNotifier(
                  NavigationProperties.overallPaymentsThroughPeriodPageRoute);
            }
          }
        } else {
          payment = PaymentData(
              id: await getPaymentLastID() + 1,
              apartementName: selectedOwner.apartementName,
              ownerName: selectedOwner.ownerName,
              apartementPostionInBuildingId:
                  selectedOwner.apartementPostionInBuildingId,
              ownerPhoneNumber: selectedOwner.ownerPhoneNumber,
              apartementId: selectedOwner.id,
              paymentDate: paymentDate,
              paymentAmount: paymentAmount,
              paymentNote: paymentNote);
          if (await insertNewPayment(payment) == 200) {
            Get.showSnackbar(const GetSnackBar(
              duration: Duration(seconds: 2),
              animationDuration: Duration(seconds: 1),
              message: 'تم الحفظ بنجاح',
            ));
            if (mounted && GlobalClass.sizingInformation.isDesktop) {
              Navigator.of(context).pop();
            } else if (mounted &&
                (GlobalClass.sizingInformation.isMobile ||
                    GlobalClass.sizingInformation.isTablet)) {
              NavigationProperties.selectedTabNeededParamters = [];
              NavigationProperties.selectedTabVaueNotifier(
                  NavigationProperties.overallPaymentsThroughPeriodPageRoute);
            }
          }
        }
      } else {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 2),
          animationDuration: Duration(seconds: 1),
          message: 'ادخل البيانات الاتية (المالك \\ المبلغ \\ التاريخ)',
        ));
      }
    }
  }

/* *SECTION - SQL Backend */
/* *SECTION - Add New Payment */
  Future<int> insertNewPayment(PaymentData paymentData) async {
    var insertDataResponse = await SQLFunctions.sendQuery(
        query:
            'INSERT INTO `SpainCity`.`PaymentsOfRealEsate` (`Id`, `realEstateId`, `realEstateOwnerName`,'
            ' `realEstateOwnerTelephone`, `realEstateApartementName`, `paymentDate`, `paymentAmount`, `paymentNote` , `realEstateLink`)'
            ' VALUES (\'${paymentData.id}\', \'${paymentData.apartementId}\', \'${paymentData.ownerName}\','
            ' \'${paymentData.ownerPhoneNumber}\', \'${paymentData.apartementName}\', '
            '\'${paymentData.paymentDate}\', \'${paymentData.paymentAmount}\', \'${paymentData.paymentNote}\' ,\'${paymentData.apartementPostionInBuildingId}\');');
    return insertDataResponse.statusCode;
  }

/* *!SECTION */
/* *SECTION - Update Payment */
  Future<int> editPayment(PaymentData paymentData) async {
    // UPDATE `SpainCity`.`PaymentsOfRealEsate` SET `realEstateId` = \'${paymentData.apartementId}\', `realEstateOwnerName` = \'Osama\', `realEstateOwnerTelephone` = \'01116578889\', `paymentDate` = \'2008-12-27\', `paymentAmount` = \'502\', `paymentNote` = \'ggg\' WHERE (`Id` = \'1\');
    var editDataResponse = await SQLFunctions.sendQuery(
        query:
            'UPDATE `SpainCity`.`PaymentsOfRealEsate` SET `realEstateId` = \'${paymentData.apartementId}\','
            ' `realEstateOwnerName` = \'${paymentData.ownerName}\','
            ' `realEstateOwnerTelephone` = \'${paymentData.ownerPhoneNumber}\','
            ' `paymentDate` = \'${paymentData.paymentDate}\', `paymentAmount` = \'${paymentData.paymentAmount}\','
            ' `paymentNote` = \'${paymentData.paymentNote}\' WHERE (`Id` = \'${paymentData.id}\');');
    return editDataResponse.statusCode;
  }

/* *!SECTION */
/* *SECTION - get last PaymentId */
  Future<int> getPaymentLastID() async {
    var getLastIDResponse = await SQLFunctions.sendQuery(
        query: "SELECT MAX(Id) FROM SpainCity.PaymentsOfRealEsate;");

    if (getLastIDResponse.statusCode == 200) {
      var data = json.decode(getLastIDResponse.body);
      return data[0][0] ?? 0;
    } else {
      return int.parse(getLastIDResponse.body);
    }
  }

/* *!SECTION */
  /* *!SECTION */
  @override
  Widget build(BuildContext context) {
    /* *SECTION - Mobile View */
    if (GlobalClass.sizingInformation.deviceScreenType ==
            DeviceScreenType.tablet ||
        GlobalClass.sizingInformation.deviceScreenType ==
            DeviceScreenType.mobile) {
      GlobalClass.menuOptionsMobile = [];
      /* *SECTION - Main Screen */
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          /* *SECTION - Owner Who Payed TextField */
          TextTile(
              width: GlobalClass.sizingInformation.screenSize.width * 0.8,
              textController: selectedOwnerToAddPaymentTextController,
              title: "مالك الوحدة",
              hintText: "اختر المالك الوحدة",
              onTap: () {
                showDialog(
                    context: context,
                    builder: ((context) => FluidDialog(
                          rootPage: FluidDialogPage(
                            builder: (context) {
                              return ApartementSelector(
                                width: GlobalClass
                                        .sizingInformation.screenSize.width *
                                    0.95,
                              );
                            },
                          ),
                        ))).then((value) {
                  selectedOwner = value;
                  selectedOwnerToAddPaymentTextController.text =
                      value.ownerName;
                });
              },
              icon: Icons.person_search_outlined),
          /* *!SECTION */

          /* *SECTION - Payment Date TextField */
          TextTile(
              width: GlobalClass.sizingInformation.screenSize.width * 0.8,
              textController: dateOfPaymentTextController,
              title: 'تاريخ السداد',
              onTap: () {
                showDatePicker(
                        textDirection: TextDirection.rtl,
                        cancelText: "الغاء",
                        confirmText: "تأكيد",
                        context: context,
                        initialDate: paymentDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now())
                    .then((value) {
                  paymentDate = value ?? paymentDate;
                  dateOfPaymentTextController.text =
                      '${paymentDate.year} / ${paymentDate.month} / ${paymentDate.day}';
                });
              },
              hintText: 'اختر التاريخ',
              icon: Icons.calendar_month_outlined),
          /* *!SECTION */

          /* *SECTION - Payment Amount TextField */
          TextTile(
              width: GlobalClass.sizingInformation.screenSize.width * 0.8,
              onChange: (text, errorText) {
                if (Validators.isNumeric(text)) {
                  errors.removeWhere(
                      (element) => element.errorText == 'Amount Not Number');
                  errorText('');
                  paymentAmount = double.parse(text);
                } else {
                  errorText('ادخل ارقام فقط');
                  errors.add(const Validators(
                      errorText: 'Amount Not Number', errorID: '1'));
                }
              },
              textController: amountOfPaymentTextController,
              title: 'المبلغ',
              hintText: 'ادخل المبلغ',
              icon: Icons.money),
          /* *!SECTION */
          /* *SECTION - Payment Note TextField */

          TextTile(
              width: GlobalClass.sizingInformation.screenSize.width * 0.8,
              height: 100,
              textController: noteOfPaymentTextController,
              title: 'ملاحظات',
              onChange: (text, errorText) {
                paymentNote = text;
              },
              hintText: 'ادخل الملاحظات',
              icon: Icons.description_outlined),
          /* *!SECTION */

          /* *SECTION - Add Or Edit Button */

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.state == 'Add'
                  ? ButtonTile(
                      onTap: () {
                        addOrEditPayment();
                      },
                      buttonText: 'حفظ')
                  : ButtonTile(
                      onTap: () {
                        addOrEditPayment();
                      },
                      buttonText: 'تعديل'),
            ],
          ),
          /* *!SECTION */
        ],
      );
      /* *!SECTION */
    }
    /* *!SECTION */
    /* *SECTION - Desktop View */
    if (GlobalClass.sizingInformation.deviceScreenType ==
        DeviceScreenType.desktop) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        width: 465,
        height: 455,
        child: ListView(
          shrinkWrap: true,
          children: [
            /* *SECTION - Owner Who Payed TextField */
            TextTile(
                width: 435,
                textController: selectedOwnerToAddPaymentTextController,
                title: "مالك الوحدة",
                hintText: "اختر المالك الوحدة",
                onTap: () {
                  showDialog(
                      context: context,
                      builder: ((context) => FluidDialog(
                            rootPage: FluidDialogPage(
                              builder: (context) {
                                return ApartementSelector(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                );
                              },
                            ),
                          ))).then((value) {
                    selectedOwner = value;
                    selectedOwnerToAddPaymentTextController.text =
                        value.ownerName;
                  });
                },
                icon: Icons.person_search_outlined),
            /* *!SECTION */
            /* *SECTION - Payment Amount & DateTextFields */

            Row(
              textDirection: TextDirection.rtl,
              children: [
                /* *SECTION - Payment Date TextField */
                TextTile(
                    width: 200,
                    textController: dateOfPaymentTextController,
                    title: 'تاريخ السداد',
                    onTap: () {
                      showDatePicker(
                              textDirection: TextDirection.rtl,
                              cancelText: "الغاء",
                              confirmText: "تأكيد",
                              context: context,
                              initialDate: paymentDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now())
                          .then((value) {
                        paymentDate = value ?? paymentDate;
                        dateOfPaymentTextController.text =
                            '${paymentDate.year} / ${paymentDate.month} / ${paymentDate.day}';
                      });
                    },
                    hintText: 'اختر التاريخ',
                    icon: Icons.calendar_month_outlined),
                /* *!SECTION */
                const SizedBox(
                  width: 20,
                ),
                /* *SECTION - Payment Amount TextField */
                TextTile(
                    width: 200,
                    onChange: (text, errorText) {
                      if (Validators.isNumeric(text)) {
                        errors.removeWhere((element) =>
                            element.errorText == 'Amount Not Number');
                        errorText('');
                        paymentAmount = double.parse(text);
                      } else {
                        errorText('ادخل ارقام فقط');
                        errors.add(const Validators(
                            errorText: 'Amount Not Number', errorID: '1'));
                      }
                    },
                    textController: amountOfPaymentTextController,
                    title: 'المبلغ',
                    hintText: 'ادخل المبلغ',
                    icon: Icons.money),
                /* *!SECTION */
              ],
            ),
            /* *!SECTION */
            /* *SECTION - Payment Note TextField */

            TextTile(
                width: 430,
                height: 100,
                textController: noteOfPaymentTextController,
                title: 'ملاحظات',
                onChange: (text, errorText) {
                  paymentNote = text;
                },
                hintText: 'ادخل الملاحظات',
                icon: Icons.description_outlined),
            /* *!SECTION */
            /* *SECTION - Add Or Edit Button & Cancel Button */

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.state == 'Add'
                    ? ButtonTile(
                        onTap: () {
                          addOrEditPayment();
                        },
                        buttonText: 'حفظ')
                    : ButtonTile(
                        onTap: () {
                          addOrEditPayment();
                        },
                        buttonText: 'تعديل'),
                const SizedBox(
                  width: 20,
                ),
                ButtonTile(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    buttonText: 'الغاء'),
              ],
            )
            /* *!SECTION */
          ],
        ),
      );
    }
    /* *!SECTION */
    return const SizedBox();
  }
}
