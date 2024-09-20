import 'dart:async';

import 'package:chapasdk/constants/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'constants/common.dart';

class ChapaWebView extends StatefulWidget {
  final String url;
  final String fallBackNamedUrl;
  final String ttx;
  final Map<String, dynamic>? order;
  final List<Map<String, dynamic>>? products;

  const ChapaWebView(
      {Key? key,
      required this.url,
      required this.fallBackNamedUrl,
      required this.ttx,
      this.order,
      this.products})
      : super(key: key);

  @override
  State<ChapaWebView> createState() => _ChapaWebViewState();
}

class _ChapaWebViewState extends State<ChapaWebView> {
  late InAppWebViewController webViewController;
  String url = "";
  double progress = 0;
  StreamSubscription? connection;
  bool isOffline = false;

  @override
  void initState() {
    checkConnectivity();

    super.initState();
  }

  void checkConnectivity() {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isEmpty || results.contains(ConnectivityResult.none)) {
        setState(() {
          isOffline = true;
        });
        showErrorToast(ChapaStrings.connectionError);
        exitPaymentPage(ChapaStrings.connectionError, widget.ttx, false);
      } else {
        setState(() {
          isOffline = false;
        });

        // If you need to handle specific connection types, you can check them:
        if (results.contains(ConnectivityResult.bluetooth)) {
          exitPaymentPage(ChapaStrings.connectionError, widget.ttx, false);
        }
      }
    });
  }

  void exitPaymentPage(String message, String ttx, bool res) {
    Navigator.pushNamed(
      context,
      widget.fallBackNamedUrl,
      arguments: {
        'message': message,
        'ttx': ttx,
        'status': res,
        'order': widget.order ?? {},
        'products': widget.products ?? [],
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    connection!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // status bar icon color to white
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(children: <Widget>[
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              onWebViewCreated: (controller) {
                setState(() {
                  webViewController = controller;
                });
                controller.addJavaScriptHandler(
                    handlerName: ChapaStrings.buttonHandler,
                    callback: (args) async {
                      webViewController = controller;

                      if (args[2][1] == ChapaStrings.cancelClicked) {
                        exitPaymentPage(
                            ChapaStrings.paymentCancelled, "", false);
                      }

                      return args.reduce((curr, next) => curr + next);
                    });
              },
              onUpdateVisitedHistory: (InAppWebViewController controller,
                  Uri? uri, androidIsReload) async {
                if (uri.toString() == 'https://chapa.co') {
                  exitPaymentPage(
                      ChapaStrings.paymentSuccessful, widget.ttx, false);
                }
                if (uri.toString().contains('checkout/payment-receipt/')) {
                  await delay();
                  exitPaymentPage(
                      ChapaStrings.paymentSuccessful, widget.ttx, false);
                }
                if (uri.toString().contains('checkout/test-payment-receipt/')) {
                  await delay();
                  exitPaymentPage(
                      ChapaStrings.paymentSuccessful, widget.ttx, false);
                }
                controller.addJavaScriptHandler(
                    handlerName: ChapaStrings.handlerArgs,
                    callback: (args) async {
                      webViewController = controller;

                      if (args[2][1] == ChapaStrings.failed) {
                        await delay();
                        exitPaymentPage(ChapaStrings.payementFailed, "", false);
                      }
                      if (args[2][1] == ChapaStrings.success) {
                        await delay();
                        exitPaymentPage(
                            ChapaStrings.paymentSuccessful, widget.ttx, true);
                      }
                      return args.reduce((curr, next) => curr + next);
                    });

                controller.addJavaScriptHandler(
                    handlerName: ChapaStrings.buttonHandler,
                    callback: (args) async {
                      webViewController = controller;

                      if (args[2][1] == ChapaStrings.cancelClicked) {
                        exitPaymentPage(
                            ChapaStrings.paymentCancelled, "", false);
                      }

                      return args.reduce((curr, next) => curr + next);
                    });
              },
            ),
          ),
        ]),
      ),
    );
  }
}
