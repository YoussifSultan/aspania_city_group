import 'package:aspania_city_group/Common_Used/global_class.dart';
import 'package:aspania_city_group/Common_Used/navigation.dart';
import 'package:aspania_city_group/Dashboard/menu_card_button.dart';
import 'package:aspania_city_group/class/payment.dart';
import 'package:aspania_city_group/class/realestate.dart';
import 'package:flutter/material.dart';

class DrawerMenuScreen extends StatefulWidget {
  const DrawerMenuScreen({super.key});

  @override
  State<DrawerMenuScreen> createState() => _DrawerMenuScreenState();
}

class _DrawerMenuScreenState extends State<DrawerMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24), bottomLeft: Radius.circular(24))),
      child: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          /* *SECTION - Menu Buttons */
          /* *SECTION - Real Estates Item */
          MenuButtonCard(
            title: 'عرض العمارات',
            icon: Icons.apartment_rounded,
            onTap: () {
              NavigationProperties.selectedTabVaueNotifier(
                  NavigationProperties.realEstateSummaryPageRoute);
              GlobalClass.drawerController.toggle!();
            },
          ),
          /* *!SECTION */
          const SizedBox(
            height: 10,
          ),
          /* *SECTION - Owners Item */
          MenuButtonCard(
            title: 'تسجيل سداد',
            icon: Icons.add_card_rounded,
            onTap: () {
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
              GlobalClass.drawerController.toggle!();
            },
          ),
          /* *!SECTION */
          const SizedBox(
            height: 10,
          ),
          /* *SECTION - Payments Item */
          MenuButtonCard(
            title: 'عرض السدادات',
            icon: Icons.payments_rounded,
            onTap: () {
              NavigationProperties.selectedTabNeededParamters = [
                'PaymentsDuringMonth',
                ''
              ];
              NavigationProperties.selectedTabVaueNotifier(
                  NavigationProperties.overallPaymentsThroughPeriodPageRoute);
              GlobalClass.drawerController.toggle!();
            },
          ),
          /* *!SECTION */
          const SizedBox(
            height: 10,
          ),
          /* *!SECTION */
        ],
      ),
    );
  }
}
