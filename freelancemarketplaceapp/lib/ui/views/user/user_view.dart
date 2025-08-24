import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freelancemarketplace/app/app.dart';
import 'package:stacked/stacked.dart';

import '../../common/apihelper/apihelper.dart';
import '../../common/apihelper/firebsaeuploadhelper.dart';
import '../../common/app_colors.dart';
import '../../common/customwidget/button_helper.dart';
import '../../common/customwidget/snakbar_helper.dart';
import '../../common/customwidget/text_helper.dart';
import '../../common/ui_helpers.dart';
import 'CallPage.dart';
import 'user_viewmodel.dart';

class UserView extends StackedView<UserViewModel> {
  const UserView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    UserViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: text_helper(
            data: "Video Call",
            color: white,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: text_helper(
                  data: "Incoming Calls",
                  fontWeight: FontWeight.bold,
                  size: fontSize18,
                ),
              ),
            ),
            SizedBox(
              width: screenWidth(context),
              height: 160,
              child: FutureBuilder(
                future: ApiHelper.allvideo(context),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.toString() == '[]') {
                      return const SizedBox.shrink();
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (snapshot.data[index]["uid"] ==
                              viewModel.sharedpref.readString("email")) {
                            DateTime parsedDate =
                                DateTime.parse(snapshot.data[index]["date"]);
                            DateTime modifiedDate =
                                parsedDate.add(Duration(minutes: 10));
                            if (DateTime.now().isBefore(modifiedDate)) {
                              return listdatavideo(
                                  context, index, snapshot, viewModel);
                            } else {
                              return const SizedBox.shrink();
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
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: text_helper(
                  data: "All Users",
                  fontWeight: FontWeight.bold,
                  size: fontSize18,
                ),
              ),
            ),
            Expanded(
                child: FutureBuilder(
              future: ApiHelper.allusers(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.toString() == '[]') {
                    return const SizedBox.shrink();
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (snapshot.data[index]["status"] != "false") {
                          if (snapshot.data[index]["email"] !=
                              viewModel.sharedpref.readString("email")) {
                            return listdata(
                                context, index, snapshot, viewModel);
                          } else {
                            return const SizedBox.shrink();
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
            ))
          ],
        )));
  }

  Widget listdatavideo(BuildContext context, int index, AsyncSnapshot snapshot,
      UserViewModel viewModel) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CallPage(
                  callID: "123",
                  userID: viewModel.sharedpref.readString("email"),
                  userName: viewModel.sharedpref.readString("name"),
                ),
              ));
        },
        child: Container(
          width: screenWidthCustom(context, 0.5),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: ApiHelper.findone(snapshot.data[index]['tid']),
                  builder: (BuildContext context, AsyncSnapshot snapshot2) {
                    if (snapshot2.hasData) {
                      if (snapshot2.data.toString() == '[]') {
                        return const SizedBox.shrink();
                      } else {
                        return Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: snapshot2.data["img"],
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: screenWidthCustom(context, 0.05),
                                  height: screenWidthCustom(context, 0.05),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    displaysimpleprogress(context),
                                errorWidget: (context, url, error) =>
                                    const Icon(
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
                                  data: snapshot2.data["name"],
                                  fontWeight: FontWeight.bold,
                                  size: fontSize12,
                                  color: white,
                                ),
                                text_helper(
                                  data: snapshot2.data["number"],
                                  size: fontSize10,
                                  textAlign: TextAlign.start,
                                  color: white,
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    } else if (snapshot2.hasError) {
                      return const Icon(
                        Icons.error,
                      );
                    } else {
                      return displaysimpleprogress(context);
                    }
                  },
                ),
                verticalSpaceSmall,
                text_helper(
                  data:
                      snapshot.data[index]['date'].toString().substring(0, 10),
                  color: white,
                  size: fontSize10,
                ),
                text_helper(
                  data:
                      snapshot.data[index]['date'].toString().substring(10, 19),
                  color: white,
                  size: fontSize10,
                ),
                verticalSpaceSmall,
                const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.call,
                    color: white,
                    size: 20,
                  ),
                )
              ]),
        ));
  }

  Widget listdata(BuildContext context, int index, AsyncSnapshot snapshot,
      UserViewModel viewModel) {
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
              Row(
                children: [
                  button_helper(
                      onpress: () async {

                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(), // Defaults to today
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2026),
                        );

                        if (date == null) return;

                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (time == null) return;

                        final DateTime combined = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );

                        displayprogress(context);
                        await ApiHelper.registervideo(
                            viewModel.sharedpref.readString("email"),
                            snapshot.data[index]["email"],
                            combined.toString(),
                            context);
                        FirebaseHelper.sendPushMessage(
                            snapshot.data[index]["deviceid"],
                            "New Call",
                            "You have a new call");
                        hideprogress(context);
                      },
                      child: text_helper(data: "Call now")),
                  button_helper(
                      onpress: () => viewModel.chat(
                            snapshot.data[index]["email"],
                          ),
                      child: text_helper(data: "Chat")),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  UserViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      UserViewModel();
}
