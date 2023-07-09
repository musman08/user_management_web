import 'package:flutter/material.dart';
import 'package:um_core/um_core.dart';
import 'package:intl/intl.dart';

class DatePickerDialogBox extends StatelessWidget {
  const DatePickerDialogBox({
    Key? key,
    this.onSelectedDate}) : super(key: key);

  final void Function(
      DateTime ? dateTime,
      DateTimeRange ? dateTimeRange,
      String date,
      ) ? onSelectedDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Date'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Choose one of the following'),
          const SizedBox(height: 20),
          AppElevatedButton(
            onPressed: () async {
              final result = await showDatePicker(
                context: context,
                initialDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: DatePickerTheme.datePickerTheme,
                    child: child!,
                  );
                },
              );
              if(result!= null){
                String date = DateFormat('dd-MM-yyyy').format(result);
                onSelectedDate!(result, null, date );
              }
            },
            isFullWidth: true,
            backgroundColor: AppColors.primaryColor.withOpacity(0.6),
            child: const Text('Single Day'),
          ),
          const SizedBox(height: 10,),
          AppElevatedButton(
            onPressed: () async {
              final result = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                currentDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
                builder: (context, child) {
                  return Theme(
                    data: DatePickerTheme.datePickerTheme,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 350, maxHeight: 500),
                        child: child!,
                      ),
                    ),
                  );
                },
              );
              if(result != null){
                String startDate = DateFormat('dd-MM-yyyy').format(result.start);
                String endDate = DateFormat('dd-MM-yyyy').format(result.end);
                String date = '$startDate - $endDate';
                onSelectedDate!(null, result ,date,);
              }
            },
            isFullWidth: true,
            backgroundColor: AppColors.primaryColor.withOpacity(0.6),
            child: const Text('Date Range'),
          ),
        ],
      ),
    );
  }
  void show(BuildContext context) {
    showDialog(context: context, builder: (_) => this);
  }

  void pop(BuildContext context){
    Navigator.pop(context);
  }

}