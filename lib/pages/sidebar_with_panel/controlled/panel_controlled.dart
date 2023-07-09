import 'package:flutter/material.dart';
import 'package:reusables/reusables.dart';

import '../controllers/panel_and_sidebar_controller.dart';


class PanelControlledWidget extends ControlledWidget<SideBarMenuController> {
  const PanelControlledWidget({
    Key? key,
    required this.myController,
  }) : super(key: key, controller: myController);
  final SideBarMenuController myController;

  @override
  State<PanelControlledWidget> createState() => _PanelControlledWidgetState();
}

class _PanelControlledWidgetState extends State<PanelControlledWidget>
    with ControlledStateMixin {
  @override
  Widget build(BuildContext context) {
    return widget.myController.mainPageWidget;
  }
}
