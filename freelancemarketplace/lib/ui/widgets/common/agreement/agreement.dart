import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../common/customwidget/button_helper.dart';
import '../../../common/customwidget/text_helper.dart';
import '../../../common/ui_helpers.dart';
import 'agreement_model.dart';

class Agreement extends StackedView<AgreementModel> {
  Agreement(
      {super.key, required this.user, required this.pro, required this.type});
  Map user;
  Map pro;
  String type;
  // a => aggrement
  // c => add to cart

  @override
  Widget builder(
    BuildContext context,
    AgreementModel viewModel,
    Widget? child,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            text_helper(
              data: "AGREEMENT FOR PURCHASE OF PROJECT",
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.start,
              size: fontSize12,
            ),
            verticalSpaceMedium,
            t(context, "Name", user['name']),
            t(context, "Number", user['number']),
            t(context, "Email", user['email']),
            verticalSpaceMedium,
            text_helper(
                data: "1. Project Description",
                fontWeight: FontWeight.bold,
                size: fontSize12,
                textAlign: TextAlign.start),
            verticalSpaceTiny,

            text_helper(
                size: fontSize10,
                data: pro['title'],
                textAlign: TextAlign.start),
            text_helper(
                size: fontSize10, data: pro['des'], textAlign: TextAlign.start),
            text_helper(
                size: fontSize10,
                data: pro['price'],
                textAlign: TextAlign.start),
            verticalSpaceSmall,
            text_helper(
                data: "2. Transfer of Ownership",
                fontWeight: FontWeight.bold,
                size: fontSize12,
                textAlign: TextAlign.start),
            verticalSpaceTiny,
            text_helper(
                size: fontSize10,
                data:
                    "Upon full payment by the Client, the Freelancer agrees to transfer all ownership rights of the Project, including but not limited to:",
                textAlign: TextAlign.start),
            text_helper(
                size: fontSize10,
                data: " * Source code, designs, and all associated files.",
                textAlign: TextAlign.start),
            text_helper(
                size: fontSize10,
                data: " * Intellectual property rights.",
                textAlign: TextAlign.start),
            text_helper(
                size: fontSize10,
                data: " * Documentation related to the Project.",
                textAlign: TextAlign.start),
            verticalSpaceSmall,
            text_helper(
                size: fontSize12,
                data: "3. Delivery Timeline",
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start),
            verticalSpaceTiny,
            text_helper(
                size: fontSize10,
                data:
                    "The Freelancer agrees to deliver the completed Project by 1 week. In case of delay, both parties agree to discuss and mutually decide on an updated timeline.",
                textAlign: TextAlign.start),
            verticalSpaceSmall,
            text_helper(
                size: fontSize12,
                data: "4. Revisions and Support",
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start),
            verticalSpaceTiny,
            text_helper(
                size: fontSize10,
                data:
                    " * Revisions: The Client is entitled to 3 revisions within 1 Week after project delivery.",
                textAlign: TextAlign.start),
            text_helper(
                size: fontSize10,
                data:
                    " * Support: The Freelancer will provide post-delivery support for 3 days.",
                textAlign: TextAlign.start),
            verticalSpaceSmall,
            text_helper(
                size: fontSize12,
                data: "5. Confidentiality",
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start),
            verticalSpaceTiny,
            text_helper(
                size: fontSize10,
                data:
                    "The Freelancer agrees to keep all information related to the Project and the Client's business confidential. This obligation remains in effect even after the completion of the Project.",
                textAlign: TextAlign.start),
            verticalSpaceSmall,
            text_helper(
                size: fontSize12,
                data: "6. Warranties and Representations",
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start),
            verticalSpaceTiny,
            text_helper(
                size: fontSize10,
                data:
                    " * The Project is original and does not infringe upon the rights of any third party.",
                textAlign: TextAlign.start),
            text_helper(
                size: fontSize10,
                data:
                    " * The Freelancer has the legal right to sell the Project.",
                textAlign: TextAlign.start),
            verticalSpaceSmall,
            text_helper(
                size: fontSize12,
                data: "7. Termination",
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start),
            verticalSpaceTiny,
            text_helper(
                size: fontSize10,
                data:
                    " * The Freelancer will retain ownership of the Project if payment has not been made in full.",
                textAlign: TextAlign.start),
            text_helper(
                size: fontSize10,
                data:
                    " * The Client must delete all files related to the Project if the termination is due to their non-compliance.",
                textAlign: TextAlign.start),
            verticalSpaceSmall,
            text_helper(
                size: fontSize12,
                data: "8. Dispute Resolution",
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start),
            verticalSpaceTiny,
            text_helper(
                size: fontSize10,
                data:
                    "In the event of a dispute, both Parties agree to first attempt mediation. If unresolved, disputes shall be submitted to arbitration in accordance with the laws of",
                textAlign: TextAlign.start),
            verticalSpaceLarge,
            // term and condition check
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    value: viewModel.check,
                    onChanged: (val) {
                      viewModel.check = val!;
                      viewModel.notifyListeners();
                    }),
                horizontalSpaceSmall,
                text_helper(data: "Terms and conditions")
              ],
            ),
            verticalSpaceLarge,
            // button to show pop up save
            button_helper(
                onpress: () {
                  if (type == "a") {
                    viewModel.booking(user, pro, context);
                  } else {
                    viewModel.addtocart(user, pro, context);
                  }
                },
                child: text_helper(data: type == "a" ? "Agree" : "Add to cart"))
          ],
        ),
      ),
    );
  }

  Widget t(BuildContext context, String data, String data2) {
    return Column(
      children: [
        Container(
          width: screenWidth(context),
          height: 1,
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text_helper(
                data: data,
                size: fontSize10,
                fontWeight: FontWeight.bold,
              ),
              horizontalSpaceSmall,
              Expanded(
                  child: text_helper(
                size: fontSize10,
                data: data2,
                textAlign: TextAlign.start,
              )),
            ],
          ),
        ),
        Container(
          width: screenWidth(context),
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }

  @override
  AgreementModel viewModelBuilder(
    BuildContext context,
  ) =>
      AgreementModel();
}
