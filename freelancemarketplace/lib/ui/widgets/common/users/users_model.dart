import 'package:freelancemarketplace/services/sharedpref_service.dart';
import 'package:stacked/stacked.dart';

import '../../../../app/app.locator.dart';

class UsersModel extends BaseViewModel {
  final sharedpref = locator<SharedprefService>();
}
