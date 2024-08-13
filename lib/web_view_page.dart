import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final controller = WebViewController(
    onPermissionRequest: (request) {
      if (request.types.contains(WebViewPermissionResourceType.microphone)) {
        request.grant();
      }
      if (request.types.contains(WebViewPermissionResourceType.camera)) {
        request.grant();
      }
    },
  )
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(
      Uri.parse('https://sia.development.scogo.ai/'),
    );

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  void requestPermissions() async {
    // Request microphone permission
    var microphoneStatus = await Permission.microphone.status;
    if (microphoneStatus.isDenied) {
      await Permission.microphone.request();
    }
    if (microphoneStatus.isPermanentlyDenied) {
      openAppSettings();
    }

    // Request camera permission
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      await Permission.camera.request();
    }
    if (cameraStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
