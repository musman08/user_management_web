import 'package:flutter/material.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  const ConfirmationDialogWidget({
    Key ? key,
    required this.onConfirmation,
  }) : super(key: key);

  final void Function(bool check) onConfirmation;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmation'),
      content: const Text('Are you sure you want to proceed?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            onConfirmation(false);
            Navigator.pop(context); // Return false when Cancel is pressed
          },
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            onConfirmation(true);
            Navigator.pop(context); // Return true when OK is pressed
          },
        ),
      ],
    );
  }
  Future<void> show(BuildContext context) async{
    await showDialog(context: context, builder: (_) => this);
  }
}