import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:freelancemarketplace/ui/common/apihelper/SupabaseHelper.dart';
import 'package:freelancemarketplace/ui/common/apihelper/firebsaeuploadhelper.dart';
import 'package:stacked/stacked.dart';

import '../../../../app/app.locator.dart';
import '../../../../services/sharedpref_service.dart';
import '../../../common/apihelper/apihelper.dart';
import '../../../common/customwidget/snakbar_helper.dart';

class AddprojectModel extends BaseViewModel {
  final _sharedpref = locator<SharedprefService>();

  TextEditingController title = TextEditingController();
  TextEditingController des = TextEditingController();
  TextEditingController price = TextEditingController();

  List<html.File>? images = [];
  List<String>? imageUrls = [];

  Future<void> pickImages() async {
    // Create a file upload input element with multiple file selection enabled
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.multiple = true; // Allow multiple file selection
    uploadInput.click();

    uploadInput.onChange.listen((event) async {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        images = files;
        imageUrls = [];

        for (var file in files) {
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          await reader.onLoadEnd.first; // Wait for the file to finish loading
          imageUrls!.add(reader.result as String);
        }

        notifyListeners(); // Notify listeners to update the UI
      }
    });
  }

  Future<void> adddetails(BuildContext context) async {
    if (title.text.isEmpty || des.text.isEmpty || price.text.isEmpty) {
      show_snackbar(context, "Fill all fields");
    } else if (images!.isEmpty) {
      show_snackbar(context, "select Image");
    } else {
      displayprogress(context);
      List<String> uploadedUrls = await Future.wait(
        images!.map((image) => SupabaseHelper.uploadFile(image, "")).toList(),
      );
      // String url = await SupabaseHelper.uploadFile(image, "");
      await ApiHelper.registerproject(title.text, des.text, uploadedUrls,
          price.text, _sharedpref.readString("email"), context);
      FirebaseHelper.sendNotificationToAllUser("Project", "New Project Added");
      hideprogress(context);
      Navigator.pop(context);
    }
  }

  Future<void> deletepro(String id, BuildContext context) async {
    displayprogress(context);
    await ApiHelper.deleteproject(id);
    FirebaseHelper.sendNotificationToAllUser("Project", "Project Deleted");
    hideprogress(context);
    show_snackbar(context, "Delete Successfully");
    Navigator.pop(context);
  }

  Future<void> updatepro(BuildContext context, Map data) async {
    if (title.text.isEmpty || des.text.isEmpty || price.text.isEmpty) {
      show_snackbar(context, "Fill all fields");
    } else {
      displayprogress(context);
      List url;
      if (images!.isEmpty) {
        url = data['img'];
      } else {
        url = await Future.wait(
          images!.map((image) => SupabaseHelper.uploadFile(image, "")).toList(),
        );
        // await SupabaseHelper.uploadFile(image, "");
      }
      await ApiHelper.updateproject(
          data["_id"], title.text, des.text, url, price.text, context);
      FirebaseHelper.sendNotificationToAllUser("Project", "Project Update");
      show_snackbar(context, "Update Successfully");
      hideprogress(context);
      Navigator.pop(context);
    }
  }
}
