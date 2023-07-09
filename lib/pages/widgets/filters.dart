import 'package:flutter/material.dart';
import 'package:um_core/um_core.dart';
import 'package:user_management_web/utils/date_range_picker.dart';

class FiltersWidget extends StatefulWidget {
  const FiltersWidget({Key? key, required this.filters}) : super(key: key);

  final void Function(
      String ? userId,
      DateTime ? dateTime,
      DateTimeRange ? dateTimeRange,
      UserModel ? selectedUser
      ) filters;
  @override
  State<FiltersWidget> createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends State<FiltersWidget> {

  DateTimeRange ? dateTimeRange;
  DateTime ? dateTime;
  String ? userId;
  UserModel ? selectedUser;
  TextEditingController dateController = TextEditingController();


  void onSelectedDate(DateTime ? dateTime, DateTimeRange ? dateTimeRange, String date){
    dateController.text = date;
    this.dateTime = dateTime;
    this.dateTimeRange = dateTimeRange;
    if(!mounted) return;
    const DatePickerDialogBox().pop(context);
    setState(() { });
    widget.filters(userId, dateTime, dateTimeRange, selectedUser);
  }

  void clear(){
    dateTime = null;
    dateTimeRange = null;
    dateController.clear();
    userId = null;
    selectedUser = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SimpleStreamBuilder.simpler(
        stream: UserFirestoreService().fetchAllFirestore(),
        context: context,
        noLoadingChild: true,
        builder: (data) {
          return Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 10,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: SizedBox(
                        width: 250,
                        child: AppTextField(
                          textEditingController: dateController,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          hint: 'Select Date',
                          readonly: true,
                          onTap: () => DatePickerDialogBox(onSelectedDate: onSelectedDate).show(context),
                          suffix: const Icon(
                            Icons.calendar_month,
                            color: AppColors.primaryColor,),
                        ),
                      ),
                    )
                    ,),
                  const SizedBox(width: 10,),
                  Flexible(child: SizedBox(width: 250,
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      value: selectedUser,
                      items: data.map((e){
                        return DropdownMenuItem<UserModel>(
                            value: e,
                            child: Text(
                              e.name!,
                              overflow: TextOverflow.ellipsis,
                            )
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        hintText: "Select User",
                        labelText: 'User',
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                      onChanged: (v){
                        selectedUser =  v;
                        userId = v?.userId;
                        setState(() { });
                        widget.filters(userId, dateTime, dateTimeRange, selectedUser);
                      },
                    ),
                  )),
                  if(userId != null || dateTime != null || dateTimeRange != null)...[
                    const SizedBox(width: 10),
                    Flexible(
                        child: SizedBox(
                          width: 100,
                          child:
                          AppElevatedButton(
                            onPressed: clear,
                            isFullWidth: false,
                            child: const Text('Clear Filters'),
                          ),
                        )
                    )
                  ],
                ],
              )
          );
        });
  }
}
