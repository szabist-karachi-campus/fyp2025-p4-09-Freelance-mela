import 'package:flutter/cupertino.dart';
import 'package:freelancemarketplace/ui/views/carts/carts_view.dart';
import 'package:freelancemarketplace/ui/views/orders/orders_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import '../../../../services/sharedpref_service.dart';
import '../../../common/apihelper/apihelper.dart';
import '../../../common/customwidget/snakbar_helper.dart';
import '../../auth/login/login_view.dart';
import '../../projectsdetils/projectsdetils_view.dart';

class UserViewModel extends BaseViewModel {
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

  void details(Map data) {
    _navigationService.navigateWithTransition(
        ProjectsdetilsView(
          details: data,
        ),
        routeName: Routes.projectsdetilsView,
        transitionStyle: Transition.rightToLeft);
  }

  void orders() {
    _navigationService.navigateWithTransition(const OrdersView(),
        routeName: Routes.projectsdetilsView,
        transitionStyle: Transition.rightToLeft);
  }

  void cart() {
    _navigationService.navigateWithTransition(const CartsView(),
        routeName: Routes.cartsView,
        transitionStyle: Transition.rightToLeft);
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
}
