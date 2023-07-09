import 'package:flutter/material.dart';
import 'package:um_core/um_core.dart';
import 'controlled/panel_controlled.dart';
import 'controlled/sidebar_controlled_widget.dart';
import 'controllers/panel_and_sidebar_controller.dart';

class MainPanelScreen extends StatefulWidget {
  const MainPanelScreen({Key? key}) : super(key: key);

  @override
  State<MainPanelScreen> createState() => _MainPanelScreenState();
}

class _MainPanelScreenState extends State<MainPanelScreen> {
  SideBarMenuController myController = SideBarMenuController();

  @override
  Widget build(BuildContext context) {
    final sideBar = SideBarMenuControlledWidget(myController: myController);
    final centerWidget = PanelControlledWidget(myController: myController);
    return LayoutBuilder(builder: (_, boxConstraints) {
      final isMobile = boxConstraints.maxWidth < 700;
      return Scaffold(
        appBar: isMobile
            ? AppBar(
          title: const Text("Admin Panel"),
        )
            : null,
        drawer: isMobile
            ? Drawer(
          width: 200,
          // backgroundColor: Colors.blue[50],
          backgroundColor: Colors.white,
          // backgroundColor: AppColors.primaryColor,
          child: sideBar,
        )
            : null,
        body: Row(
          children: [
            isMobile? const SizedBox() : Container(
              // color: Colors.blue[50],
              color: AppColors.primaryColor.withOpacity(0.1),
              // color: AppColors.primaryColor,
              child: sideBar,
            ),
            Expanded(
              child: centerWidget,
            ),
          ],
        ),
      );
    });
  }
}
