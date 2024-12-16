import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final WebViewController _controller;
  String? _htmlContent;

  @override
  void initState() {
    super.initState();
    _loadHtmlFromAssets();
    _controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  Future<void> _loadHtmlFromAssets() async {
    // Load the HTML file content as a string
    final htmlContent = await rootBundle.loadString('assets/3d_example.html');
    setState(() {
      _htmlContent = htmlContent;
    });
    // Load HTML content in WebView after controller is ready
    _controller.loadHtmlString(_htmlContent!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom HTML from Asset')),
      body: _htmlContent == null
          ? const Center(child: CircularProgressIndicator(color: Colors.black,))
          : WebViewWidget(controller: _controller),
    );
  }
}