import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({super.key});
  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  late final WebViewController _controller;
  final TextEditingController _urlBar = TextEditingController(text: 'https://www.google.com');
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() => _loading = true),
        onPageFinished: (url) {
          setState(() {
            _loading = false;
            _urlBar.text = url;
          });
        },
      ))
      ..loadRequest(Uri.parse(_urlBar.text));
  }

  void _go(String input) {
    final isUrl = input.startsWith('http://') || input.startsWith('https://');
    final target = isUrl ? input : 'https://www.google.com/search?q=${Uri.encodeComponent(input)}';
    _controller.loadRequest(Uri.parse(target));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _urlBar,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search Google or type a URL',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onSubmitted: _go,
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => _controller.reload()),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading) const LinearProgressIndicator(minHeight: 2),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () async {
              if (await _controller.canGoBack()) _controller.goBack();
            }),
            IconButton(icon: const Icon(Icons.arrow_forward, color: Colors.white), onPressed: () async {
              if (await _controller.canGoForward()) _controller.goForward();
            }),
            IconButton(icon: const Icon(Icons.home, color: Colors.white), onPressed: () => _controller.loadRequest(Uri.parse('https://www.google.com'))),
            IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}
