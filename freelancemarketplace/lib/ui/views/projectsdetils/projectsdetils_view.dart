import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:freelancemarketplace/ui/widgets/common/agreement/agreement.dart';
import 'package:stacked/stacked.dart';

import '../../common/apihelper/apihelper.dart';
import '../../common/app_colors.dart';
import '../../common/customwidget/button_helper.dart';
import '../../common/customwidget/snakbar_helper.dart';
import '../../common/customwidget/text_helper.dart';
import '../../common/ui_helpers.dart';
import '../../widgets/common/updateuser/updateuser.dart';
import 'projectsdetils_viewmodel.dart';

class ProjectsdetilsView extends StackedView<ProjectsdetilsViewModel> {
  ProjectsdetilsView({Key? key, required this.details, this.type = "u"})
      : super(key: key);
  Map details;
  String type;

  @override
  Widget builder(
    BuildContext context,
    ProjectsdetilsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: white),
          title: text_helper(
            data: "Project Details",
            color: white,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: screenHeightCustom(
                                context, 0.5), // Height of the carousel
                            autoPlay: true, // Auto-slide
                            enableInfiniteScroll: true, // Infinite scrolling
                          ),
                          items: details['img'].map<Widget>((url) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: url,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      verticalSpaceMedium,
                      type == "a"
                          ? Column(
                            children: [
                              button_helper(
                                  onpress: () async {
                                    displayprogress(context);
                                    await ApiHelper.statuschange(details["_id"], "true");
                                    hideprogress(context);
                                    Navigator.pop(context);
                                  },
                                  width: screenWidth(context),
                                  child: text_helper(data: "Approve Project")),
                              verticalSpaceSmall,
                              button_helper(
                                  onpress: () async {
                                    displayprogress(context);
                                    await ApiHelper.statuschange(details["_id"], "false");
                                    hideprogress(context);
                                    Navigator.pop(context);
                                  },
                                  width: screenWidth(context),
                                  child: text_helper(data: "Reject Project")),
                            ],
                          )
                          : const SizedBox.shrink()
                    ],
                  )),
                  horizontalSpaceSmall,
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      verticalSpaceMedium,
                      text_helper(
                          data: "Project Details",
                          fontWeight: FontWeight.bold,
                          size: fontSize12),
                      Container(
                        width: screenWidth(context),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: getColorWithOpacity(Colors.white, 0.2)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // 👇 Adding Alphabets + Numbers in Title dynamically
                            t(context, "Title", "${details['title']} - ID#${details['pid'] ?? '001'}"),
                            t(context, "Description", details['des']),
                            t(context, "Price", "PKR " + details['price']),
                          ],
                        ),
                      ),
                      verticalSpaceMedium,
                      InkWell(
                        onTap: () {
                          updateuser(context, details['uid'], viewModel);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text_helper(
                                data: "User Details",
                                fontWeight: FontWeight.bold,
                                size: fontSize12),
                            const Icon(Icons.arrow_forward_outlined),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: ApiHelper.findone(details['uid']),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.toString() == '[]') {
                              return const SizedBox.shrink();
                            } else {
                              return Container(
                                width: screenWidth(context),
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        getColorWithOpacity(Colors.white, 0.2)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    t(context, "Name", snapshot.data['name']),
                                    t(context, "Number",
                                        snapshot.data['number']),
                                    t(context, "Email", snapshot.data['email']),
                                    verticalSpaceSmall,
                                    type == "u"
                                        ? Column(
                                            children: [
                                              button_helper(
                                                  onpress: () => viewModel.chat(
                                                      snapshot.data['email']),
                                                  width: screenWidth(context),
                                                  child: text_helper(
                                                      size: fontSize10,
                                                      data: "Chatting")),
                                              verticalSpaceSmall,
                                              button_helper(
                                                  onpress: () => showagreement(
                                                      context,
                                                      details,
                                                      snapshot.data,
                                                      "a"),
                                                  width: screenWidth(context),
                                                  child: text_helper(
                                                      size: fontSize10,
                                                      data: "Agreement")),
                                              verticalSpaceSmall,
                                              button_helper(
                                                  onpress: () => showagreement(
                                                      context,
                                                      details,
                                                      snapshot.data,
                                                      "c"),
                                                  width: screenWidth(context),
                                                  child: text_helper(
                                                      size: fontSize10,
                                                      data: "Add To Cart")),
                                              verticalSpaceSmall,
                                              kIsWeb
                                                  ? const SizedBox.shrink()
                                                  : button_helper(
                                                      onpress: () {},
                                                      width:
                                                          screenWidth(context),
                                                      child: text_helper(
                                                          size: fontSize10,
                                                          data: "Video Call")),
                                            ],
                                          )
                                        : const SizedBox.shrink()
                                  ],
                                ),
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
                    ],
                  ))
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> updateuser(BuildContext context, String uid,
      ProjectsdetilsViewModel viewModel) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              FutureBuilder(
                future: ApiHelper.findone(details['uid']),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.toString() == '[]') {
                      return const SizedBox.shrink();
                    } else {
                      return Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: snapshot.data['img'],
                            imageBuilder: (context, imageProvider) => Container(
                              width: screenWidthCustom(context, 0.2),
                              height: screenWidthCustom(context, 0.2),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                displaysimpleprogress(context),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                t(context, "Name", snapshot.data['name']),
                                t(context, "Number", snapshot.data['number']),
                                t(context, "Email", snapshot.data['email']),
                                verticalSpaceSmall,
                              ],
                            ),
                          ),
                        ],
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
              verticalSpaceMedium,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 55, right: 55),
                  child: FutureBuilder(
                    future: ApiHelper.allproject(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.toString() == '[]') {
                          return Center(
                            child: text_helper(data: ""),
                          );
                        } else {
                          return Wrap(
                            children: snapshot.data.map<Widget>((item) {
                              return filterlsit(
                                  context, item, viewModel, details['uid']);
                            }).toList(),
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
              ),
            ],
          ),
        ));
      },
    );
  }

  void showagreement(BuildContext context, Map pro, Map user, String type) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: Agreement(
            user: user,
            pro: pro,
            type: type,
          ));
        });
  }

  Widget filterlsit(BuildContext context, item,
      ProjectsdetilsViewModel viewModel, String uid) {
    if (item['uid'] == uid) {
      return listdata(context, item, viewModel);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget listdata(
      BuildContext context, item, ProjectsdetilsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              offset: const Offset(1, 1),
              blurRadius: 0.5,
              spreadRadius: 0.5,
              color: getColorWithOpacity(Theme.of(context).primaryColor, 0.2))
        ],
        color: white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              imageUrl: item['img'][0],
              imageBuilder: (context, imageProvider) => Container(
                width: screenWidthCustom(context, 0.2),
                height: screenWidthCustom(context, 0.2),
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
          verticalSpaceSmall,
          text_helper(
            data: item['title'],
            fontWeight: FontWeight.bold,
            size: fontSize10,
          ),
          text_helper(
            data: item['price'],
            color: Colors.red,
            size: fontSize8,
          ),
        ],
      ),
    );
  }

  Widget t(BuildContext context, String data, String data2) {
    return Column(
      children: [
        Container(
          width: screenWidth(context),
          height: 1,
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text_helper(
                data: data,
                size: fontSize10,
                fontWeight: FontWeight.bold,
              ),
              horizontalSpaceSmall,
              Expanded(
                  child: text_helper(
                data: data2,
                size: fontSize10,
                textAlign: TextAlign.start,
              )),
            ],
          ),
        ),
        Container(
          width: screenWidth(context),
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }

  @override
  ProjectsdetilsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProjectsdetilsViewModel();
}
