import 'package:freelancemarketplace/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:freelancemarketplace/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:freelancemarketplace/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:freelancemarketplace/services/sharedpref_service.dart';
import 'package:freelancemarketplace/services/fire_service.dart';
import 'package:freelancemarketplace/ui/views/auth/login/login_view.dart';
import 'package:freelancemarketplace/ui/views/auth/signup/signup_view.dart';
import 'package:freelancemarketplace/ui/views/admins/admin/admin_view.dart';
import 'package:freelancemarketplace/ui/views/users/user/user_view.dart';
import 'package:freelancemarketplace/ui/views/sellers/seller/seller_view.dart';
import 'package:freelancemarketplace/ui/views/projectsdetils/projectsdetils_view.dart';
import 'package:freelancemarketplace/ui/views/chat/allchat/allchat_view.dart';
import 'package:freelancemarketplace/ui/views/chat/chatting/chatting_view.dart';
import 'package:freelancemarketplace/ui/views/orders/orders_view.dart';
import 'package:freelancemarketplace/ui/views/carts/carts_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: SignupView),
    MaterialRoute(page: AdminView),
    MaterialRoute(page: UserView),
    MaterialRoute(page: SellerView),
    MaterialRoute(page: ProjectsdetilsView),
    MaterialRoute(page: AllchatView),
    MaterialRoute(page: ChattingView),
    MaterialRoute(page: OrdersView),
    MaterialRoute(page: CartsView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SharedprefService),
    LazySingleton(classType: FireService),
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
