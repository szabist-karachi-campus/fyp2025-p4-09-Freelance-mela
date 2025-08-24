import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freelancemarketplace/app/app.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';

import '../../../common/app_colors.dart';
import '../../../common/customwidget/button_helper.dart';
import '../../../common/customwidget/text_helper.dart';
import '../../../common/customwidget/text_view_helper.dart';
import '../../../common/ui_helpers.dart';
import 'signup_viewmodel.dart';

class SignupView extends StackedView<SignupViewModel> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, SignupViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo and Text
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        "assets/logo.jpg",
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  horizontalSpaceSmall,
                /*  text_helper(
                    data: "Freelance Mela",
                    size: fontSize14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),*/
                ],
              ),

              // Center Links
              Row(
                children: [
                  navLink("How it works"),
                  navLink("About"),
                  navLink("Help Center"),
                ],
              ),

              // Buttons
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: text_helper(
                      data: "Join as a Freelancer",
                      size: fontSize10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  horizontalSpaceSmall,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(colors: [gstart, gend]),
                    ),
                    child: text_helper(
                      data: "Hire Freelancer",
                      color: Colors.white,
                      size: fontSize10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF2F9FF), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  verticalSpaceMedium,
                  text_helper(
                    data: "Welcome to Freelance Mela",
                    size: fontSize18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  verticalSpaceSmall,
                  text_helper(
                    data: "Create an account to get started",
                    size: fontSize12,
                    color: Colors.grey,
                  ),
                  verticalSpaceMedium,
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
                          color: getColorWithOpacity(black, 0.2),
                        ),
                      ],
                    ),
                    width: screenWidthCustom(context, .5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        text_helper(
                          data: "Sign Up",
                          fontWeight: FontWeight.bold,
                          size: fontSize22,
                        ),
                        verticalSpaceMedium,
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: screenWidthCustom(context, 0.15),
                            height: screenWidthCustom(context, 0.15),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(2, 2),
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  color: getColorWithOpacity(black, 0.2),
                                )
                              ],
                              border: Border.all(width: 3, strokeAlign: BorderSide.strokeAlignOutside),
                            ),
                            child: InkWell(
                              onTap: () => viewModel.pickImage(),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: viewModel.image == null
                                    ? const Icon(Iconsax.user, size: 80)
                                    : Image.network(viewModel.imageUrl!, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                        verticalSpaceMedium,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            cat(context, viewModel, "freelancer", "assets/free.png"),
                            cat(context, viewModel, "hire", "assets/hire.png"),
                          ],
                        ),
                        verticalSpaceSmall,
                        text_field_helper(
                          name: "Full name",
                          hint: "Enter your full name",
                          icon: const Icon(Iconsax.user),
                          controller: viewModel.name,
                          formatter: [FilteringTextInputFormatter.allow(getRegExpstring())],
                        ),
                        verticalSpaceTiny,
                        text_field_helper(
                          icon: const Icon(Iconsax.message),
                          name: "Email",
                          hint: "Enter Email",
                          controller: viewModel.email,
                          textinputtype: TextInputType.emailAddress,
                        ),
                        verticalSpaceTiny,
                        text_field_helper(
                          name: "Phone Number",
                          hint: "Enter phone number",
                          icon: const Icon(Iconsax.call),
                          controller: viewModel.number,
                          formatter: [FilteringTextInputFormatter.allow(getRegExpint())],
                          maxlen: 11,
                          textinputtype: TextInputType.number,
                        ),
                        verticalSpaceTiny,
                        text_field_helper(
                          name: "Password",
                          hint: "Enter Password",
                          controller: viewModel.pass,
                          obsecure: true,
                          icon: const Icon(Iconsax.password_check),
                        ),
                        verticalSpaceTiny,
                        text_field_helper(
                          name: "Confirm Password",
                          hint: "Enter Password again",
                          controller: viewModel.conpass,
                          obsecure: true,
                          icon: const Icon(Iconsax.password_check),
                        ),
                        verticalSpaceMedium,
                        InkWell(
                          onTap: () => viewModel.signup(context),
                          child: Container(
                            width: screenWidth(context),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(colors: [gstart, gend]),
                              boxShadow: [
                                BoxShadow(
                                  color: gend.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: text_helper(
                              data: "Sign Up",
                              color: white,
                              fontWeight: FontWeight.bold,
                              size: fontSize14,
                            ),
                          ),
                        ),
                        verticalSpaceSmall,
                        Align(alignment: Alignment.center, child: text_helper(data: "OR")),
                        verticalSpaceSmall,
                        button_helper(
                          width: screenWidth(context),
                          color: gend,
                          onpress: () => viewModel.login(),
                          child: text_helper(data: "login"),
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
                          color: getColorWithOpacity(black, 0.2),
                        )
                      ],
                    ),
                    width: screenWidthCustom(context, .5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text_helper(data: "New To Freelance Mela", fontWeight: FontWeight.bold),
                        text_helper(data: "Hire FreeLancer"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget navLink(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: text_helper(
        data: label,
        size: fontSize10,
        color: Colors.grey.shade700,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget text_field_helper({
    required String name,
    required String hint,
    required TextEditingController controller,
    Widget? icon,
    obsecure = false,
    List<TextInputFormatter> formatter = const [],
    int? maxlen,
    TextInputType textinputtype = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            text_helper(data: name, fontWeight: FontWeight.w500),
            horizontalSpaceTiny,
            text_helper(data: "*", color: Colors.red),
          ],
        ),
        verticalSpaceTiny,
        TextField(
          controller: controller,
          obscureText: obsecure,
          keyboardType: textinputtype,
          maxLength: maxlen,
          inputFormatters: formatter,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade100,
            prefixIcon: icon,
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget cat(BuildContext context, SignupViewModel viewModel, String title, String img) {
    return InkWell(
      onTap: () {
        viewModel.cat = title;
        viewModel.notifyListeners();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(2, 2),
              blurRadius: 2,
              spreadRadius: 1,
              color: viewModel.cat == title
                  ? Theme.of(context).primaryColor
                  : getColorWithOpacity(Theme.of(context).primaryColorLight, 0.1),
            )
          ],
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          children: [
            Image.asset(
              img,
              width: screenWidthCustom(context, 0.15),
              height: screenWidthCustom(context, 0.15),
            ),
            verticalSpaceTiny,
            text_helper(data: title, fontWeight: FontWeight.bold),
          ],
        ),
      ),
    );
  }

  @override
  SignupViewModel viewModelBuilder(BuildContext context) => SignupViewModel();
}
