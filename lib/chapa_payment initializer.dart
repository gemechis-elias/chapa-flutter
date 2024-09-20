import 'package:chapasdk/service/web_service.dart';
import 'package:flutter/material.dart';

import 'constants/common.dart';
import 'constants/strings.dart';

class Chapa {
  BuildContext context;
  String publicKey;
  String amount;
  String currency;
  String email;
  String firstName;
  String lastName;
  String companyName;
  String title;
  String desc;
  String namedRouteFallBack;
  String mobile;
  Map<String, dynamic>? meta;
  Map<String, dynamic>? order;
  List<Map<String, dynamic>>? products;

  Chapa.paymentParameters({
    required this.context,
    required this.publicKey,
    required this.currency,
    required this.amount,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.companyName,
    required this.title,
    required this.desc,
    required this.namedRouteFallBack,
    required this.mobile,
     this.meta,
     this.order,
     this.products,
  }) {
    validateKeys();
    currency = currency.toUpperCase();
    if (validateKeys()) {
      initPayment();
    }
  }

  bool validateKeys() {
    if (publicKey.trim().isEmpty) {
      showErrorToast(ChapaStrings.publicKeyRequired);
      return false;
    }
    if (currency.trim().isEmpty) {
      showErrorToast(ChapaStrings.currencyRequired);
      return false;
    }
    if (amount.trim().isEmpty) {
      showErrorToast(ChapaStrings.amountRequired);
      return false;
    }
    if (email.trim().isEmpty) {
      showErrorToast(ChapaStrings.emailRequired);
      return false;
    }

    if (firstName.trim().isEmpty) {
      showErrorToast(ChapaStrings.firstNameRequired);
      return false;
    }
    if (lastName.trim().isEmpty) {
      showErrorToast(ChapaStrings.lastNameRequired);
      return false;
    }
    if (companyName.trim().isEmpty) {
      showErrorToast(ChapaStrings.transactionRefrenceRequired);
      return false;
    }
    if (mobile.trim().isEmpty) {
      showErrorToast(ChapaStrings.mobile);
      return false;
    }
   

    return true;
  }

  void initPayment() async {
    intilizeMyPayment(
        context,
        publicKey,
        email,
        amount,
        currency,
        firstName,
        lastName,
        companyName,
        title,
        desc,
        namedRouteFallBack,
        mobile,
        meta,
        order,
        products);
  }
}
