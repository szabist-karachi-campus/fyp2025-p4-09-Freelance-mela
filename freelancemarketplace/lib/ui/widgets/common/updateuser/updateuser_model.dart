import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

import '../../../../app/app.locator.dart';
import '../../../../services/sharedpref_service.dart';
import '../../../common/apihelper/SupabaseHelper.dart';
import '../../../common/apihelper/apihelper.dart';
import '../../../common/apihelper/firebsaeuploadhelper.dart';
import '../../../common/customwidget/snakbar_helper.dart';

class UpdateuserModel extends BaseViewModel {
  final sharedpref = locator<SharedprefService>();

  TextEditingController number = TextEditingController();
  TextEditingController name = TextEditingController();

  String img = "";

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

  Future<void> updateuser(BuildContext context, String uid) async {
    if (name.text.isEmpty || number.text.isEmpty) {
      show_snackbar(context, "Fill all fields");
    } else if (number.text.length != 11) {
      show_snackbar(context, "enter correct number");
    } else {
      displayprogress(context);
      String url =
          image == null ? img : await SupabaseHelper.uploadFile(image!, "");
      await ApiHelper.update(
          sharedpref.readString("id"), name.text, number.text, url, context);
      await FirebaseHelper.sendPushMessage(
          sharedpref.readString("deviceid"), "Details", "Details Update");
      show_snackbar(context, "Update Successfully");
      hideprogress(context);
      Navigator.pop(context);
    }
  }
}
