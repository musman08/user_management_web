import 'package:flutter/material.dart';
import 'package:um_core/um_core.dart';
import 'package:user_management_web/pages/widgets/tab_item.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({Key? key}) : super(key: key);

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  late Stream<List<UserModel>> stream;
  double gridItemHeight = 130;
  final List<Tab> tabs = [
    const Tab(text: 'Approved'),
    const Tab(text: 'Pending'),
    const Tab(
      text: 'Rejected',
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = UserFirestoreService().fetchAllFirestore();
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
              "Users",
              style: TextStyle(color: Colors.black54),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              late bool isMobile;
              late bool isScrollable;
              final width = constraints.maxWidth;
              if (width < 600) {
                isMobile = true;
                isScrollable = width < 400;
              } else {
                isMobile = false;
                isScrollable = false;
              }
              return SimpleStreamBuilder.simpler(
                stream: stream,
                context: context,
                builder: (data) {
                  final List<UserModel> pending =
                      data.where((e) => e.status == UserAuthorization.pending.name).toList();
                  final List<UserModel> approved =
                      data.where((e) => e.status == UserAuthorization.approved.name).toList();
                  final List<UserModel> rejected = data
                      .where((e) => e.status == UserAuthorization.rejected.name)
                      .toList();

                  return Column(
                    children: [
                      SizedBox(
                        height: kToolbarHeight,
                        width: double.infinity,
                        // Set the width to fill the screen
                        child: TabBar(
                          tabs: tabs,
                          isScrollable: isScrollable,
                        ),
                      ),
                      Expanded(
                          child: TabBarView(
                        children: [
                          PageViewTabItem(
                            dataListOfUserModel: approved,
                            title: 'Approved Requests',
                            isMobile: isMobile,
                            noDataTitle: "approved request",
                            isWorkActivityPage: false,
                            dataListOfDataModel: const [],
                          ),
                          PageViewTabItem(
                            dataListOfUserModel: pending,
                            title: 'Pending Requests',
                            isMobile: isMobile,
                            noDataTitle: "pending request",
                            isWorkActivityPage: false,
                            dataListOfDataModel: const [],
                          ),
                          PageViewTabItem(
                            dataListOfUserModel: rejected,
                            title: 'Rejected Requests',
                            isMobile: isMobile,
                            noDataTitle: "rejected request",
                            isWorkActivityPage: false,
                            dataListOfDataModel: const [],
                          ),
                        ],
                      )),
                    ],
                  );
                },
              );
            },
          )),
    );
  }
}

class UserDetailsItem extends StatelessWidget {
  const UserDetailsItem({Key? key, required this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userModel.name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userModel.email!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (userModel.status! == UserAuthorization.approved.name) ...[
              Align(
                  alignment: Alignment.bottomRight,
                  child: AuthorizationActionButton(
                    title: "Reject",
                    uAuth: UserAuthorization.rejected.name,
                    userModel: userModel,
                  ))
            ] else if (userModel.status! == UserAuthorization.pending.name) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AuthorizationActionButton(
                    title: 'Accept',
                    uAuth: UserAuthorization.approved.name,
                    userModel: userModel,
                  ),
                  AuthorizationActionButton(
                    title: 'Reject',
                    uAuth: UserAuthorization.rejected.name,
                    userModel: userModel,
                  )
                ],
              )
            ] else ...[
              Align(
                alignment: Alignment.bottomRight,
                child: AuthorizationActionButton(
                  title: 'Accept',
                  uAuth: UserAuthorization.approved.name,
                  userModel: userModel,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}

class AuthorizationActionButton extends StatefulWidget {
  AuthorizationActionButton(
      {Key? key,
      required this.userModel,
      required this.uAuth,
      required this.title})
      : super(key: key);

  final UserModel userModel;
  final String uAuth;
  final String title;

  @override
  State<AuthorizationActionButton> createState() => _AuthorizationActionButtonState();
}

class _AuthorizationActionButtonState extends State<AuthorizationActionButton> {
  bool boolCheck = true;

  void confirmation(bool check) {
    boolCheck = check;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (widget.uAuth == UserAuthorization.rejected.name) {
          await ConfirmationDialogWidget(onConfirmation: confirmation).show(context);
        }
        if (boolCheck) {
          try {
            widget.userModel.status = widget.uAuth;
            await UserFirestoreService().updateFirestore(widget.userModel);
            if(!mounted) return;
            AppSnackBar.show(context,
                widget.uAuth == UserAuthorization.approved.name ?
                'User has been accepted successfully' : 'User has been rejected successfully'
            );
          } catch (e) {
            if(!mounted) return;
            const PopUpDialog('Failed. Try Again').show(context);
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Text(
          widget.title,
          style: const TextStyle(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}
