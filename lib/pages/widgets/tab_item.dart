import 'package:flutter/material.dart';
import 'package:um_core/um_core.dart';
import 'package:user_management_web/pages/users_management_page/users_management_page.dart';

class PageViewTabItem extends StatelessWidget {
  const PageViewTabItem({
    Key? key,
    this.dataListOfDataModel,
    this.dataListOfUserModel,
    required this.title,
    required this.noDataTitle,
    required this.isMobile,
    required this.isWorkActivityPage,
  }) : super(key: key);

  final List<AddDataModel> ? dataListOfDataModel;
  final List<UserModel> ? dataListOfUserModel;
  final String title;
  final String noDataTitle;
  final bool isMobile;
  final bool isWorkActivityPage;

  @override
  Widget build(BuildContext context) {
    double gridItemHeight = isWorkActivityPage ? 200 : 130;
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
          if (dataListOfDataModel!.isEmpty && dataListOfUserModel!.isEmpty ) ...[
            Expanded(
                child: Center(
                  child: TextWidget(
                    title: "Not any $noDataTitle yet",
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,

                  ),
                ))
          ] else ...[
            Expanded(
              child: GridView.builder(
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWorkActivityPage ? isMobile ? 1 : 2 : isMobile ? 2 : 3,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    mainAxisExtent: gridItemHeight
                ),
                shrinkWrap: true,
                itemCount: isWorkActivityPage ? dataListOfDataModel!.length : dataListOfUserModel!.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding:
                      const EdgeInsets.only(bottom: 20),
                      child: isWorkActivityPage ? WorkActivityItem(
                        dataModel: dataListOfDataModel![index],
                        isAdminPanel: true,
                      ) : UserDetailsItem(
                        userModel: dataListOfUserModel![index],
                      )
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