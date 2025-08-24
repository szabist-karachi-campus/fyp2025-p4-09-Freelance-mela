import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  final String callID;
  final String userName;
  final String userID;

  const CallPage({
    Key? key,
    required this.callID,
    required this.userName,
    required this.userID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ZegoUIKitPrebuiltCall(
          appID: 300181022,
          appSign: '3ca082f537d2a37860507c070002f8b00598bf6e478a865ed28f176b6a2b1e04',
          userID: userID,
          userName: userName,
          callID: callID,
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
        ),
      ),
    );
  }
}
