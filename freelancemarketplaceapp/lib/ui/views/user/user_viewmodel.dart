import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/sharedpref_service.dart';
import '../../common/apihelper/apihelper.dart';
import '../chatting/chatting_view.dart';

class UserViewModel extends BaseViewModel {
  final sharedpref = locator<SharedprefService>();
  final _navigationService = locator<NavigationService>();

  Future<void> chat(String did) async {
    Map c = await ApiHelper.registerchat(sharedpref.readString("email"), did);
    if (c['status']) {
      _navigationService.navigateWithTransition(
          ChattingView(id: c['message'], did: c['did']),
          routeName: Routes.chattingView,
          transitionStyle: Transition.rightToLeft);
    }
  }
}
