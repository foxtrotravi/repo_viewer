import 'package:flutter/material.dart';
import 'package:repo_viewer/auth/infrastructure/github_authenticator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthorizationPage extends StatefulWidget {
  final Uri authorizationUrl;
  final void Function(Uri redirectUrl) onAuthorizationCodeRedirectAttempt;

  const AuthorizationPage({
    super.key,
    required this.authorizationUrl,
    required this.onAuthorizationCodeRedirectAttempt,
  });

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  late final WebViewController webviewController;

  @override
  void initState() {
    webviewController = WebViewController();
    webviewController.clearCache();
    WebViewCookieManager().clearCookies();

    webviewController.loadRequest(widget.authorizationUrl);
    webviewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    webviewController.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (request) {
          if (request.url
              .startsWith(GithubAuthenticator.redirectUrl.toString())) {
            widget.onAuthorizationCodeRedirectAttempt(Uri.parse(request.url));
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(
          controller: webviewController,
        ),
      ),
    );
  }
}
