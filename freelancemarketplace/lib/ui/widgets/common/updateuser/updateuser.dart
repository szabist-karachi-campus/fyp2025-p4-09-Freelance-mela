import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freelancemarketplace/ui/common/customwidget/text_helper.dart';
import 'package:freelancemarketplace/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import '../../../common/apihelper/apihelper.dart';
import '../../../common/app_colors.dart';
import '../../../common/customwidget/button_helper.dart';
import '../../../common/customwidget/snakbar_helper.dart';
import '../../../common/customwidget/text_view_helper.dart';
import 'updateuser_model.dart';

class Updateuser extends StackedView<UpdateuserModel> {
  Updateuser({super.key, required this.uid});
  String uid;

  @override
  Widget builder(
    BuildContext context,
    UpdateuserModel viewModel,
    Widget? child,
  ) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: ListView(
        children: [
          text_helper(data: "Update Your Details"),
          verticalSpaceLarge,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  viewModel.pickImage();
                },
                child: viewModel.image == null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: viewModel.img,
                          imageBuilder: (context, imageProvider) => Container(
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
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          width: screenWidthCustom(context, 0.1),
                          height: screenWidthCustom(context, 0.1),
                          viewModel.imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ],
          ),
          verticalSpaceSmall,
          text_view_helper(
              hint: "Name",
              formatter: [
                FilteringTextInputFormatter.allow(getRegExpstring()),
              ],
              controller: viewModel.name),
          verticalSpaceSmall,
          text_view_helper(
              hint: "Number",
              formatter: [
                FilteringTextInputFormatter.allow(getRegExpint()),
              ],
              maxlength: 11,
              controller: viewModel.number),
          verticalSpaceSmall,
          button_helper(
              onpress: () => viewModel.updateuser(context, uid),
              child: text_helper(data: "Update")),
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
                        return filterlsit(context, item, viewModel,
                            viewModel.sharedpref.readString("email"));
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
        ],
      ),
    );
  }

  Widget filterlsit(
      BuildContext context, item, UpdateuserModel viewModel, String uid) {
    if (item['uid'] == uid) {
      return listdata(context, item, viewModel);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget listdata(BuildContext context, item, UpdateuserModel viewModel) {
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

  @override
  void onViewModelReady(UpdateuserModel viewModel) {
    viewModel.img = viewModel.sharedpref.readString("img");
    viewModel.name.text = viewModel.sharedpref.readString("name");
    viewModel.number.text = viewModel.sharedpref.readString("number");

    super.onViewModelReady(viewModel);
  }

  @override
  UpdateuserModel viewModelBuilder(
    BuildContext context,
  ) =>
      UpdateuserModel();
}
