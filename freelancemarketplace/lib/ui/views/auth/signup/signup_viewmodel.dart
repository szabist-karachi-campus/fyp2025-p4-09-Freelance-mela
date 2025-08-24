import 'dart:html' as html;

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancemarketplace/ui/common/apihelper/SupabaseHelper.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import '../../../../services/fire_service.dart';
import '../../../common/apihelper/apihelper.dart';
import '../../../common/apihelper/firebsaeuploadhelper.dart';
import '../../../common/customwidget/button_helper.dart';
import '../../../common/customwidget/snakbar_helper.dart';
import '../../../common/customwidget/text_helper.dart';
import '../../../common/ui_helpers.dart';
import '../login/login_view.dart';

class SignupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _firebase = locator<FireService>();

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController conpass = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();

  String cat = "";

  html.File? image;
  String? imageUrl;
  Future<void> pickImage() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) async {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        image = files[0];
        final reader = html.FileReader();
        reader.readAsDataUrl(image!);
        reader.onLoadEnd.listen((event) {
          imageUrl = reader.result as String;
          notifyListeners();
        });
      }
    });
  }

  Future<void> signup(BuildContext context) async {
    if (email.text.isEmpty ||
        pass.text.isEmpty ||
        conpass.text.isEmpty ||
        name.text.isEmpty ||
        number.text.isEmpty) {
      show_snackbar(context, "Fill all fields");
    } else if (pass.text != conpass.text) {
      show_snackbar(context, "Password do not match");
    } else if (validateEmail(email.text.trim()) != null) {
      // show_snackbar(context, "Enter correct email");
      show_snackbar(context, validateEmail(email.text.trim())!);
    } else if (image == null) {
      show_snackbar(context, "select Image");
    } else if (number.text.length != 11) {
      show_snackbar(context, "enter correct number");
    } else if (cat == "") {
      show_snackbar(context, "select a category");
    } else {
      try {
        displayprogress(context);
        UserCredential userCredential = await _firebase.auth
            .createUserWithEmailAndPassword(
            email: email.text, password: pass.text);
        await userCredential.user!.sendEmailVerification();

        String url = await SupabaseHelper.uploadFile(image, number.text);
        bool c = await ApiHelper.registration(
            name.text, number.text, email.text, pass.text, cat, url, context);

        hideprogress(context);
        if (c) {
          cleardata();
          showd(context);
        }
      } on FirebaseAuthException catch (e) {
        hideprogress(context);
        if (e.code == 'weak-password') {
          show_snackbar(context, 'The password provided is too weak');
        } else if (e.code == 'email-already-in-use') {
          show_snackbar(context, 'The account already exists for that email.');
        } else {
          show_snackbar(context, "try again later");
        }
      }
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address.';
    }

    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  void cleardata() {
    name.clear();
    number.clear();
    email.clear();
    pass.clear();
    conpass.clear();
  }

  void showd(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: text_helper(
                data: "Success Full Registration",
                fontWeight: FontWeight.bold,
                size: fontSize20),
            content: text_helper(data: "Verify your email and login"),
            actions: [
              button_helper(
                  onpress: () => login(), child: text_helper(data: "Done"))
            ],
          );
        });
  }

  void login() {
    _navigationService.clearStackAndShow(Routes.loginView);
    _navigationService.replaceWithTransition(const LoginView(),
        routeName: Routes.loginView, transitionStyle: Transition.rightToLeft);
  }
}
