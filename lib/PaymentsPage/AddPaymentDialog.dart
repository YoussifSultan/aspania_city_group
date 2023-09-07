import 'package:aspania_city_group/Common_Used/button_tile.dart';
import 'package:aspania_city_group/Common_Used/text_tile.dart';
import 'package:flutter/material.dart';

class AddPaymentDialog extends StatefulWidget {
  const AddPaymentDialog({super.key, required this.state});
  final String state;
  @override
  State<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<AddPaymentDialog> {
  /* *SECTION - text controller */
  TextEditingController dateOfPaymentTextController = TextEditingController();
  TextEditingController amountOfPaymentTextController = TextEditingController();
  TextEditingController noteOfPaymentTextController = TextEditingController();
  /* *!SECTION */
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      width: 465,
      height: 355,
      child: ListView(
        shrinkWrap: true,
        children: [
          /* *SECTION - Payment Date & Payment Amount */
          Row(
            textDirection: TextDirection.rtl,
            children: [
              TextTile(
                  width: 200,
                  textController: dateOfPaymentTextController,
                  title: 'تاريخ السداد',
                  onTap: () {},
                  hintText: 'اختر التاريخ',
                  icon: Icons.calendar_month_outlined),
              const SizedBox(
                width: 20,
              ),
              TextTile(
                  width: 200,
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
