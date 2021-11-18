import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:privatesale/api/api.dart';
import 'package:privatesale/smart_contracts/btc_contract.dart';
import 'package:privatesale/smart_contracts/eth_contract.dart';
import 'package:privatesale/smart_contracts/smart_contracts_index.dart';
import 'package:privatesale/smart_contracts/usdc_contract.dart';
import 'package:privatesale/smart_contracts/usdt_contract.dart';
import 'package:privatesale/wallet/walletprovider.dart';
import 'package:privatesale/widgets/centered_view/centered_view.dart';
import 'package:privatesale/widgets/navigation_bar/navigation_bar.dart';
import 'package:privatesale/widgets/utils/export_utils.dart';
import 'package:provider/provider.dart';

class HomeDesktopPage extends StatefulWidget {
  final paymentData;
  const HomeDesktopPage({Key? key, required this.paymentData}) : super(key: key);

  @override
  _HomeDesktopPageState createState() => _HomeDesktopPageState();
}

class _HomeDesktopPageState extends State<HomeDesktopPage> {
  int? val = 1;
  String cryptochoose = "BNB";
  int currentValSelected = 0;
  TextEditingController amountController = TextEditingController();

  BigInt currentTokenBalance = BigInt.zero;
  int currentDecimal = 0;
  int currentAllowance = 0;


  getBalanceWithoutDecimal(BigInt tokenBalance,int decimal){
    print("---tokenBalance : $tokenBalance && decimal : $decimal ---");
    /*double res = tokenBalance.toDouble();
    print("double token : $res");*/
    int tokenBalanceToInt = tokenBalance.toInt();
    print("int token : $tokenBalanceToInt");

    var res = tokenBalanceToInt/pow(10, decimal);

    print("res final : $res");
    return res;
  }

  alreadyApprove(){
    print("alreadyApprove-currentAllowance : $currentAllowance");
    print("alreadyApprove-balance : ${getBalanceWithoutDecimal(currentTokenBalance,currentDecimal)}");
    //
    if(currentAllowance<=0 || currentAllowance < currentTokenBalance.toInt()){
      return false;
    }else{
      return true;
    }
  }
  
  approveFunc() async {
    print("approve check allowance : $currentAllowance");
    if(cryptochoose == "BTC"){
      BtcContract().approve(currentTokenBalance)
          .then((res) => {
            // TODO : afficher un loader le temps que la res passe à true
            print("Approve res : $res"),
      });
    }
  }

  buy(){}

  getCurrentCryptoInfo() async {
    /// currentTokenBalance is BigInt (token balance with exp value)
    BigInt balance = BigInt.zero;
    currentTokenBalance = balance; /// Initialize to BigInt.zero at each call
    if(cryptochoose == "BTC"){
      balance = await BtcContract().getTokenBalance();
      var _currentDecimal = await BtcContract().getDecimal();
      var _currentAllowance = await BtcContract().allowance();
      setState(() {
        currentTokenBalance = balance;
        currentDecimal = _currentDecimal;
        currentAllowance = _currentAllowance.toInt();
      });
      print("BTC-balance : $currentTokenBalance");
    }
    if(cryptochoose == "CAKE"){
      balance = await CakeContract().getTokenBalance();
      var _currentDecimal = await CakeContract().getDecimal();
      var _currentAllowance = await CakeContract().allowance();
      setState(() {
        currentTokenBalance = balance;
        currentDecimal = _currentDecimal;
        currentAllowance = _currentAllowance.toInt();
      });
      print("CAKE-balance : $currentTokenBalance");
    }
    if(cryptochoose == "ETH"){
      balance = await EthContract().getTokenBalance();
      var _currentDecimal = await EthContract().getDecimal();
      var _currentAllowance = await EthContract().allowance();
      setState(() {
        currentTokenBalance = balance;
        currentDecimal = _currentDecimal;
        currentAllowance = _currentAllowance.toInt();
      });
      print("ETH-balance : $currentTokenBalance");
    }
    if(cryptochoose == "FEG"){
      balance = await FegContract().getTokenBalance();
      var _currentDecimal = await FegContract().getDecimal();
      var _currentAllowance = await FegContract().allowance();
      setState(() {
        currentTokenBalance = balance;
        currentDecimal = _currentDecimal;
        currentAllowance = _currentAllowance.toInt();
      });
      print("balance : $balance");
      print("FEG-balance : $currentTokenBalance");
    }
    if(cryptochoose == "SAFEMOON"){
      balance = await SafemoonContract().getTokenBalance();
      var _currentDecimal = await SafemoonContract().getDecimal();
      var _currentAllowance = await SafemoonContract().allowance();
      setState(() {
        currentTokenBalance = balance;
        currentDecimal = _currentDecimal;
        currentAllowance = _currentAllowance.toInt();
      });
      print("SAFEM-balance : $currentTokenBalance");
    }
    if(cryptochoose == "USDC"){
      balance = await USDCContract().getTokenBalance();
      var _currentDecimal = await USDCContract().getDecimal();
      var _currentAllowance = await USDCContract().allowance();
      setState(() {
        currentTokenBalance = balance;
        currentDecimal = _currentDecimal;
        currentAllowance = _currentAllowance.toInt();
      });
      print("USDC-balance : $currentTokenBalance");
    }
    if(cryptochoose == "USDT"){
      balance = await USDTContract().getTokenBalance();
      var _currentDecimal = await USDTContract().getDecimal();
      var _currentAllowance = await USDTContract().allowance();
      setState(() {
        currentTokenBalance = balance;
        currentDecimal = _currentDecimal;
        currentAllowance = _currentAllowance.toInt();
      });
      print("USDT-balance : $currentTokenBalance");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    BigInt bnbBalance = Provider.of<WalletProvider>(context, listen: true).getUserBalance;

    return Scaffold(
      body: CenteredView(
        child: SingleChildScrollView(
          child: Column(
            children: [
              NavigationBar(),
              Text("✨ Join NFT Breed Presale ✨ ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProgressBar(),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(border: Border.all()),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text("Choose your payment method", style: TextStyle(color: Colors.black, fontSize: 17),),
                            AnimationLimiter(
                              child: GridView.count(
                                crossAxisCount: 4, // numbers of rows
                                shrinkWrap: true, // enable page to accept scroll gridview inside column
                                children: List.generate(widget.paymentData.length, (int index) {
                                  print("title : ${widget.paymentData[index]['name'].toString()}");
                                  var title = widget.paymentData[index]['name'];
                                  var logo = widget.paymentData[index]['logo'];
                                  var radioVal = widget.paymentData[index]['valueRadio'];
                                  return AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    duration: Duration(milliseconds: 400),
                                    columnCount: 5,
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FlipAnimation(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              PaymentCard(title: title,assetPath: logo),
                                              Radio(
                                                value: radioVal,
                                                groupValue: val,
                                                activeColor: Colors.deepOrange,
                                                onChanged: (x) {
                                                  setState(() {
                                                    val = x as int?;
                                                    cryptochoose = title.toString();
                                                  });
                                                  getCurrentCryptoInfo();
                                                  print('val : $val');
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("1 BNB = 10000000000 NFTBD\n",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 25 )),
                            Text("Your $cryptochoose balance : \n", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20 ),),
                            /*StreamBuilder<BigInt>(
                              stream: WalletProvider().getBalanceStream,
                              builder: (context, snapshot) {
                                print("snapshot : ${snapshot.data}");
                                BigInt res = BigInt.zero;
                                WalletProvider().getBalanceStream.listen((event) {
                                  print("eveeeet : $event");
                                  setState(() {
                                    res = event;
                                  });
                                });
                                return res == BigInt.zero ? const CircularProgressIndicator(color: Colors.orangeAccent,) :
                                Text("Res = $res");
                              },
                            ),*/
                            Consumer<WalletProvider>(
                              builder: (context, provider, child) {
                                return cryptochoose == "BNB" ?
                                Text("${getBalanceWithoutDecimal(bnbBalance,18)}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 35 )) :
                                Text("${getBalanceWithoutDecimal(currentTokenBalance,currentDecimal)}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 35 ));
                              },
                            ),
                            SizedBox(height: 6,),
                            Text("What's NFT Breed ? \n", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, )),
                            Text("NFTBreed is a new concept and game to breed and collect so-adorable creatures like Cat , Dog  and Horse  ! Each creature is one-of-a-kind and 100% owned by collector; it cannot be replicated, taken away, or destroyed.",
                              style: TextStyle(color: Colors.grey,),textAlign: TextAlign.end,)
                          ],
                        ),
                      )
                  )
                ],
              ),
              SizedBox(height: 30,),
              Text("Select or enter your investissement value", style: TextStyle(color: Colors.black, fontSize: 17),),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextBtn(
                          height: 35,
                          width: 100,
                          title: "0.1 BNB",
                          btnColor: currentValSelected == 1 ? Colors.deepOrange :Colors.grey[500],
                          textColor: Colors.white,
                          onTap: ()=> {
                            setState((){
                              currentValSelected = 1;
                              amountController.text="";
                            })
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextBtn(
                          height: 35,
                          width: 100,
                          title: "0.5 BNB",
                          btnColor: currentValSelected == 2 ? Colors.deepOrange : Colors.grey[500],
                          textColor: Colors.white,
                          onTap: ()=> {
                            setState((){
                              currentValSelected = 2;
                              amountController.text="";
                            })
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextBtn(
                          height: 35,
                          width: 100,
                          title: "1 BNB",
                          btnColor: currentValSelected == 3 ? Colors.deepOrange :Colors.grey[500],
                          textColor: Colors.white,
                          onTap: ()=> {
                            setState((){
                              currentValSelected = 3;
                              amountController.text="";
                            })
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextBtn(
                          height: 35,
                          width: 100,
                          title: "3 BNB",
                          btnColor: currentValSelected == 4 ? Colors.deepOrange : Colors.grey[500],
                          textColor: Colors.white,
                          onTap: ()=> {
                            setState((){
                              currentValSelected = 4;
                              amountController.text="";
                            })
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  InputCustom(
                    height: 100,
                    width: 350,
                    borderColor: Colors.deepOrange,
                    placeholder: "Enter your own value",
                    backgroundColor: Colors.white,
                    controller: amountController,
                    textColor: Colors.deepOrange,
                    keyboardType: TextInputType.text,
                    onChanged: (text){
                      print("text : $text");
                      if(text != null && text.trim() != ""){
                        setState(() {
                          currentValSelected = 0;
                        });
                      }else{
                        /// Assign max value if user delete inout value
                        currentValSelected = 4;
                      }
                    },
                  )
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if(!alreadyApprove()) TextBtn(
                    height: 35,
                    width: 100,
                    title: "Approve",
                    btnColor: Colors.orangeAccent,
                    textColor: Colors.white,
                    onTap: ()=> approveFunc(),
                  ),
                  TextBtn(
                    height: 35,
                    width: 100,
                    title: "Buy",
                    btnColor: alreadyApprove() ? Colors.deepOrange : Colors.grey,
                    textColor: Colors.white,
                    onTap: ()=> {
                      if(alreadyApprove()){
                        // TODO : run func buy
                        buy()
                      }else{
                        print("No authorized to buy... Approve first"),
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InkWell(
                      child: Text("© WainCorp - 2021"),
                      onTap: (){
                        BtcContract().allowance();
                        //Api().getCurrentTokenPrice("0x7130d2a12b9bcbfae4f2634d864a1ee1ce3ead9c");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
