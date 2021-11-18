import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';

class WalletProvider with ChangeNotifier {

  static const mainChain = 56;
  static const testnetChain = 97;

  //final web3provider = Web3Provider(ethereum!);
  static const operatingChain = testnetChain;

  String currentAddress = "";

  BigInt getUserBalance = BigInt.zero;


  /// Test with streambuilder

  StreamController<BigInt> balanceController = StreamController<BigInt>(); // Declare stream var
  Stream<BigInt> get getBalanceStream => balanceController.stream; // func return stream value

  /// Streambuilder Test

  int currentChain = -1;

  bool get isEnabled => ethereum != null;

  bool get isInOperatingChain => currentChain == operatingChain;

  bool get isConnected => isEnabled && currentAddress.isNotEmpty;

  bool wcConnected = false;

  /// Check if wc will be log with walletconnect or not
  final wc = mainChain == 56 ?
  WalletConnectProvider.fromRpc(
    {56: 'https://bsc-dataseed.binance.org/'},
    chainId: 56,
    network: 'binance',
  ) :
  WalletConnectProvider.fromRpc(
    {97: 'https://data-seed-prebsc-1-s1.binance.org:8545/'},
    chainId: 97,
    network: 'binance',
  );

  Future<void> connectProvider() async {

    if(isEnabled){
      print("✨----Metamask connection----✨");
      try {
        final accs = await ethereum!.requestAccount();
        print("accs : $accs");// Get all accounts in node disposal
        if(accs.isNotEmpty) currentAddress = accs.first;
        currentChain = await ethereum!.getChainId();

        if(isConnected) {
          /// 1BNB = 1000000000000000000000
          getUserBalance = await provider!.getBalance(currentAddress); // it will display bigInt xn0
          print("getNetwork : ${await provider!.getNetwork()}");
        }

        /*balanceController.add(getUserBalance);

        balanceController.stream.listen((event) {
          print("balanceController : $event");
        });*/


        print("currentAddress : $currentAddress");
        print("currentChain : $currentChain");
        print("balance : $getUserBalance");
      } on EthereumUserRejected {
        print('User rejected the modal');
      }

      notifyListeners();
    }
  }

  Future<void> connectW3() async {
    print("ConnectW3");

    print("Try wallet connection connectW3");
    await wc.connect();
    if (wc.connected) {
      currentAddress = wc.accounts.first;
      currentChain = wc.chainId as int;
      wcConnected = true;
    }
    final web3provider = Web3Provider.fromWalletConnect(wc);

    if(isConnected){
      /// 1BNB = 1000000000000000000000
      getUserBalance = await web3provider.getBalance(currentAddress); // it will display bigInt xn0
    }

    print("currentAddress : $currentAddress");
    print("currentChain : $currentChain");
    print("balance : $getUserBalance");

    notifyListeners();
  }

  clear() {
    currentAddress = "";
    currentChain = -1;
    notifyListeners();
  }

  init() {
    if(isEnabled){
      ethereum!.onAccountsChanged((accounts) {
        print("onAccountsChanged : "+accounts.toString());
        connectProvider();
        clear();
      });
      ethereum!.onChainChanged((chainId) {
        connectProvider();
        clear(); // foo
      });
    }
  }
}