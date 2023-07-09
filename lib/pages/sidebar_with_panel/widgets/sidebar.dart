import 'package:flutter/material.dart';
import 'package:um_core/um_core.dart';
import 'package:user_management_web/pages/auth_pages/login_page.dart';
import 'package:user_management_web/pages/sidebar_with_panel/controllers/panel_and_sidebar_controller.dart';
import 'package:user_management_web/pages/sidebar_with_panel/widgets/sidebar_item.dart';
import 'package:user_management_web/pages/sidebar_with_panel/utils/sidebar_enum.dart';


class SideBar extends StatelessWidget {
  const SideBar(
      {Key? key,
        required this.selectedValue,
        required this.myController})
      : super(key: key);

  final SideBarItemColor selectedValue;
  final SideBarMenuController myController;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 180,
        minWidth: 180,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            SideBarMenuItem(
              icon: Icons.miscellaneous_services,
              menuItemName: "Users Management",
              onTap: () {
                myController.setUserManagementMenuItem();
              },
              itemColor: selectedValue == SideBarItemColor.usersManagement ? true : false ,
            ),
            SideBarMenuItem(
              icon: Icons.dashboard,
              menuItemName: "Work Activities",
              onTap: () {
                myController.setWorkActivitiesMenuItem();
              },
              itemColor: selectedValue == SideBarItemColor.workActivities ? true : false ,
            ),
            SideBarMenuItem(
              icon: Icons.bar_chart,
              menuItemName: "Detailed Report",
              onTap: () {
                myController.setDetailedReportMenuItem();
              },
              itemColor: selectedValue == SideBarItemColor.detailedReports ? true : false ,
            ),
            SideBarMenuItem(
                icon: Icons.logout_rounded,
                menuItemName: 'Log Out',
                onTap: (){
                  AppNavigator.pushAndRemoveUntil(context, const LoginScreen());
                },
                itemColor: selectedValue == SideBarItemColor.logOut ? true : false,
            )
          ],
        ),
      ),
    );
  }
}


