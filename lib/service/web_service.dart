import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chapasdk/chapawebview.dart';
import 'package:chapasdk/constants/url.dart';
import 'package:chapasdk/constants/utils.dart';
import 'package:chapasdk/model/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Object> intilizeMyPayment(
  BuildContext context,
  String authorization,
  String email,
  String amount,
  String currency,
  String firstName,
  String lastName,
  String companyName,
  String customTitle,
  String customDescription,
  String fallBackNamedRoute,
  String mobile,
  Map<String, dynamic>? meta,
  Map<String, dynamic>? order,
  List<Map<String, dynamic>>? products,
) async {
  String generatedTransactionRef = generateTransactionReference(companyName);

  // Flatten the meta map
  final flattenedMeta = flattenMeta(meta ?? {});

  // Prepare the request body
  final requestBody = {
    'email': email,
    'amount': amount,
    'currency': currency.toUpperCase(),
    'first_name': firstName,
    'last_name': lastName,
    'tx_ref': generatedTransactionRef,
    'customization[title]': customTitle,
    'customization[description]': customDescription,
    'mobile': mobile,
    ...flattenedMeta, // Add flattened meta data
  };

  final http.Response response = await http.post(
    Uri.parse(ChapaUrl.baseUrl),
    headers: {
      'Authorization': 'Bearer $authorization',
    },
    body: requestBody,
  );

  var jsonResponse = json.decode(response.body);
  if (response.statusCode == 400) {
    showToast(jsonResponse['message']);
  } else if (response.statusCode == 200) {
    ResponseData res = ResponseData.fromJson(jsonResponse);
    log("CHAPA CHECKOUT URL: ${res.data.checkoutUrl}");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChapaWebView(
                url: res.data.checkoutUrl.toString(),
                fallBackNamedUrl: fallBackNamedRoute,
                ttx: generatedTransactionRef,
                order: order,
                products: products,
              )),
    );

    return res.data.checkoutUrl.toString();
  }

  return showToast(jsonResponse.toString());
}

Map<String, String> flattenMeta(Map<String, dynamic> meta) {
  final flattened = <String, String>{};

  meta.forEach((key, value) {
    flattened['meta[$key]'] = value.toString();
  });

  return flattened;
}
