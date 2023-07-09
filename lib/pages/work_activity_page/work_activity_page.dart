import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:um_core/um_core.dart';
import 'package:intl/intl.dart';
import 'package:user_management_web/utils/date_range_picker.dart';

import '../widgets/filters.dart';

class WorkActivitiesPage extends StatefulWidget {
  const WorkActivitiesPage({Key? key,}) : super(key: key);

  @override
  State<WorkActivitiesPage> createState() => _WorkActivitiesPageState();
}

class _WorkActivitiesPageState extends State<WorkActivitiesPage> {

  double gridItemHeight = 200;
  DateTimeRange ? dateTimeRange;
  DateTime ? dateTime;
  String ? userId;


  final List<Tab> tabs = [
    const Tab(text: 'Approved'),
    const Tab(text: 'Pending'),
    const Tab(text: 'Rejected'),
    const Tab(text: 'Change Request'),
  ];
  void selectedFilters(
      String? userId, DateTime? dateTime,
      DateTimeRange? dateTimeRange, UserModel ? user){
    this.userId = userId;
    this.dateTime = dateTime;
    this.dateTimeRange = dateTimeRange;
    setState(() { });
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
            bottom: TabBar(
                tabs: tabs,
              // isScrollable: true,
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              FiltersWidget(filters: selectedFilters),
              Expanded(
                child: SimpleStreamBuilder.simpler(
                  stream:
                  AddWorkActivityFirestoreService().fetchAllFirestore(),
                  context: context,
                  builder: (data) {
                    if(userId != null){
                      data = data.where((e) => e.userId == userId).toList();
                    }
                    if(dateTime != null){
                      data = data.where((e){
                        final parsedDate = DateFormat('dd-MM-yyyy').parse(e.dateAndTime!);
                        if(parsedDate == dateTime){
                          return true;
                        }else{
                          return false;
                        }
                      } ).toList();
                    }
                    if(dateTimeRange != null){
                      data = data.where((e){
                        final parsedDate = DateFormat('dd-MM-yyyy').parse(e.dateAndTime!);
                        print(parsedDate);
                        DateTime updatedEndDate = dateTimeRange!.end.add(const Duration(days: 1));
                        DateTime updatedStartDate = dateTimeRange!.start.subtract(const Duration(days: 1));
                        if(
                        parsedDate.isAfter(updatedStartDate) &&
                            parsedDate.isBefore(updatedEndDate)
                        ){
                          return true;
                        }else{
                          return false;
                        }
                      } ).toList();
                    }
                    final List<AddDataModel> approved =
                    data.where((e) => e.status == UserAuthorization.approved.name).toList();
                    final List<AddDataModel> pending =
                    data.where((e) => e.status == UserAuthorization.pending.name).toList();
                    final List<AddDataModel> rejected =
                    data.where((e) => e.status == UserAuthorization.rejected.name).toList();
                    final List<AddDataModel> changeRequest =
                    data.where((e) => e.status == UserAuthorization.changeRequest.name).toList();
                    return WorkActivityPageView(
                        pending: pending,
                        approved: approved,
                        rejected: rejected,
                      changeRequest: changeRequest
                    ) ;
                  },
                ),
              )
            ],
          ),
        ),
      );
  }
}

class WorkActivityPageView extends StatelessWidget {
  const WorkActivityPageView({Key? key,
    required this.pending,
    required this.approved,
    required this.rejected,
    this.changeRequest,
  }) : super(key: key);

  final List<AddDataModel> pending;
  final List<AddDataModel> approved;
  final List<AddDataModel> rejected;
  final List<AddDataModel> ? changeRequest;
  final double gridItemHeight = 200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      late bool isMobile;
      if (constraints.maxWidth < 600) {
        isMobile = true;
      } else {
        isMobile = false;
      }
      return TabBarView(
        children: [
          PageViewTabItem(
              dataList: approved,
              title: 'Approved Activities',
              isMobile: isMobile,
              noDataTitle: "approved" ),
          PageViewTabItem(
              dataList: pending,
              title: 'Pending Activities',
              isMobile: isMobile,
              noDataTitle: "pending" ),
          PageViewTabItem(
              dataList: rejected,
              title: 'Rejected Activities',
              isMobile: isMobile,
              noDataTitle: "rejected" ),
          PageViewTabItem(
              dataList: changeRequest!,
              title: 'Change Request Activities',
              isMobile: isMobile,
              noDataTitle: "change request" ),
        ],
      );
    });
  }
}

class PageViewTabItem extends StatelessWidget {
  const PageViewTabItem({
    Key? key,
    required this.dataList,
    required this.title,
    required this.noDataTitle,
    required this.isMobile,
  }) : super(key: key);

  final List<AddDataModel> dataList;
  final String title;
  final String noDataTitle;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    double gridItemHeight = 200;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            title: title,
            color: AppColors.primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 20,
          ),
          if (dataList.isEmpty) ...[
            Expanded(
                child: Center(
                  child: Text("Not any $noDataTitle activity yet"),
                ))
          ] else ...[
            Expanded(
              child: GridView.builder(
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    mainAxisExtent: gridItemHeight
                ),
                shrinkWrap: true,
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                    const EdgeInsets.only(bottom: 20),
                    child: WorkActivityItem(
                      dataModel: dataList[index],
                      isAdminPanel: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}




