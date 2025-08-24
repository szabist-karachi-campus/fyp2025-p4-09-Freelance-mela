import 'package:freelancemarketplace/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:freelancemarketplace/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:freelancemarketplace/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:freelancemarketplace/ui/views/user/user_view.dart';
import 'package:freelancemarketplace/services/sharedpref_service.dart';
import 'package:freelancemarketplace/ui/views/allchat/allchat_view.dart';
import 'package:freelancemarketplace/ui/views/chatting/chatting_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: UserView),
    MaterialRoute(page: AllchatView),
    MaterialRoute(page: ChattingView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SharedprefService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
