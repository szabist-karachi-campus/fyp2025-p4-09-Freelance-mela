import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';

import '../../../common/app_colors.dart';
import '../../../common/customwidget/button_helper.dart';
import '../../../common/customwidget/snakbar_helper.dart';
import '../../../common/customwidget/text_helper.dart';
import '../../../common/customwidget/text_view_helper.dart';
import '../../../common/ui_helpers.dart';
import 'addproject_model.dart';

class Addproject extends StackedView<AddprojectModel> {
  Addproject({super.key, required this.data});
  Map data;

  @override
  Widget builder(
    BuildContext context,
    AddprojectModel viewModel,
    Widget? child,
  ) {
    return ListView(
      children: [
        verticalSpaceSmall,
        text_helper(
          data: "Sell your projects now",
          fontWeight: FontWeight.bold,
          size: fontSize20,
        ),
        text_helper(
          data: "Fill all details to post your project",
        ),
        verticalSpaceSmall,
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: getColorWithOpacity(
                  Theme.of(context).primaryColorLight, 0.1)),
          child: Column(
            children: [
              Container(
                width: screenWidth(context),
                height: 5,
                color: Theme.of(context).primaryColor,
              ),
              verticalSpaceSmall,
              InkWell(
                onTap: () => viewModel.pickImages(),
                child: viewModel.images!.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(50),
                        child: Icon(
                          size: 80,
                          Iconsax.code,
                        ),
                      )
                    : Wrap(
                        children: viewModel.imageUrls!
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      e,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
              )
            ],
          ),
        ),
        data.isNotEmpty
            ? Column(
                children: [
                  verticalSpaceSmall,
                  text_helper(
                    data: "Pervious Image",
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Wrap(
                        children: data['img'].map<Widget>((item) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedNetworkImage(
                              imageUrl: item,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: screenWidthCustom(context, 0.4),
                                height: screenWidthCustom(context, 0.4),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  displaysimpleprogress(context),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                ],
              )
            : const SizedBox.shrink(),
        verticalSpaceMedium,
        text_view_helper(
            hint: "Enter Title",
            formatter: [
              FilteringTextInputFormatter.allow(getRegExpstring()),
            ],
            controller: viewModel.title),
        text_view_helper(
            hint: "Enter Description",
            formatter: [
              FilteringTextInputFormatter.allow(getRegExpstring()),
            ],
            controller: viewModel.des),
        text_view_helper(
            hint: "Enter Price",
            textInputType: TextInputType.number,
            prefix: const Icon(Icons.currency_exchange),
            formatter: [
              FilteringTextInputFormatter.allow(getRegExpint()),
            ],
            controller: viewModel.price),
        verticalSpaceMedium,
        data.isEmpty
            ? button_helper(
                onpress: () => viewModel.adddetails(context),
                child: text_helper(data: "Add Details"))
            : Column(
                children: [
                  button_helper(
                      onpress: () => viewModel.updatepro(context, data),
                      child: text_helper(data: "Update")),
                  verticalSpaceTiny,
                  button_helper(
                      onpress: () => viewModel.deletepro(data['_id'], context),
                      child: text_helper(data: "Delete")),
                ],
              ),
        verticalSpaceMedium,
      ],
    );
  }

  @override
  void onViewModelReady(AddprojectModel viewModel) {
    if (data.isNotEmpty) {
      viewModel.title.text = data['title'];
      viewModel.des.text = data['des'];
      viewModel.price.text = data['price'];
    }
    super.onViewModelReady(viewModel);
  }

  @override
  AddprojectModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddprojectModel();
}
