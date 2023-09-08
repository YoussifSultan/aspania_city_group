import 'package:aspania_city_group/Common_Used/button_tile.dart';
import 'package:aspania_city_group/Common_Used/text_tile.dart';
import 'package:aspania_city_group/DataTableForApartements/ApartementSelector.dart';
import 'package:aspania_city_group/class/realestate.dart';
import 'package:aspania_city_group/class/validators.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';

class AddPaymentDialog extends StatefulWidget {
  const AddPaymentDialog({super.key, required this.state, this.selectedOwner});
  final String state;
  final RealEstateData? selectedOwner;

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
    super.initState();
  }

  /* *!SECTION */
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      width: 465,
      height: 455,
      child: ListView(
        shrinkWrap: true,
        children: [
          /* *SECTION - Payment Date & Payment Amount */
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
                              return const ApartementSelector();
                            },
                          ),
                        ))).then((value) {
                  selectedOwner = value;
                  selectedOwnerToAddPaymentTextController.text =
                      value.ownerName;
                });
              },
              icon: Icons.person_search_outlined),
          Row(
            textDirection: TextDirection.rtl,
            children: [
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
              const SizedBox(
                width: 20,
              ),
              TextTile(
                  width: 200,
                  onChange: (text, errorText) {
                    if (Validators.isNumericOrEmptyOnly(text)) {
                    } else {
                      errorText('ادخل ارقام فقط');
                    }
                  },
                  textController: amountOfPaymentTextController,
                  title: 'المبلغ',
                  hintText: 'ادخل المبلغ',
                  icon: Icons.money),
            ],
          ),
          TextTile(
              width: 430,
              height: 100,
              textController: noteOfPaymentTextController,
              title: 'ملاحظات',
              hintText: 'ادخل الملاحظات',
              icon: Icons.description_outlined),
          /* *!SECTION */
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.state == 'Add'
                  ? ButtonTile(onTap: () {}, buttonText: 'حفظ')
                  : ButtonTile(onTap: () {}, buttonText: 'تعديل'),
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
        ],
      ),
    );
  }
}
