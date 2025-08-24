import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freelancemarketplace/ui/common/customwidget/text_view_helper.dart';
import 'package:freelancemarketplace/ui/widgets/common/addproject/addproject.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';

import '../../../common/apihelper/apihelper.dart';
import '../../../common/app_colors.dart';
import '../../../common/customwidget/button_helper.dart';
import '../../../common/customwidget/snakbar_helper.dart';
import '../../../common/customwidget/text_helper.dart';
import '../../../common/ui_helpers.dart';
import '../../../widgets/common/updateuser/updateuser.dart';
import '../../users/user/about.dart';
import 'content7.dart';
import 'header_content1.dart';
import 'seller_viewmodel.dart';

class SellerView extends StackedView<SellerViewModel> {
  SellerView({Key? key}) : super(key: key);
  OverlayEntry? _overlayEntry;

  @override
  Widget builder(
    BuildContext context,
    SellerViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Container(
            width: screenWidth(context),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => updateuser(context, viewModel),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: viewModel.sharedpref.readString("img"),
                          imageBuilder: (context, imageProvider) => Container(
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
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                          ),
                        ),
                      ),
                    ),
                    horizontalSpaceSmall,
                    InkWell(
                      onTap: () => showCoolAboutDialog(context),
                      child: text_helper(
                        data: "About",
                        size: fontSize10,
                        color: Colors.white,
                      ),
                    ),
                    horizontalSpaceSmall,
                    InkWell(
                      onTap: () => addcomplaint(context, viewModel),
                      child: text_helper(
                        data: "Help Center",
                        size: fontSize10,
                        color: Colors.white,
                      ),
                    ),
                    horizontalSpaceSmall,
                    InkWell(
                      onTap: () => viewModel.allchat(),
                      child: text_helper(
                        data: "Chat",
                        size: fontSize10,
                        color: Colors.white,
                      ),
                    ),
                    horizontalSpaceSmall,
                    InkWell(
                      onTap: () => viewModel.orders(),
                      child: text_helper(
                        data: "Orders",
                        size: fontSize10,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    button_helper(
                        onpress: () => addproject(context, viewModel, {}),
                        color: Colors.white,
                        child: text_helper(
                          data: "Add Project",
                          color: black,
                          size: fontSize10,
                        )),
                    InkWell(
                      onTap: () => viewModel.logout(),
                      child: text_helper(
                        data: "Logout",
                        size: fontSize10,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          HeaderContent1(
            title: "seller",
          ),
          Padding(
            padding: const EdgeInsets.only(left: 55),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: screenWidthCustom(context, 0.5),
                      child: TextField(
                        controller: viewModel.search,
                        onChanged: (val) {
                          viewModel.notifyListeners();
                        },
                        decoration: InputDecoration(
                          hintText: "Search...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    text_helper(
                      data: "Popular:",
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      size: fontSize10,
                    ),
                    horizontalSpaceSmall,
                    searches("Website Designer", viewModel, context),
                    horizontalSpaceSmall,
                    searches("Logo Designer", viewModel, context),
                    horizontalSpaceSmall,
                    searches("Dropshipping", viewModel, context),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          Padding(
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
                        return viewModel.search.text.isEmpty
                            ? filterlsit(context, item, viewModel)
                            : item['title'].toLowerCase().contains(
                                    viewModel.search.text.toLowerCase())
                                ? filterlsit(context, item, viewModel)
                                : const SizedBox.shrink();
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
          verticalSpaceLarge,
          Content7T1()
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_overlayEntry == null) {
            _showChatInterface(context);
          } else {
            _overlayEntry?.remove();
            _overlayEntry = null;
          }
        },
        mini: true,
        child: const Icon(Iconsax.message1),
      ),
    );
  }

  void _showChatInterface(BuildContext context) {
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
          bottom: 60,
          right: 20,
          child: Material(
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 300,
                height: 400,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    text_helper(
                      data: "All FAQs",
                      size: fontSize18,
                      fontWeight: FontWeight.bold,
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: ApiHelper.allfaqs(context),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: getColorWithOpacity(
                                          Theme.of(context).primaryColorLight,
                                          0.2)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      text_helper(
                                        data: snapshot.data[index]['title'],
                                        fontWeight: FontWeight.bold,
                                      ),
                                      text_helper(
                                        data: snapshot.data[index]['ans'],
                                        size: fontSize12,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
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
                  ],
                )),
          )),
    );
    overlay?.insert(_overlayEntry!);
  }

  Widget filterlsit(BuildContext context, item, SellerViewModel viewModel) {
    if (item['uid'] == viewModel.sharedpref.readString("email")) {
      return listdata(context, item, viewModel);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget listdata(BuildContext context, item, SellerViewModel viewModel) {
    return InkWell(
      onTap: () => addproject(context, viewModel, item),
      child: Container(
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
              data: "PKR "+item['price'],
              color: Colors.red,
              size: fontSize8,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addproject(
      BuildContext context, SellerViewModel viewModel, Map data) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Addproject(
            data: data,
          ),
        );
      },
    );
    viewModel.notifyListeners();
  }

  Future<void> addcomplaint(
      BuildContext context, SellerViewModel viewModel) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              verticalSpaceLarge,
              text_helper(data: "Add Complaint"),
              verticalSpaceSmall,
              text_view_helper(hint: "title", controller: viewModel.title),
              verticalSpaceSmall,
              text_view_helper(hint: "Description", controller: viewModel.des),
              verticalSpaceSmall,
              button_helper(
                  onpress: () => viewModel.addcomplaint(context),
                  child: text_helper(data: "Submit")),
            ],
          ),
        ));
      },
    );
    viewModel.notifyListeners();
  }

  Widget searches(String data, SellerViewModel viewMode, BuildContext context) {
    return InkWell(
      onTap: () {
        viewMode.search.text = data;
        viewMode.notifyListeners();
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: text_helper(
            data: data,
            size: fontSize6,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> updateuser(
      BuildContext context, SellerViewModel viewModel) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Updateuser(
            uid: viewModel.sharedpref.readString("email"),
          ),
        );
      },
    );
    viewModel.notifyListeners();
  }

  @override
  SellerViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SellerViewModel();
}
