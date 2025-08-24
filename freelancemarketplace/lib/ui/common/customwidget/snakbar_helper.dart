// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:freelancemarketplace/ui/common/customwidget/text_helper.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show_snackbar(
    BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: text_helper(data: text),
      duration: const Duration(seconds: 2),
    ),
  );
}

Widget displaysimpleprogress(BuildContext context) {
  return const Center(
    child: CircularProgressIndicator(
      strokeWidth: 6.0,
    ),
  );
}

void displayprogress(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 6.0,
          ),
        ),
      );
    },
  );
}

void hideprogress(BuildContext context) {
  Navigator.pop(context);
}
