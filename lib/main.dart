import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_cef/webview_cef.dart';
import 'package:window_manager/window_manager.dart';

const appTitle = "Guen's Travel & Tours";
const appUrl = 'https://test.guenstravel.com/';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow(
    const WindowOptions(
      title: appTitle,
      size: Size(1280, 800),
      minimumSize: Size(800, 600),
      center: true,
    ),
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );
  runApp(const GuensTravelApp());
}

class GuensTravelApp extends StatelessWidget {
  const GuensTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const WebShell(),
    );
  }
}

class WebShell extends StatefulWidget {
  const WebShell({super.key});

  @override
  State<WebShell> createState() => _WebShellState();
}

class _WebShellState extends State<WebShell> {
  late final WebViewController _controller;
  bool _offline = false;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = WebviewManager().createWebView(
      loading: const Center(child: CircularProgressIndicator()),
    );
    _start();
  }

  Future<bool> _hasConnection() async {
    try {
      final r = await InternetAddress.lookup(Uri.parse(appUrl).host)
          .timeout(const Duration(seconds: 6));
      return r.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _start() async {
    setState(() => _offline = false);
    if (!await _hasConnection()) {
      if (mounted) setState(() => _offline = true);
      return;
    }
    if (!_started) {
      await WebviewManager().initialize();
      await _controller.initialize(appUrl);
      _started = true;
    } else {
      await _controller.loadUrl(appUrl);
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    WebviewManager().quit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_offline) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 64),
              const SizedBox(height: 16),
              const Text('Pas de connexion Internet'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _start,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _controller,
        builder: (context, _, _) => _controller.value
            ? _controller.webviewWidget
            : _controller.loadingWidget,
      ),
    );
  }
}
