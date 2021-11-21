import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:privatesale/abis/testnetabis.dart';
import '../abis/abis.dart';



class SartContract extends ChangeNotifier {
  //static final abi = Abis();
  static final abi = TestnetAbis();
  static final signer = provider!.getSigner();
  final sartCtr = Contract(
    abi.sartAddress,
    Interface(abi.sartAbi),
    signer,
  );

  Future<void> getTokenInfo() async {
    String usrAdr = await signer.getAddress();
    try{
      // Get account balance
      var tokenName = await sartCtr.call<String>('name');
      var tokenAmount = await sartCtr.call<BigInt>(
        'balanceOf',
        [usrAdr], // getUserCurrentAddress
        //provider!.getSigner().getAddress().toString()
      );
      debugPrint("name : $tokenName");
      debugPrint("amount : ${tokenAmount.toString()}");
    }catch(e){
      debugPrint('err = $e');
    }

  }

  Future<void> getTokenInfoB() async {
    String usrAdr = await signer.getAddress();
    try{
      final token = ContractERC20(abi.sartAddress, signer);

      var tokenName = await token.name; // foo
      var tokenAmount = await token.balanceOf(usrAdr);

      print("name : $tokenName");
      print("amount : ${tokenAmount.toString()}");// baz
    }catch(e){
      print('err = $e');
    }

  }

  Future<void> sendTokenToAnotherAdr() async {

    // 1 sart -> 1000 wei
    final tx = await sartCtr.send('transfer', ['0xc7bca4e03F765f2d9Ec35C61C52628DF2036fE1e', '1000']);
    tx.hash; // 0xbar

    final receipt = tx.wait(); // Wait until transaction complete

    var res = await receipt is TransactionReceipt;
    print("res : $res"); // if true => transaction success
  }

}
