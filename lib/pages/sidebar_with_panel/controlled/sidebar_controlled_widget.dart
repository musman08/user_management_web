import 'package:flutter/material.dart';
import 'package:reusables/reusables.dart';
import 'package:user_management_web/pages/sidebar_with_panel/widgets/sidebar.dart';
import 'package:user_management_web/pages/sidebar_with_panel/controllers/panel_and_sidebar_controller.dart';


class SideBarMenuControlledWidget extends ControlledWidget<SideBarMenuController> {
  const SideBarMenuControlledWidget({
    Key? key,
    required this.myController,
  }) : super(key: key, controller: myController);
  final SideBarMenuController myController;

  @override
  State<SideBarMenuControlledWidget> createState() =>
      _SideBarMenuControlledWidgetState();
}

class _SideBarMenuControlledWidgetState
    extends State<SideBarMenuControlledWidget> with ControlledStateMixin {
  @override
  Widget build(BuildContext context) {
    return SideBar(
      selectedValue: widget.myController.localSelectedValue,
      myController: widget.myController,
    );
  }
}
