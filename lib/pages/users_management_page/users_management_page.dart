import 'package:flutter/material.dart';
import 'package:um_core/um_core.dart';
import 'package:user_management_web/widgets/confirmation_dialog.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({Key? key}) : super(key: key);

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  late bool isMobile;
  double gridItemHeight = 130;
  final List<Tab> tabs = [
    const Tab(text: 'Approved'),
    const Tab(text: 'Pending'),
    const Tab(text: 'Rejected',)
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            title: const Text("Users", style: TextStyle(color: Colors.black54),),
            bottom: TabBar(
                tabs: tabs,
              // isScrollable: true,
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints ){
              if(constraints.maxWidth < 600){
                isMobile = true;
              }else{
                isMobile = false;
              }
              return SimpleStreamBuilder.simpler(
                stream:  UserFirestoreService().fetchAllFirestore(),
                context: context,
                builder: (data){
                  final List<UserModel> pending =
                  data.where((e) => e.status == 'pending').toList();
                  final List<UserModel> approved =
                  data.where((e) => e.status == "approved").toList();
                  final List<UserModel> rejected =
                  data.where((e)=> e.status == UserAuthorization.rejected.name).toList();

                  return TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20,),
                            const TextWidget(
                              title: 'Approved Requests',
                              color: AppColors.primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 20,),
                            if(approved.isEmpty)...[
                              const Expanded(
                                  child: Center(
                                    child: Text("Not any approved yet!!!"),
                                  ))
                            ]else...[
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: isMobile ? 2 : 3, // Number of columns in the grid
                                      mainAxisSpacing: 8.0, // Spacing between rows
                                      crossAxisSpacing: 8.0, // Spacing between columns
                                      mainAxisExtent: gridItemHeight
                                    // childAspectRatio: 4, // Ratio of item's width to its height
                                  ),
                                  itemCount:  approved.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.only(bottom: 20),
                                        child: UserDetailsItem(
                                          userModel: approved[index],
                                          // email: approved[index].email!,
                                          // status: approved[index].status!,
                                          // name: approved[index].name!,
                                        )
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20,),
                            const TextWidget(title: 'Pending Requests',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(height: 20,),
                            if(pending.isEmpty)...[
                              const Expanded(child: Center(
                                child: Text("No pending Activity."),
                              ),)
                            ]else...[
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: isMobile ? 2: 3, // Number of columns in the grid
                                      mainAxisSpacing: 8.0, // Spacing between rows
                                      crossAxisSpacing: 8.0, // Spacing between columns
                                      mainAxisExtent: gridItemHeight
                                    // childAspectRatio: 4, // Ratio of item's width to its height
                                  ),
                                  itemCount: pending.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.only(bottom: 20),
                                        child: UserDetailsItem(
                                          userModel: pending[index],
                                          // email: pending[index].email!,
                                          // status: pending[index].status!,
                                          // name: pending[index].name!,
                                        )
                                    );
                                  },
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20,),
                            const TextWidget(
                              title: 'Rejected Requests',
                              color: AppColors.primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 20,),
                            if(rejected.isEmpty)...[
                              const Expanded(
                                  child: Center(
                                    child: Text("Not any rejected activity yet"),
                                  ))
                            ]else...[
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: isMobile ? 2 : 3, // Number of columns in the grid
                                      mainAxisSpacing: 8.0, // Spacing between rows
                                      crossAxisSpacing: 8.0, // Spacing between columns
                                      mainAxisExtent: gridItemHeight
                                  ),
                                  itemCount:  rejected.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.only(bottom: 20),
                                        child: UserDetailsItem(
                                          userModel: rejected[index],
                                        )
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          )
      ),
    );
  }
}




class UserDetailsItem extends StatelessWidget {
  const UserDetailsItem({
    Key? key,
    required this.userModel
  }) : super(key: key);

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
            if(userModel.status! == UserAuthorization.approved.name)...[
              Align(
                alignment: Alignment.bottomRight,
                child: AuthorizationActionButton(
                  title: "Reject",
                  uAuth:  UserAuthorization.rejected.name,
                  userModel: userModel,
                )
              )
            ]else if(userModel.status! == UserAuthorization.pending.name)...[
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
            ]else...[
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

class AuthorizationActionButton extends StatelessWidget {
  AuthorizationActionButton({
    Key? key,
    required this.userModel,
    required this.uAuth,
    required this.title
  }) : super(key: key);

  final UserModel userModel;
  final String uAuth;
  final String title;

  bool boolCheck = false;
  void confirmation(bool check){
    boolCheck = check;
  }


  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async{
        if(uAuth == UserAuthorization.rejected.name){
          await ConfirmationDialogWidget(onConfirmation: confirmation).show(context);
          if(boolCheck){
            try{
              userModel.status = uAuth;
              await UserFirestoreService().updateFirestore(userModel);
            }catch(e){
              const PopUpDialog( 'Failed. Try Again').show(context);
            }
          }
        }else{
          try{
            userModel.status = uAuth;
            await UserFirestoreService().updateFirestore(userModel);
          }catch(e){
            const PopUpDialog( 'Failed. Try Again').show(context);
          }
        }
      },
      child:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Text(title, style: const TextStyle(color: AppColors.primaryColor),),
      ),
    );
  }
}
