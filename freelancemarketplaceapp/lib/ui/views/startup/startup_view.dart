import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';
import 'package:freelancemarketplace/ui/common/ui_helpers.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/app_colors.dart';
import '../../common/customwidget/text_helper.dart';
import '../../common/customwidget/text_view_helper.dart';
import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    StartupViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2,
                        spreadRadius: 2,
                        offset: const Offset(3, 3),
                        color: getColorWithOpacity(black, 0.2))
                  ]),
              width: screenWidth(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text_helper(
                    data: "Login",
                    fontWeight: FontWeight.bold,
                    size: fontSize18,
                  ),
                  verticalSpaceMedium,
                  heading(name: "Email"),
                  text_view_helper(
                    hint: "Enter your email address",
                    controller: viewModel.email,
                    prefix: const Icon(Iconsax.message),
                  ),
                  verticalSpaceSmall,
                  heading(name: "Password"),
                  text_view_helper(
                    hint: "Enter your password",
                    controller: viewModel.password,
                    obsecure: true,
                    prefix: const Icon(Iconsax.password_check),
                  ),
                  verticalSpaceMedium,
                  InkWell(
                    onTap: () => viewModel.login(context),
                    child: Container(
                        width: screenWidth(context),
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient:
                                const LinearGradient(colors: [gstart, gend])),
                        child: text_helper(
                          data: "Log In",
                          color: white,
                        )),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2,
                        spreadRadius: 2,
                        offset: const Offset(3, 3),
                        color: getColorWithOpacity(black, 0.2))
                  ]),
              //height: 300,
              width: screenWidth(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text_helper(
                    data: "New To Freelance Mela",
                    fontWeight: FontWeight.bold,
                  ),
                  text_helper(data: "Hire FreeLancer"),
                ],
              ),
            ),
          ],
        ),
      ),
    )));
  }

  Widget heading({required String name}) {
    return Row(
      children: [
        text_helper(
          data: name,
          fontWeight: FontWeight.w500,
        ),
        horizontalSpaceTiny,
        text_helper(
          data: "*",
          color: Colors.red,
        )
      ],
    );
  }

  Future<void> permission(StartupViewModel viewModel) async {
    await Permission.notification.request();
  }

  @override
  void onViewModelReady(StartupViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) {
    permission(viewModel);
    viewModel.runStartupLogic();
  });

  @override
  StartupViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      StartupViewModel();
}
