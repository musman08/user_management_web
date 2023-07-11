import 'package:flutter/material.dart';
import 'package:user_management_web/pages/auth_pages/login_page.dart';
import 'package:user_management_web/pages/sidebar_with_panel/utils/sidebar_enum.dart';
import 'package:user_management_web/pages/work_activity_page/work_activity_page.dart';
import 'package:user_management_web/pages/users_management_page/users_management_page.dart';

import '../../details_report_page/detailed_report_page.dart';


class SideBarMenuController with ChangeNotifier {
  List<Widget> pages = const [
    UsersManagementPage(),
    WorkActivitiesPage(),
    DetailedReportPage(),
  ];

  SideBarItemColor localSelectedValue = SideBarItemColor.usersManagement;
  Widget _mainPageWidget = const UsersManagementPage();

  SideBarItemColor get selectedValue => localSelectedValue;
  Widget get mainPageWidget => _mainPageWidget;

  void setUserManagementMenuItem() {
    localSelectedValue = SideBarItemColor.usersManagement;
    _mainPageWidget = pages[0];
    notifyListeners();
  }

  void setWorkActivitiesMenuItem() {
    localSelectedValue = SideBarItemColor.workActivities;
    _mainPageWidget = pages[1];
    notifyListeners();
  }

  void setDetailedReportMenuItem() {
    localSelectedValue = SideBarItemColor.detailedReports;
    _mainPageWidget = pages[2];
    notifyListeners();
  }
}
