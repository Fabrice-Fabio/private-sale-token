import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privatesale/views/home_desktop_page.dart';
import 'package:privatesale/views/home_mobile_page.dart';

class HomePage extends StatefulWidget {
  final String routeName = '/';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List paymentData = [];

  Future<String> getPaymentData() async {
    var paymentJson = await rootBundle.loadString("/data/paymentMethod.json");
    setState(() {
      paymentData = json.decode(paymentJson);
    });
    return 'success';
  }

  @override
  void initState() {
    // TODO: implement initState
    getPaymentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 992) {
          return HomeDesktopPage(paymentData: paymentData,);
        } else {
          return HomeMobilePage(paymentData: paymentData);
        }},);
  }
}

