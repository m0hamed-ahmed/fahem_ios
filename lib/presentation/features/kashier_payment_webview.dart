import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KashierPaymentScreen extends StatefulWidget {
  final String pageLink;

  const KashierPaymentScreen({super.key, required this.pageLink});

  @override
  State<KashierPaymentScreen> createState() => _KashierPaymentScreenState();
}

class _KashierPaymentScreenState extends State<KashierPaymentScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('https://www.youtube.com/')) {
          //     return NavigationDecision.prevent;
          //   }
          //   return NavigationDecision.navigate;
          // },
        ))
      ..loadRequest(Uri.parse(widget.pageLink));
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    }
    else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}