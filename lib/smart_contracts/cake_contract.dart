import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import '../abis/abis.dart';



class CakeContract extends ChangeNotifier {
  static final abi = Abis();
  static final signer = provider!.getSigner();
  final cakeCtr = Contract(
    abi.cakeAddress,
    Interface(abi.cakeAbi),
    signer,
  );

  Future<String> getTokenName() async {
    String usrAdr = await signer.getAddress();
    var tokenName = "";
    try{
      // Get account balance
      tokenName = await cakeCtr.call<String>('name');
      print("name : $tokenName");
      return tokenName;
    }catch(e){
      print('err = $e');
      return tokenName;
    }
  }

  Future<BigInt> getTokenBalance() async {
    String usrAdr = await signer.getAddress();
    BigInt tokenAmount = BigInt.zero;
    try{
      // Get account balance
      tokenAmount = await cakeCtr.call<BigInt>(
        'balanceOf',
        [usrAdr], // getUserCurrentAddress
      );
      print("tokenAmount : $tokenAmount");
      return tokenAmount;
    }catch(e){
      print('err = $e');
      return tokenAmount;
    }
  }

  Future<bool> transfer(receivedAdr,amount) async {
    // 1 sart -> 1000 wei
    final tx = await cakeCtr.send('transfer', [receivedAdr, amount]);
    tx.hash; // 0xbar

    final receipt = tx.wait(); // Wait until transaction complete

    var res = await receipt is TransactionReceipt;
    print("res : $res"); // if true => transaction success
    return res;
  }

  Future<void> allowance(amount,spender) async {
    String usrAdr = await signer.getAddress();
    // 1 sart -> 1000 wei
    // [owner,spender]
    final res = await cakeCtr.call<BigInt>('allowance', [usrAdr, spender]);

    print("res : $res");
  }


  Future<bool> approve(amount) async {
    // 1 sart -> 1000 wei
    final tx = await cakeCtr.send('approve', [cakeCtr.address, amount]);
    tx.hash; // 0xbar

    final receipt = tx.wait(); // Wait until transaction complete

    var res = await receipt is TransactionReceipt;
    print("res : $res"); // if true => transaction success
    return res;
  }

}
