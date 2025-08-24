import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:freelancemarketplace/app/app.locator.dart';
import 'package:freelancemarketplace/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../services/sharedpref_service.dart';
import '../../common/apihelper/apihelper.dart';
import '../../common/customwidget/snakbar_helper.dart';
import '../user/user_view.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _sharedpref = locator<SharedprefService>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future runStartupLogic() async {
    _sharedpref.initialize();
  }

  Future<void> login(BuildContext context) async {
    if (email.text.isEmpty || password.text.isEmpty) {
      show_snackbar(context, "Fill all fields");
    } else if (!EmailValidator.validate(email.text)) {
      show_snackbar(context, "Enter correct email");
    } else {
      try {
        displayprogress(context);
        // var result = ApiHelper.login(email.text, password.text, "", context);
        var result = FirebaseMessaging.instance.getToken().then((value) {
          _sharedpref.setString('notificationid', value.toString());
          return ApiHelper.login(
              email.text, password.text, value.toString(), context);
        });
        hideprogress(context);
        result.then((value) {
          String cat = value['cat'];
          _sharedpref.setString('id', value['_id']);
          _sharedpref.setString('name', value['name']);
          _sharedpref.setString('number', value['number']);
          _sharedpref.setString('email', value['email']);
          _sharedpref.setString('img', value['img']);
          _sharedpref.setString('cat', cat);
          _sharedpref.setString("auth", 'true');

          _navigationService.clearStackAndShow(Routes.userView);
          _navigationService.replaceWithTransition(UserView(),
              routeName: Routes.userView,
              transitionStyle: Transition.rightToLeft);
        });
      } catch (e) {
        hideprogress(context);
      }
    }
  }
}
