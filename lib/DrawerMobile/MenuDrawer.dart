import 'package:aspania_city_group/Common_Used/navigation.dart';
import 'package:aspania_city_group/Dashboard/menu_card_button.dart';
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
            title: 'الوحدات',
            icon: Icons.category_outlined,
            onTap: () {
              NavigationProperties.selectedTabVaueNotifier(
                  NavigationProperties.realEstateSummaryPageRoute);
              NavigationProperties.drawerController.toggle!();
            },
          ),
          /* *!SECTION */
          const SizedBox(
            height: 10,
          ),
          /* *SECTION - Owners Item */
          MenuButtonCard(
            title: 'المقيمين',
            icon: Icons.people_alt_outlined,
            onTap: () {
              NavigationProperties.selectedTabNeededParamters = [
                -1,
                'All_Owners'
              ];
              NavigationProperties.selectedTabVaueNotifier(
                  NavigationProperties.dataTableOfApartements);

              NavigationProperties.drawerController.toggle!();
            },
          ),
          /* *!SECTION */
          const SizedBox(
            height: 10,
          ),
          /* *SECTION - Payments Item */
          MenuButtonCard(
            title: 'سداد',
            icon: Icons.payments_rounded,
            onTap: () {
              NavigationProperties.drawerController.toggle!();
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
