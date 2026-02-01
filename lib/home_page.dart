// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  /// Users who use the same callID can in the same call.
  final callIDTextCtrl = TextEditingController(text: 'call_id');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(top: 20, right: 10, child: logoutButton()),
            Positioned(
              top: 50,
              left: 10,
              child: Text('Your Phone Number: ${currentUser.id}'),
            ),
            joinCallContainer(),
          ],
        ),
      ),
    );
  }

  Widget logoutButton() {
    return Ink(
      width: 35,
      height: 35,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.redAccent,
      ),
      child: IconButton(
        icon: const Icon(Icons.exit_to_app_sharp),
        iconSize: 20,
        color: Colors.white,
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.remove(cacheUserIDKey);

          Navigator.pushNamed(context, PageRouteNames.login);
        },
      ),
    );
  }

  Future<void> _handleJoinCall() async {
    // 1. Check current status
    var cameraStatus = await Permission.camera.status;
    var micStatus = await Permission.microphone.status;

    // 2. If already granted, just proceed
    if (cameraStatus.isGranted && micStatus.isGranted) {
      _navigateToCall();
      return;
    }

    // 3. If permanently denied, must go to settings
    if (cameraStatus.isPermanentlyDenied || micStatus.isPermanentlyDenied) {
      _showSettingsDialog();
      return;
    }

    // 4. Request permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses[Permission.camera]!.isGranted &&
        statuses[Permission.microphone]!.isGranted) {
      _navigateToCall();
    } else if (statuses[Permission.camera]!.isPermanentlyDenied ||
        statuses[Permission.microphone]!.isPermanentlyDenied) {
      _showSettingsDialog();
    } else {
      _showPermissionDeniedSnackbar();
    }
  }

  void _navigateToCall() {
    if (!mounted) return;
    Navigator.pushNamed(
      context,
      PageRouteNames.call,
      arguments: <String, String>{
        PageParam.call_id: callIDTextCtrl.text.trim(),
      },
    );
  }

  void _showPermissionDeniedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Camera and Microphone permissions are required to start a video call.',
        ),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
          'You have permanently denied camera/microphone access. '
          'Please enable them in the app settings to use video calling.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await openAppSettings();
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Widget joinCallContainer() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                controller: callIDTextCtrl,
                decoration: const InputDecoration(
                  labelText: 'join a call by id',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _handleJoinCall,
              child: const Text('join'),
            ),
          ],
        ),
      ),
    );
  }
}
