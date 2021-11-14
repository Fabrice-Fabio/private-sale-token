import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:privatesale/smart_contracts/smart_contracts_index.dart';
import 'package:privatesale/views/home_desktop_page.dart';
import 'package:privatesale/views/home_mobile_page.dart';
import 'package:privatesale/wallet/walletprovider.dart';
import 'package:privatesale/widgets/centered_view/centered_view.dart';
import 'package:privatesale/widgets/navigation_bar/navigation_bar.dart';
import 'package:privatesale/widgets/utils/export_utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
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
    return ChangeNotifierProvider(
      create: (context)=> WalletProvider()..init(),
      builder: (contextProv, snapshot) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 992) {
              return HomeDesktopPage(paymentData: paymentData,);
            } else {
              return HomeMobilePage(paymentData: paymentData);
            }},);
      },
    );
  }
}

