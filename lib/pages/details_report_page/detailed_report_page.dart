import 'package:flutter/material.dart';
import 'package:um_core/um_core.dart';
import 'package:intl/intl.dart';
import 'package:user_management_web/pages/widgets/filters.dart';

class DetailedReportPage extends StatefulWidget {
  const DetailedReportPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DetailedReportPage> createState() => _DetailedReportPageState();
}

class _DetailedReportPageState extends State<DetailedReportPage> {
  double gridItemHeight = 200;
  DateTimeRange? dateTimeRange;
  DateTime? dateTime;
  String? userId;
  UserModel? selectedUser;
  late List<String?> daysList;
  late Stream<List<AddDataModel>> stream;

  List<String?> conversion(List<String?> days) {
    final List<DateTime?> daysListForSorting =
        days.map((e) => DateFormat('dd-MM-yyyy').parse(e!)).toList();
    daysListForSorting.sort();
    return daysListForSorting
        .map((e) => DateFormat('dd-MM-yyyy').format(e!))
        .toList();
  }

  void selectedFilters(String? userId, DateTime? dateTime,
      DateTimeRange? dateTimeRange, UserModel? selectedUser) {
    this.userId = userId;
    this.dateTime = dateTime;
    this.dateTimeRange = dateTimeRange;
    this.selectedUser = selectedUser;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = AddWorkActivityFirestoreService().fetchAllFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Report Page",
          style: TextStyle(color: Colors.black54),
        ),
      ),
      body:
      LayoutBuilder(builder: (context, constraints) {
        late bool isMobile;
        if (constraints.maxWidth < 600) {
          isMobile = true;
        } else {
          isMobile = false;
        }
        return
          Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            FiltersWidget(
              filters: selectedFilters,
              isMobile: isMobile,
            ),
            Expanded(
              child: SimpleStreamBuilder.simpler(
                stream: stream,
                context: context,
                builder: (data) {
                  if (userId != null) {
                    data = data.where((e) => e.userId == userId).toList();
                  }
                  if (dateTime != null) {
                    data = data.where((e) {
                      final parsedDate =
                          DateFormat('dd-MM-yyyy').parse(e.dateAndTime!);
                      if (parsedDate == dateTime) {
                        return true;
                      } else {
                        return false;
                      }
                    }).toList();
                  }
                  if (dateTimeRange != null) {
                    data = data.where((e) {
                      final parsedDate =
                          DateFormat('dd-MM-yyyy').parse(e.dateAndTime!);
                      print(parsedDate);
                      DateTime updatedEndDate =
                          dateTimeRange!.end.add(const Duration(days: 1));
                      DateTime updatedStartDate = dateTimeRange!.start
                          .subtract(const Duration(days: 1));
                      if (parsedDate.isAfter(updatedStartDate) &&
                          parsedDate.isBefore(updatedEndDate)) {
                        return true;
                      } else {
                        return false;
                      }
                    }).toList();
                  }
                  daysList = data.map((e) => e.dateAndTime).toSet().toList();
                  daysList = conversion(daysList);
                  final List<AddDataModel> approved = data
                      .where((e) => e.status == UserAuthorization.approved.name)
                      .toList();
                  final List<AddDataModel> pending = data
                      .where((e) => e.status == UserAuthorization.pending.name)
                      .toList();
                  final List<AddDataModel> rejected = data
                      .where((e) => e.status == UserAuthorization.rejected.name)
                      .toList();
                  final List<AddDataModel> changeRequest = data
                      .where((e) =>
                          e.status == UserAuthorization.changeRequest.name)
                      .toList();
                  if (userId == null) {
                    return const Center(
                        child: TextWidget(
                      title: 'Select user to see the report',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ));
                  } else {
                    return DetailedReportPageView(
                      approved: approved,
                      pending: pending,
                      rejected: rejected,
                      userModel: selectedUser!,
                      changeRequest: changeRequest,
                      dateList: daysList,
                      // isMobile: isMobile,
                    );
                  }
                },
              ),
            )
          ],
        );
      }
      ),
    );
  }
}

class DetailedReportPageView extends StatelessWidget {
  const DetailedReportPageView(
      {Key? key,
      required this.pending,
      required this.approved,
      required this.rejected,
      required this.userModel,
      required this.changeRequest,
      required this.dateList,
      // required this.isMobile
      })
      : super(key: key);

  final List<AddDataModel> pending;
  final List<AddDataModel> approved;
  final List<AddDataModel> rejected;
  final List<AddDataModel> changeRequest;
  final UserModel userModel;
  final List<String?> dateList;
  // final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Center(
          child: LayoutBuilder(builder: (context, constraints){
            bool isMobile;
            if(constraints.maxWidth < 600){
              isMobile = true;
            }else{
              isMobile = false;
            }
            return Row(
              children: [
                Expanded(
                    child: SizedBox(
                      height: 400,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Stack(children: [
                                    if (userModel.profilePicture != null) ...[
                                      CircleAvatar(
                                        backgroundImage:
                                        NetworkImage(userModel.profilePicture!),
                                        minRadius: 50,
                                        maxRadius: 50,
                                      ),
                                    ] else ...[
                                      const CircleAvatar(
                                        backgroundColor: Colors.white,
                                        minRadius: 50,
                                        maxRadius: 50,
                                        child: Icon(
                                          Icons.person,
                                          size: 75,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                    Positioned(
                                        bottom: 4,
                                        right: 4,
                                        child: userModel.status ==
                                            UserAuthorization.approved.name
                                            ? const VerifiedIcon()
                                            : userModel.status ==
                                            UserAuthorization.rejected.name
                                            ? const RejectedIcon()
                                            : const PendingIcon()),
                                  ]),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextWidget(
                                    title: userModel.name!,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextWidget(
                                    title: userModel.email!,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  TextWidget(
                                    title:
                                    'Approved Activities: ${approved.length.toString()}',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextWidget(
                                    title:
                                    'Pending Activities: ${pending.length.toString()}',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextWidget(
                                    title:
                                    'Rejected Activities: ${rejected.length.toString()}',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextWidget(
                                    title:
                                    'Change Request Activities: ${changeRequest.length.toString()}',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  if (isMobile) ...[
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    SecondColumn(
                                        dateList: dateList, isMobile: isMobile)
                                  ]
                                ],
                              ),
                            )),
                      ),
                    )),
                if (!isMobile) ...[
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: SizedBox(
                        height: 400,
                        child: Card(
                          elevation: 5,
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: SecondColumn(
                                dateList: dateList,
                                isMobile: isMobile,
                              )),
                        ),
                      ))
                ]
              ],
            );
          },)
        ));
  }
}

class SecondColumn extends StatelessWidget {
  const SecondColumn({Key? key, required this.dateList, required this.isMobile})
      : super(key: key);
  final List<String?> dateList;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            title: "Total Days Worked: ${dateList.length.toString()}",
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          if (dateList.isEmpty) ...[
            const Align(
              alignment: Alignment.center,
              child: Text('No work Activity in selected days'),
            )
          ] else ...[
            ListView.builder(
                shrinkWrap: true,
                itemCount: dateList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dateList[index]!),
                  );
                })
          ]
        ],
      ),
    );
  }
}
