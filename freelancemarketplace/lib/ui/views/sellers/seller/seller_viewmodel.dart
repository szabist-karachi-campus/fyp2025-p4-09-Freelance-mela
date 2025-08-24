import 'package:flutter/cupertino.dart';
import 'package:freelancemarketplace/ui/views/chat/allchat/allchat_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import '../../../../services/sharedpref_service.dart';
import '../../../common/apihelper/apihelper.dart';
import '../../../common/customwidget/snakbar_helper.dart';
import '../../auth/login/login_view.dart';
import '../../orders/orders_view.dart';

class SellerViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final sharedpref = locator<SharedprefService>();

  TextEditingController search = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController des = TextEditingController();

  void logout() {
    sharedpref.remove('email');
    sharedpref.remove('cat');
    sharedpref.remove("auth");
    _navigationService.clearStackAndShow(Routes.loginView);
    _navigationService.replaceWithTransition(const LoginView(),
        routeName: Routes.loginView, transitionStyle: Transition.rightToLeft);
  }

  void allchat() {
    _navigationService.replaceWithTransition(const AllchatView(),
        routeName: Routes.allchatView, transitionStyle: Transition.rightToLeft);
  }

  Future<void> addcomplaint(BuildContext context) async {
    if (title.text.isEmpty || des.text.isEmpty) {
      show_snackbar(context, "Fill all fields");
    } else {
      displayprogress(context);
      await ApiHelper.registercomplains(
          sharedpref.readString("email"), title.text, des.text, context);
      show_snackbar(context, "submit Successfully");
      hideprogress(context);
      Navigator.pop(context);
    }
  }

  void orders() {
    _navigationService.navigateWithTransition(const OrdersView(),
        routeName: Routes.projectsdetilsView,
        transitionStyle: Transition.rightToLeft);
  }
}
