import 'package:freelancemarketplace/services/sharedpref_service.dart';
import 'package:freelancemarketplace/ui/views/chat/chatting/chatting_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';

class AllchatViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final sharedpref = locator<SharedprefService>();

  void move(String idd, String did) {
    _navigationService.navigateWithTransition(
        ChattingView(
          id: idd,
          did: did,
        ),
        routeName: Routes.chattingView,
        transitionStyle: Transition.rightToLeft);
  }
}
