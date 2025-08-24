import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:freelancemarketplace/ui/views/sellers/seller/seller_view.dart';
import 'package:freelancemarketplace/ui/views/users/user/user_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import '../../../../services/fire_service.dart';
import '../../../../services/sharedpref_service.dart';
import '../../../common/apihelper/apihelper.dart';
import '../../../common/customwidget/snakbar_helper.dart';
import '../../admins/admin/admin_view.dart';
import '../signup/signup_view.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _firebase = locator<FireService>();
  final _sharedpref = locator<SharedprefService>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> login(BuildContext context) async {
    final String inputEmail = email.text.trim().toLowerCase();
    final String inputPassword = password.text.trim();

    if (inputEmail.isEmpty || inputPassword.isEmpty) {
      show_snackbar(context, "Fill all fields");
    } else if (!EmailValidator.validate(inputEmail)) {
      show_snackbar(context, "Enter correct email");
    } else if (inputEmail == "admin@admin.com" && inputPassword == "admin") {
      _sharedpref.setString('email', inputEmail);
      _sharedpref.setString('cat', "admin");
      _sharedpref.setString("auth", 'true');
      _navigationService.clearStackAndShow(Routes.adminView);
      _navigationService.replaceWithTransition(const AdminView(),
          routeName: Routes.adminView, transitionStyle: Transition.rightToLeft);
    } else {
      try {
        displayprogress(context);
        var result = _firebase.messaging.getToken().then((value) {
          return ApiHelper.login(
              inputEmail, inputPassword, value.toString(), context);
        });
        hideprogress(context);
        result.then((value) {
          String cat = value['cat'];
          _sharedpref.setString('id', value['_id']);
          _sharedpref.setString('name', value['name']);
          _sharedpref.setString('number', value['number']);
          _sharedpref.setString('email', value['email']);
          _sharedpref.setString('img', value['img']);
          _sharedpref.setString('deviceid', value['deviceid']);
          _sharedpref.setString('cat', cat);
          _sharedpref.setString("auth", 'true');

          if (cat == "hire") {
            _navigationService.clearStackAndShow(Routes.userView);
            _navigationService.replaceWithTransition(UserView(),
                routeName: Routes.userView,
                transitionStyle: Transition.rightToLeft);
          } else {
            if (value['status'] == "true") {
              _navigationService.clearStackAndShow(Routes.sellerView);
              _navigationService.replaceWithTransition(SellerView(),
                  routeName: Routes.sellerView,
                  transitionStyle: Transition.rightToLeft);
            } else {
              show_snackbar(context, "wait for admin approval");
            }
          }
        });
      } on FirebaseAuthException catch (e) {
        hideprogress(context);
        if (e.code == 'wrong-password') {
          show_snackbar(context, 'The password provided is wrong');
        } else if (e.code == 'user-not-found') {
          show_snackbar(context, 'No user found for that email');
        } else {
          show_snackbar(context, "try again later");
        }
      }
    }
  }

  void singup() {
    _navigationService.navigateWithTransition(const SignupView(),
        routeName: Routes.signupView, transitionStyle: Transition.rightToLeft);
  }

  Future<void> forgetpassword(BuildContext context) async {
    final String inputEmail = email.text.trim().toLowerCase();

    if (inputEmail.isEmpty) {
      show_snackbar(context, "Fill Email");
    } else {
      await _firebase.auth.sendPasswordResetEmail(email: inputEmail);
      show_snackbar(context, "Forget Password Mail has been sent");
    }
  }
}
