import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../services/sharedpref_service.dart';

class OrdersViewModel extends BaseViewModel {
  final sharedpref = locator<SharedprefService>();
}
