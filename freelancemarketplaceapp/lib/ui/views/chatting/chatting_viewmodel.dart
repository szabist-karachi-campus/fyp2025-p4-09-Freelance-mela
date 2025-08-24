import 'package:flutter/cupertino.dart';
import 'package:freelancemarketplace/services/sharedpref_service.dart';
import 'package:stacked/stacked.dart';

import '../../../../app/app.locator.dart';

class ChattingViewModel extends BaseViewModel {
  final sharedpref = locator<SharedprefService>();
  TextEditingController chat = TextEditingController();
}
