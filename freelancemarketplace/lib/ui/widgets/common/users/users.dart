import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freelancemarketplace/ui/common/customwidget/button_helper.dart';
import 'package:stacked/stacked.dart';

import '../../../common/apihelper/apihelper.dart';
import '../../../common/app_colors.dart';
import '../../../common/customwidget/snakbar_helper.dart';
import '../../../common/customwidget/text_helper.dart';
import '../../../common/ui_helpers.dart';
import 'users_model.dart';

class Users extends StackedView<UsersModel> {
  Users({super.key, this.all = false});
  bool all;

  @override
  Widget builder(
    BuildContext context,
    UsersModel viewModel,
    Widget? child,
  ) {
    return FutureBuilder(
      future: ApiHelper.allusers(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.toString() == '[]') {
            return const SizedBox.shrink();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                if (snapshot.data[index]["cat"] == "freelancer") {
                  if (!all) {
                    if (snapshot.data[index]["status"] == "false") {
                      return listdata(context, index, snapshot);
                    } else {
                      return const SizedBox.shrink();
                    }
                  } else {
                    return listdata(context, index, snapshot);
                  }
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          }
        } else if (snapshot.hasError) {
          return const Icon(
            Icons.error,
          );
        } else {
          return displaysimpleprogress(context);
        }
      },
    );
  }

  Widget listdata(BuildContext context, int index, AsyncSnapshot snapshot) {
    return Container(
      width: screenWidth(context),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: getColorWithOpacity(Colors.grey, 0.1)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              imageUrl: snapshot.data[index]["img"],
              imageBuilder: (context, imageProvider) => Container(
                width: screenWidthCustom(context, 0.15),
                height: screenWidthCustom(context, 0.15),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => displaysimpleprogress(context),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
              ),
            ),
          ),
          horizontalSpaceSmall,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              text_helper(
                data: snapshot.data[index]["name"],
                fontWeight: FontWeight.bold,
                size: fontSize18,
                color: Theme.of(context).primaryColor,
              ),
              verticalSpaceSmall,
              text_helper(
                data: snapshot.data[index]["email"],
                size: fontSize12,
                textAlign: TextAlign.start,
              ),
              text_helper(
                data: snapshot.data[index]["number"],
                size: fontSize12,
                textAlign: TextAlign.start,
              ),
              verticalSpaceSmall,
              !all
                  ? button_helper(
                      onpress: () async {
                        displayprogress(context);
                        await ApiHelper.statususerchange(
                            snapshot.data[index]["_id"], "true");
                        hideprogress(context);
                        Navigator.pop(context);
                      },
                      child: text_helper(data: "Approve Freelancer"))
                  : Row(
                      children: [
                        snapshot.data[index]["status"] == "true"
                            ? button_helper(
                                onpress: () async {
                                  displayprogress(context);
                                  await ApiHelper.statususerchange(
                                      snapshot.data[index]["_id"], "false");
                                  hideprogress(context);
                                  Navigator.pop(context);
                                },
                                child: text_helper(data: "Suspend Freelancer"))
                            : button_helper(
                                onpress: () async {
                                  displayprogress(context);
                                  await ApiHelper.statususerchange(
                                      snapshot.data[index]["_id"], "true");
                                  hideprogress(context);
                                  Navigator.pop(context);
                                },
                                child: text_helper(data: "Active Freelancer")),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  UsersModel viewModelBuilder(
    BuildContext context,
  ) =>
      UsersModel();
}
