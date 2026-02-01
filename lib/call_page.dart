// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// Package imports:
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
        appID: int.parse(dotenv.env['ZEGO_APP_ID'] ?? '0'),
        appSign: dotenv.env['ZEGO_APP_SIGN'] ?? '',
        userID: currentUser.id,
        userName: currentUser.name,
        callID: callID,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          ..turnOnCameraWhenJoining = true
          ..turnOnMicrophoneWhenJoining = true
          ..useSpeakerWhenJoining = true
          ..bottomMenuBar = ZegoCallBottomMenuBarConfig(
            buttons: [
              ZegoCallMenuBarButtonName.toggleCameraButton,
              ZegoCallMenuBarButtonName.toggleMicrophoneButton,
              ZegoCallMenuBarButtonName.hangUpButton,
            ],
          )
          ..topMenuBar.isVisible = false
          ..audioVideoView = ZegoCallAudioVideoViewConfig(
            useVideoViewAspectFill: true,
            showUserNameOnView: false,
            showCameraStateOnView: false,
            showMicrophoneStateOnView: false,
          ),
      ),
    );
  }
}
