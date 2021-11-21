import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:privatesale/abis/testnetabis.dart';
import '../abis/abis.dart';



class PresaleContract extends ChangeNotifier {
  //static final abi = Abis();
  static final abi = TestnetAbis();
  static final signer = provider!.getSigner();
  final presaleCtr = Contract(
    abi.presaleSmartContract,
    Interface(abi.presaleSCAbi),
    signer,
  );



  Future<bool> joinWithBNB(BigInt amount) async {
    debugPrint("Ask-joinWithBNB");
    final tx = await presaleCtr.send('joinWithBNB', [amount]);
    tx.hash; // 0xbar
    debugPrint("hash : ${tx.hash}");

    final receipt = tx.wait(); // Wait until transaction complete

    var res = await receipt is TransactionReceipt;
    debugPrint("res : $res"); // if true => transaction success
    return res;
  }

  Future<bool> joinWithMultiCoin(String Bep20Address, BigInt Bep20Amount, BigInt tokenAmount, BigInt bnbAmount) async {
    debugPrint("Ask-joinWithMultiCoin");
    // 16 => privatecode;
    bool res = false;
    final tx = await presaleCtr.send('joinWithMultiCoin', [Bep20Address,Bep20Amount,tokenAmount,bnbAmount,16]);
    tx.hash; // 0xbar

    final receipt = tx.wait(); // Wait until transaction complete

    res = await receipt is TransactionReceipt;
    debugPrint("res : $res"); // if true => transaction success
    return res;
  }

}
