import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final query = ModalRoute.of(context)!.settings.arguments as String;
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.google.com/search?q=$query'));

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
