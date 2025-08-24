import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freelancemarketplace/ui/common/customwidget/button_helper.dart';
import 'package:stacked/stacked.dart';

import '../../common/apihelper/apihelper.dart';
import '../../common/app_colors.dart';
import '../../common/customwidget/snakbar_helper.dart';
import '../../common/customwidget/text_helper.dart';
import '../../common/ui_helpers.dart';
import 'carts_viewmodel.dart';

class CartsView extends StackedView<CartsViewModel> {
  const CartsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CartsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        appBar: AppBar(
          title: text_helper(
            data: "Cart",
            fontWeight: FontWeight.bold,
          ),
        ),
        body: SafeArea(
            child: FutureBuilder(
              future: ApiHelper.allcart(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.toString() == '[]') {
                    return const SizedBox.shrink();
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (viewModel.sharedpref.readString("email") ==
                            snapshot.data[index]["ppid"]) {
                          return uu(context, index, snapshot, viewModel);
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
            )),
      bottomNavigationBar: Container(
        color:Colors.amber.withAlpha(1000),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            text_helper(data: "Place Order",size: fontSize10, fontWeight: FontWeight.bold,),
            button_helper(
                onpress: () {
                  viewModel.booking(context);
                },
                child: text_helper(data:"Check Out", size: fontSize10,))
          ],
        ),
      ),
    );
  }

  Widget uu(BuildContext context, int index, AsyncSnapshot snapshot,
      CartsViewModel viewModel) {
    return Container(
      width: screenWidth(context),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: getColorWithOpacity(Colors.grey, 0.1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FutureBuilder(
            future: ApiHelper.findone(snapshot.data[index]['uid']),
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
                                width: screenWidthCustom(context, 0.1),
                                height: screenWidthCustom(context, 0.1),
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
                      horizontalSpaceMedium,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          text_helper(
                            data: snapshot2.data["name"],
                            fontWeight: FontWeight.bold,
                            size: fontSize12,
                            color: Theme.of(context).primaryColor,
                          ),
                          text_helper(
                            data: snapshot2.data["email"],
                            size: fontSize10,
                            textAlign: TextAlign.start,
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
          FutureBuilder(
            future: ApiHelper.getoneproject(snapshot.data[index]['pid']),
            builder: (BuildContext context, AsyncSnapshot snapshot2) {
              if (snapshot2.hasData) {
                if (snapshot2.data.toString() == '[]') {
                  return const SizedBox.shrink();
                } else {
                  return Column(
                    children: [
                      t(context, "Title", snapshot2.data['title']),
                      t(context, "Description", snapshot2.data['des']),
                      t(context, "Price", "PKR " + snapshot2.data['price']),
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
  CartsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CartsViewModel();
}
