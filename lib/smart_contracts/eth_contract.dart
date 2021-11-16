import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:privatesale/abis/testnetabis.dart';
import '../abis/abis.dart';



class EthContract extends ChangeNotifier {
  //static final abi = Abis();
  static final abi = TestnetAbis();
  static final signer = provider!.getSigner();
  final ethCtr = Contract(
    abi.ethAddress,
    Interface(abi.ethAbi),
    signer,
  );

  Future<int> getDecimal() async {
    return abi.ethDecimal;
  }

  Future<String> getTokenName() async {
    String usrAdr = await signer.getAddress();
    var tokenName = "";
    try{
      // Get account balance
      tokenName = await ethCtr.call<String>('name');
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
      tokenAmount = await ethCtr.call<BigInt>(
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
    final tx = await ethCtr.send('transfer', [receivedAdr, amount]);
    tx.hash; // 0xbar

    final receipt = tx.wait(); // Wait until transaction complete

    var res = await receipt is TransactionReceipt;
    print("res : $res"); // if true => transaction success
    return res;
  }

  Future<BigInt> allowance() async {
    print("--- Ask Allowance ---");
    String usrAdr = await signer.getAddress();
    // 1 sart -> 1000 wei
    // [owner,spender]
    final res = await ethCtr.call<BigInt>('allowance', [usrAdr, abi.presaleSmartContract]);

    print("allowance Res : $res");
    return res;
  }

  Future<bool> approve(amount) async {
    // 1 sart -> 1000 wei
    final tx = await ethCtr.send('approve', [abi.presaleSmartContract, amount]);
    tx.hash; // 0xbar

    final receipt = tx.wait(); // Wait until transaction complete

    var res = await receipt is TransactionReceipt;
    print("res : $res"); // if true => transaction success
    return res;
  }

}
