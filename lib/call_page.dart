// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// Package imports:
import 'package:zegocloud_app/common.dart';
import 'package:zegocloud_app/constants.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<StatefulWidget> createState() => CallPageState();
}

class CallPageState extends State<CallPage> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context)?.settings.arguments ?? <String, String>{})
            as Map<String, String>;
    final callID = arguments[PageParam.call_id] ?? '';

    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: 0 /*input your AppID*/,
        appSign:
            "" /*input your AppSign*/,
        userID: currentUser.id,
        userName: currentUser.name,
        callID: callID,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          /// support minimizing
          ..topMenuBar.isVisible = true
          ..topMenuBar.buttons = [
            ZegoCallMenuBarButtonName.minimizingButton,
            ZegoCallMenuBarButtonName.showMemberListButton,
            ZegoCallMenuBarButtonName.soundEffectButton,
          ]
          ..avatarBuilder = customAvatarBuilder,
      ),
    );
  }
}
