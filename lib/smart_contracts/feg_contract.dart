import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import '../abis/abis.dart';



class FegContract extends ChangeNotifier {
  static final abi = Abis();
  static final signer = provider!.getSigner();
  final fegCtr = Contract(
    abi.fegAddress,
    Interface(abi.fegAbi),
    signer,
  );

  Future<String> getTokenName() async {
    String usrAdr = await signer.getAddress();
    var tokenName = "";
    try{
      // Get account balance
      tokenName = await fegCtr.call<String>('name');
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
      tokenAmount = await fegCtr.call<BigInt>(
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
    final tx = await fegCtr.send('transfer', [receivedAdr, amount]);
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
    final res = await fegCtr.call<BigInt>('allowance', [usrAdr, spender]);

    print("res : $res");
  }


  Future<bool> approve(amount) async {
    // 1 sart -> 1000 wei
    final tx = await fegCtr.send('approve', [fegCtr.address, amount]);
    tx.hash; // 0xbar

    final receipt = tx.wait(); // Wait until transaction complete

    var res = await receipt is TransactionReceipt;
    print("res : $res"); // if true => transaction success
    return res;
  }

}
