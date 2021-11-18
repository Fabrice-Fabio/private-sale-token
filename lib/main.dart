import 'package:flutter/material.dart';
import 'package:privatesale/views/home_page.dart';
import 'package:privatesale/wallet/walletprovider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WalletProvider()..init()),
      ],
      child: MaterialApp(
        title: 'PRIVATESALE',
        debugShowCheckedModeBanner: false,
        initialRoute: HomePage().routeName,
        routes: {
          HomePage().routeName : (context) => HomePage(),
          //'/marketplace': (context) => MarketPlace(),
        },
      ),
    );
  }
}