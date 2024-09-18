
# Chapa Flutter SDK

Chapa Flutter sdk for Chapa payment API. It is not official and is not supported by Chapa. It is provided as-is. The main features of this library is it supports connectivity tests, auto reroutes, parameter checks for payment options.



## API Reference

#### Create new transaction from mobile end point

Base end point
https://api.chapa.co/v1

```http
  POST /transaction/mobile-initialize
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `key`      | `string` | **Required**. This will be your public key from Chapa. When on test mode use the test key, and when on live mode use the live key. |
| `email`    | `string` | **Required**. A customer’s email. address. |
| `amount`   | `string` | **Required**. The amount you will be charging your customer. |
| `first_name` | `string` | **Required**. A customer’s first name. |
| `last_name`      | `string` | **Required**. Acustomer's last name. |
| `tx_ref`   | `string` | **Required**. A unique reference given to each transaction. |
| `currency` | `string` | **Required**. The currency in which all the charges are made. i.e ETB, USD |
| `callback_url`| `string` |  The URL to redirect the customer to after payment is done.|
| `customization[title]`| `string` |  The customizations field (optional) allows you to customize the look and feel of the payment modal.|

#### SDK requires additional parameter for fallBack page which is named route which will help you reroute webview after payment completed, on internate disconnected and many more



| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `namedRouteFallBack`      | `string` | **Required by the sdk**. This will accepted route name in String, After successfull transaction the app will direct to this page with neccessary information for flutter developers to update the backend or to regenerate new transaction refrence. |




## Installation

Installation instructions comming soon its better if you install it from pub dev



## Usage/Example

```flutter
import 'package:chapasdk/chapasdk.dart';


Chapa.paymentParameters(
        context: context, // context 
        publicKey: 'CHASECK_TEST--------------',
        currency: 'ETB',
        amount: '200',
        email: 'xyz@gmail.com',
        firstName: 'fullName',
        lastName: 'lastName',
        companyName: 'XYZCrop',
        title: 'title',
        desc:'desc',
        namedRouteFallBack: '/second', // fall back route name
       );
```


## FAQ

#### Should my fallBack route should be named route?

Answer Yes, the fallBackRoute comes with an information such as payment is successfully, user cancelled payment and connectivity issue messages. Those informations will help you to update your backend, to generate new transaction refrence.

#### what is invalid key mean?

Answer If you get an invalid key error try to generate new key or use test secrete key while testing.

#### why company name is required?

Answer in the old version ttx will be handled by developer and this version supports automatic generation of ttx reference for company name.

## Demo

screen shots

https://ethiomappsgebeta.com/image_one.jpg
https://ethiomappsgebeta.com/image_two.jpg
https://ethiomappsgebeta.com/image_three.jpg
