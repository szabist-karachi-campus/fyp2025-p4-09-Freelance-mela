import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freelancemarketplace/ui/common/apihelper/apihelper.dart';
import 'package:freelancemarketplace/ui/common/customwidget/snakbar_helper.dart';
import 'package:freelancemarketplace/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../app/app.locator.dart';
import '../../../../services/sharedpref_service.dart';
import '../../../common/apihelper/firebsaeuploadhelper.dart';
import '../../../common/customwidget/text_helper.dart';

class AgreementModel extends BaseViewModel {
  final sharedpref = locator<SharedprefService>();
  final _navigationService = locator<NavigationService>();

  bool check = false;

  Future<void> booking(Map user, Map pro, BuildContext context) async {
    displayprogress(context);
    bool c = await ApiHelper.registerbooking(
        user["email"], pro["_id"], sharedpref.readString("email"), context);
    print(sharedpref.readString("deviceid"));
    await FirebaseHelper.sendPushMessage(
        sharedpref.readString("deviceid"), "Agreement", "New Agreement");
    hideprogress(context);
    if (c) {
      _navigationService.back();
      approve(context);
    } else {
      _navigationService.back();
    }
  }

  Future<void> addtocart(Map user, Map pro, BuildContext context) async {
    displayprogress(context);
    await ApiHelper.registercart(
        user["email"], pro["_id"], sharedpref.readString("email"), context);
    await FirebaseHelper.sendPushMessage(
        sharedpref.readString("deviceid"), "Cart", "Add to Cart");
    hideprogress(context);
    _navigationService.back();
  }

  void approve(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.waving_hand, size: 150),
              verticalSpaceSmall,
              text_helper(data: "Wait for admin approval")
            ],
          ),
        ));
      },
    );
  }
}
