import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Homescreen> {
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Stripe Payment"),
        ),
        body: Center(
          child: TextButton(
            onPressed: () {
              payment();
            },
            child: Text(" Buy Now"),
          ),
        ));
  }

  Future<void> payment() async {
    //Step 1 Payment intent
    try {
      // ignore: unused_local_variable
      Map<String, dynamic> body = {
        'amount': 10000,
        'currency': "Rps",
      };

      // ignore: unused_local_variable
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51NFyS1SJ5R3F423DKhGaGTlIvz5eOxOO1kjU3pof03rn6g0YG0Ixd0JmuJ9w3LorfLoztxsTJ5gxCCPGBDdgTWeH00LhWrVQx6',
          'Content-type': 'application/x-www-form-urlencoded'
        },
      );

      paymentIntent = json.decode(response.body);
    } catch (error) {
      throw Exception(error);
    }

    //Step 2 Initialize payment sheet

    await Stripe.instance
        .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntent!['client_secret'],
                style: ThemeMode.light,
                merchantDisplayName: 'Chiara'))
        .then((value) => {});

    //Step 3 Display payment sheet
    try {
      await Stripe.instance.presentPaymentSheet().then((value) => {
            //Succeess State
            print("Payment Success")
          });
    } catch (error) {}
  }
}
