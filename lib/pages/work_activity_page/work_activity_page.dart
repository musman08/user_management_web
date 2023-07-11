import 'package:flutter/material.dart';
import 'package:um_core/um_core.dart';
import 'package:intl/intl.dart';
import 'package:user_management_web/pages/widgets/filters.dart';
import 'package:user_management_web/pages/widgets/tab_item.dart';

class WorkActivitiesPage extends StatefulWidget {
  const WorkActivitiesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<WorkActivitiesPage> createState() => _WorkActivitiesPageState();
}

class _WorkActivitiesPageState extends State<WorkActivitiesPage> {
  double gridItemHeight = 200;
  DateTimeRange? dateTimeRange;
  DateTime? dateTime;
  String? userId;

  late Stream<List<AddDataModel>> stream;

  @override
  void initState() {
    super.initState();
    stream = AddWorkActivityFirestoreService().fetchAllFirestore();
  }

  final List<Tab> tabs = [
    const Tab(text: 'Approved'),
    const Tab(text: 'Pending'),
    const Tab(text: 'Rejected'),
    const Tab(text: 'Change Request'),
  ];

  void selectedFilters(String? userId, DateTime? dateTime,
      DateTimeRange? dateTimeRange, UserModel? user) {
    this.userId = userId;
    this.dateTime = dateTime;
    this.dateTimeRange = dateTimeRange;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: const Text(
            "Work Activities",
            style: TextStyle(color: Colors.black54),
          ),
        ),
        body:
            LayoutBuilder(builder: (context, constraints){
              late bool isMobile;
              late bool isScrollable;
              final width = constraints.maxWidth;
              print(width);
            if(width < 600){
              isMobile = true;
              isScrollable = width < 550;
            }else{
              isMobile = false;
              isScrollable = false;
            }
            return
            Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: kToolbarHeight,
              width: double.infinity,
              child: TabBar(
                tabs: tabs,
                isScrollable: isScrollable,
              ),
            ),
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
                  return WorkActivityPageView(
                    pending: pending,
                    approved: approved,
                    rejected: rejected,
                    changeRequest: changeRequest,
                    isMobile: isMobile,
                  );
                },
              ),
            )
          ],
        );
        } ,)
      ),
    );
  }
}

class WorkActivityPageView extends StatelessWidget {
  const WorkActivityPageView(
      {Key? key,
      required this.pending,
      required this.approved,
      required this.rejected,
      this.changeRequest,
      required this.isMobile})
      : super(key: key);

  final List<AddDataModel> pending;
  final List<AddDataModel> approved;
  final List<AddDataModel> rejected;
  final List<AddDataModel>? changeRequest;
  final bool isMobile;
  final double gridItemHeight = 200;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        PageViewTabItem(
          dataListOfDataModel: approved,
          title: 'Approved Activities',
          isMobile: isMobile,
          noDataTitle: "approved",
          isWorkActivityPage: true,
          dataListOfUserModel: const [],
        ),
        PageViewTabItem(
          dataListOfDataModel: pending,
          title: 'Pending Activities',
          isMobile: isMobile,
          noDataTitle: "pending activities",
          isWorkActivityPage: true,
          dataListOfUserModel: const [],
        ),
        PageViewTabItem(
          dataListOfDataModel: rejected,
          title: 'Rejected Activities',
          isMobile: isMobile,
          noDataTitle: "rejected activities",
          isWorkActivityPage: true,
          dataListOfUserModel: const [],
        ),
        PageViewTabItem(
          dataListOfDataModel: changeRequest!,
          title: 'Change Request Activities',
          isMobile: isMobile,
          noDataTitle: "change request activities",
          isWorkActivityPage: true,
          dataListOfUserModel: const [],
        ),
      ],
    );
  }
}

// class PageViewTabItem extends StatelessWidget {
//   const PageViewTabItem({
//     Key? key,
//     this.dataListOfDataModel,
//     this.dataListOfUserModel,
//     required this.title,
//     required this.noDataTitle,
//     required this.isMobile,
//     required this.isWorkActivityPage,
//   }) : super(key: key);
//
//   final List<AddDataModel> ? dataListOfDataModel;
//   final List<UserModel> ? dataListOfUserModel;
//   final String title;
//   final String noDataTitle;
//   final bool isMobile;
//   final bool isWorkActivityPage;
//
//   @override
//   Widget build(BuildContext context) {
//     double gridItemHeight = 200;
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextWidget(
//             title: title,
//             color: AppColors.primaryColor,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           if (dataListOfDataModel== null && dataListOfUserModel == null ) ...[
//             Expanded(
//                 child: Center(
//                   child: Text("Not any $noDataTitle activity yet"),
//                 ))
//           ] else ...[
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate:
//                 SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: isWorkActivityPage ? isMobile ? 1 : 2 : isMobile ? 2 : 3,
//                     mainAxisSpacing: 8.0,
//                     crossAxisSpacing: 8.0,
//                     mainAxisExtent: gridItemHeight
//                 ),
//                 shrinkWrap: true,
//                 itemCount: isWorkActivityPage ? dataListOfDataModel!.length : dataListOfUserModel!.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding:
//                     const EdgeInsets.only(bottom: 20),
//                     child: isWorkActivityPage ? WorkActivityItem(
//                       dataModel: dataListOfDataModel![index],
//                       isAdminPanel: true,
//                     ) : UserDetailsItem(
//                       userModel: dataListOfUserModel![index],
//                     )
//                   );
//                 },
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
