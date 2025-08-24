import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../services/sharedpref_service.dart';
import '../../common/apihelper/apihelper.dart';
import '../../common/customwidget/snakbar_helper.dart';

class CartsViewModel extends BaseViewModel {
  final sharedpref = locator<SharedprefService>();
  final _navigationService = locator<NavigationService>();

  Future<void> booking(BuildContext context) async {
    displayprogress(context);

    List a = await ApiHelper.allcart();
    for (var i in a) {
      if(sharedpref.readString("email") == i["ppid"]){
        await ApiHelper.registerbooking(
            i["uid"], i["pid"], sharedpref.readString("email"), context);
        await ApiHelper.deletecart(i["_id"]);
      }
    }

    hideprogress(context);
    show_snackbar(context, "Wait for admin approval");
    _navigationService.back();
  }
}
