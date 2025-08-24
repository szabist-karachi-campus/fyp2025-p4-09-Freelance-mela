import 'package:stacked/stacked.dart';
import 'package:freelancemarketplace/app/app.locator.dart';
import 'package:freelancemarketplace/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../services/sharedpref_service.dart';
import '../admins/admin/admin_view.dart';
import '../auth/login/login_view.dart';
import '../sellers/seller/seller_view.dart';
import '../users/user/user_view.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _sharedpref = locator<SharedprefService>();

  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 3));

    if (_sharedpref.readString("auth") == "true") {
      String cat = _sharedpref.readString("cat");
      if (cat == "seller") {
        _navigationService.clearStackAndShow(Routes.sellerView);
        _navigationService.replaceWithTransition(SellerView(),
            routeName: Routes.sellerView,
            transitionStyle: Transition.rightToLeft);
      } else if (cat == "admin") {
        _navigationService.clearStackAndShow(Routes.adminView);
        _navigationService.replaceWithTransition(const AdminView(),
            routeName: Routes.adminView,
            transitionStyle: Transition.rightToLeft);
      } else {
        _navigationService.clearStackAndShow(Routes.userView);
        _navigationService.replaceWithTransition(UserView(),
            routeName: Routes.userView,
            transitionStyle: Transition.rightToLeft);
      }
    } else {
      _navigationService.replaceWithTransition(const LoginView(),
          routeName: Routes.loginView, transitionStyle: Transition.rightToLeft);
    }
  }
}
