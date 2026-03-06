import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/wled_device.dart';

class WebViewScreen extends StatefulWidget {
  final WledDevice? device;
  final String? url;
  final String? title;

  const WebViewScreen({super.key, this.device, this.url, this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? controller;
  bool isLoading = true;
  bool useExternalBrowser = false;

  @override
  void initState() {
    super.initState();
    final targetUrl = widget.url ?? 'http://${widget.device!.ip}';

    // WebView2 on Windows is notoriously unstable in flutter without complex setup.
    // We fall back to standard external browser on Desktop.
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      useExternalBrowser = true;
      _launchExternal(targetUrl);
    } else {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(targetUrl));
    }
  }

  Future<void> _launchExternal(String urlStr) async {
    final uri = Uri.parse(urlStr);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        // handle fail
      }
    } catch (e) {
      // ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    if (useExternalBrowser) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? widget.device?.name ?? 'WLED'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.open_in_new, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Geopend in externe browser',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () {
                  final targetUrl = widget.url ?? 'http://${widget.device!.ip}';
                  _launchExternal(targetUrl);
                },
                child: const Text('Opnieuw openen'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? widget.device?.name ?? 'WLED'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              controller?.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (controller != null) WebViewWidget(controller: controller!),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
