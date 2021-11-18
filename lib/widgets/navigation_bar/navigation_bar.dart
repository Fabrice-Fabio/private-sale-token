import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:privatesale/wallet/metamaskprovider.dart';
import 'package:privatesale/wallet/walletprovider.dart';
import 'package:privatesale/widgets/connect_wallet/connect_wallet.dart';
import 'package:provider/provider.dart';
import 'dart:js' as js;

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 992) {
          return desktopNavBar(context);
        } else {
          return mobileNavBar(context);
        }},);
  }
}

Widget desktopNavBar(context){
  return Container(
    height: 100,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          child: Row(
            children: [
              SizedBox(height: 80,width: 150, child: Image.asset("assets/logo.png"),),
              Text("PRIVATESALE",  style: TextStyle(fontSize: 18, color: Colors.red[500], fontWeight: FontWeight.w600),)
            ],
          ),
          onTap: (){Navigator.pushNamed(context, '/');},
        ),
        Consumer<WalletProvider>(
            builder: (context, provider, child) {
              print("fuck222: ${provider.currentAddress}");
              return Text(provider.currentAddress);
            }
        ),
        Row(
          children: [
            //ethereum != null ? ConnectWallet(parentContext: context) : Text("Web 3 not supported"),
            ethereum != null ? ConnectWallet() : Text("Web 3 not supported"),
          ],
        )
      ],
    ),
  );
}

Widget mobileNavBar(context){
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            /// TODO : put my logo in bckground
            image: DecorationImage(image: AssetImage("assets/logo.png")),
            color: Colors.red,
          ),
          child: Center(child: Text('PRIVATESALE',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),)),
        ),
        /// TODO layourbuilder check mobile device and display
        ListTile(title: Text('0x1d681e190cdf38bCc3912c5d1a51328a20E61C84',),),
        const Divider(thickness: 1,color: Colors.grey,),
        ListTile(title: mobileWalletBtn(),),
      ],
    ),
  );
}


Widget mobileWalletBtn(){
  String title = "Wallet connect";

  Future<String> connectMobileW3() async {
    print("Try wallet connection connectW3");
    var currentAddress="";
    var currentChain = 56;
    final wc = WalletConnectProvider.fromRpc(
      {56: 'https://bsc-dataseed.binance.org/'},
      chainId: 56,
      network: 'binance',
    );
    await wc.connect();
    if (wc.connected) {
      currentAddress = wc.accounts.first;
      currentChain = wc.chainId as int;
    }
    final web3provider = Web3Provider.fromWalletConnect(wc);

    /// 1BNB = 1000000000000000000000
    var getUserBalance = await web3provider.getBalance(currentAddress); // it will display bigInt xn0

    print("currentAddress : $currentAddress");
    print("currentChain : $currentChain");
    print("balance : $getUserBalance");

    return currentAddress;
  }

  return InkWell(
    child: Container(
      width: 250,
      padding: EdgeInsets.symmetric(horizontal: 60,vertical: 15),
      child: Text(title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),),
      decoration: BoxDecoration(
        color: Color.fromARGB(227, 229, 120, 37),
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    onTap: () async =>  {
      //context.read<MetaMaskProvider>().connect(),
      connectMobileW3(),
    },
  );
}

class _NavBarItem extends StatelessWidget {
  final String title;
  final String url;
  const _NavBarItem({required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 992) {
          return InkWell(
            child: Text(title, style: TextStyle(fontSize: 15),),
            onTap: () async => {
              if(title == 'SexShop'){
                Navigator.pushNamed(context, '/marketplace')
              }else{
                js.context.callMethod('open', [url]),
              }
            },
          );
        } else {
          return ListTile(
              title: Text(title,style: TextStyle(color: Colors.black),),
              onTap: () async => {
                if(title == 'SexShop'){
                  Navigator.pushNamed(context, '/marketplace')
                }else{
                  js.context.callMethod('open', [url]),
                }
              }
          );
        }},);
  }
}

