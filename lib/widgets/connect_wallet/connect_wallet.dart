import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:privatesale/wallet/walletprovider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class ConnectWallet extends StatefulWidget {
  final BuildContext parentContext;
  const ConnectWallet({Key? key, required this.parentContext}) : super(key: key);

  @override
  State<ConnectWallet> createState() => _ConnectWalletState();
}

class _ConnectWalletState extends State<ConnectWallet> {

  showAlertDialog(BuildContext context, BuildContext currentContext) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Connect Wallet"),
          content: Container(
            width: 200,
            color: Colors.white,
            child: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    title: Text("Metamask",style: TextStyle(color: Colors.black),),
                    trailing: Image.asset("assets/metamask.png"),
                    onTap: (){
                      print("Metamask");
                      WalletProvider().connectProvider();
                      Navigator.pop(context);
                    },
                  ),
                  Divider(thickness: 2,color: Colors.green,),
                  ListTile(
                    title: Text("Wallet Connect",style: TextStyle(color: Colors.black),),
                    trailing: Image.asset("assets/walletcon.png"),
                    onTap: (){
                      print("Wallet Connect");
                      currentContext.read<WalletProvider>().connectW3();
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  showSnackBar(message,context,bckcolor) {
    final snackBar = SnackBar(
      backgroundColor: bckcolor,
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    String titleConnect="Connect to Wallet";
    return ChangeNotifierProvider(
      create: (context)=> WalletProvider()..init(),
      builder: (context, snapshot) {
        return Consumer<WalletProvider>(
            builder: (contextCosum, provider, child) {
              /// TODO : mettre ceci à la place de l'endroit ou j'affiche l'adr de l'user pour afficher des messages d'erreurs en cas d'erreur
              if(provider.isConnected && provider.isInOperatingChain) {
                print("--Connection success--");
                if(provider.currentAddress != "") {
                  titleConnect = provider.currentAddress;
                }
              }else if(!provider.isConnected && !provider.isInOperatingChain){
                  print("Wrong chain. PLease connect to ${WalletProvider.operatingChain}");
              }else if(provider.isEnabled){
                print("Enable to use metamask");
              } else {
                print("Please use a web3 supported browser");
              }

              return InkWell(
                child: Container(
                  width: 250,
                  padding: EdgeInsets.symmetric(horizontal: 60,vertical: 15),
                  child: Text(titleConnect,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(227, 229, 120, 37),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onTap: ()=>{
                  //context.read<MetaMaskProvider>().connect(),
                  showAlertDialog(widget.parentContext,contextCosum),
                },
              );
            }
        );
      },
    );
  }
}
