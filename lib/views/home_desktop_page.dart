import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  int? val = 1; // Radio value
  String cryptochoose = "BNB"; // Token name after select radio
  int currentValSelected = 0; // Price selected to invest between (1->0.1 || 2->0.5 || 3->1 || 4-> 3) bnb
  TextEditingController amountController = TextEditingController(); // Price user edit by own to invest
  double priceBnbByNFTB = 20000000; // 1BNB -> 20000000 NFTB

  BigInt currentTokenBalance = BigInt.zero; // selected token balance in this wallet
  int currentDecimal = 18; // selected token decimal (DEFAULT 18 = BNB DEC)
  String currentSCAddress = ""; // selected token sc address
  int currentAllowance = 0; // check if user are already approve current token payment and get value


  getTokenPriceInBnb(currentAddress) async {
    double res = await Api().getCurrentTokenPrice(currentAddress);
    debugPrint("getTokenPriceInBnb : $res");
    return res;
  }


  getBalanceWithoutDecimal(BigInt tokenBalance,int decimal){
    debugPrint("---tokenBalance : $tokenBalance && decimal : $decimal ---");
    /*double res = tokenBalance.toDouble();
    print("double token : $res");*/
    int tokenBalanceToInt = tokenBalance.toInt();
    debugPrint("int token : $tokenBalanceToInt");

    var res = tokenBalanceToInt/pow(10, decimal);

    debugPrint("res final : $res");
    return res;
  }

  alreadyApprove(){
    debugPrint("alreadyApprove-currentAllowance : $currentAllowance");
    debugPrint("alreadyApprove-balance : ${getBalanceWithoutDecimal(currentTokenBalance,currentDecimal)}");
    //
    if(cryptochoose != "BNB"){
      if(currentAllowance<=0 || currentAllowance < currentTokenBalance.toInt()){
        return false;
      }else{
        return true;
      }
    }
    return true;
  }

  showAlertDialog(BuildContext pcontext,int value) {
    /// Value = 0-> red
    /// Value = 1 -> green
    /// Value = 2 -> orange
    String text = "Your request is in progress";
    Color color= Colors.deepOrange;
    IconData aIcon = Icons.cancel_outlined;
    switch(value) {
      case 0:
        text="Something went wrong, request failed";
        color= Colors.red;
        aIcon = Icons.cancel_outlined;
        break;
      case 1:
        text="Successful transaction";
        color= Colors.green;
        aIcon = Icons.done;
        break;
      case 2:
        text = "Your request is in progress";
        color= Colors.deepOrange;
        break;
    }
    showDialog(
      barrierDismissible: false,
      context: pcontext,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text("Request Status",style: TextStyle(color: color,fontWeight: FontWeight.w500),),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20))),
          content: Container(
            //width: 200,
            //height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(height: 50,width: 2,color: color,),
                      SizedBox(width: 6,),
                      Text(text,style: TextStyle(color: color,fontWeight: FontWeight.bold)),
                      SizedBox(width: 6,),
                      if(value != 2) Icon(aIcon,color: color,size: 20,),
                      if(value == 2) CircularProgressIndicator(color: color,)
                    ],
                  ),
                  SizedBox(height: 6,),
                  if(value != 2) TextBtn(
                    height: 35,
                    width: 100,
                    title: "Done",
                    btnColor: color,
                    textColor: Colors.white,
                    onTap: ()=> Navigator.pop(context),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  approveFunc(context) async {
    debugPrint("approve check allowance : $currentAllowance");
    Fluttertoast.showToast(
        msg: "Your request is in progress",
        timeInSecForIosWeb: 50,
    );
    if(cryptochoose == "BTC"){
      BtcContract().approve(currentTokenBalance).then((value) =>
      {
        debugPrint("value : $value"),
        value ? showAlertDialog(context, 1) : showAlertDialog(context, 0),
        getCurrentCryptoInfo(),
      });
    }
    if(cryptochoose == "CAKE"){
      CakeContract().approve(currentTokenBalance).then((value) =>
      {
        debugPrint("value : $value"),
        value ? showAlertDialog(context, 1) : showAlertDialog(context, 0),
        getCurrentCryptoInfo(),
      });
    }
    if(cryptochoose == "ETH"){
      EthContract().approve(currentTokenBalance).then((value) =>
      {
        debugPrint("value : $value"),
        value ? showAlertDialog(context, 1) : showAlertDialog(context, 0),
        getCurrentCryptoInfo(),
      });
    }
    if(cryptochoose == "FEG"){
      FegContract().approve(currentTokenBalance).then((value) =>
      {
        debugPrint("value : $value"),
        value ? showAlertDialog(context, 1) : showAlertDialog(context, 0),
        getCurrentCryptoInfo(),
      });
    }
    if(cryptochoose == "SAFEMOON"){
      SafemoonContract().approve(currentTokenBalance).then((value) =>
      {
        debugPrint("value : $value"),
        value ? showAlertDialog(context, 1) : showAlertDialog(context, 0),
        getCurrentCryptoInfo(),
      });
    }
    if(cryptochoose == "USDC"){
      USDCContract().approve(currentTokenBalance).then((value) =>
      {
        debugPrint("value : $value"),
        value ? showAlertDialog(context, 1) : showAlertDialog(context, 0),
        getCurrentCryptoInfo(),
      });
    }
    if(cryptochoose == "USDT"){
      USDTContract().approve(currentTokenBalance).then((value) =>
      {
        debugPrint("value : $value"),
        value ? showAlertDialog(context, 1) : showAlertDialog(context, 0),
        getCurrentCryptoInfo(),
      });
    }
  }

  userBnbInvest(bnbValue){
    if(currentValSelected != 0){ // default choose
      if(currentValSelected == 1) {
        setState(() {
          bnbValue = 0.1;
        });
      }else if(currentValSelected == 2) {
        setState(() {
          bnbValue = 0.5;
        });
      }else if(currentValSelected == 3) {
        setState(() {
          bnbValue = 1;
        });
      }else if(currentValSelected == 4) {
        setState(() {
          bnbValue = 3;
        });
      }
      return bnbValue;
    }
    else{ // user write is own bnb value in input
      if(amountController.text.trim() != "" && amountController.text.isNotEmpty){
        bnbValue = double.parse(amountController.text);
        if(bnbValue > 0.1){
          return bnbValue;
        }else{
          return 0.1;
        }
      }else{
        return 0.1; // return default value 0.1 in fail case
      }
    }
  }

  buy() async {
    if(alreadyApprove()) /// check if current token is already approve by user
    {
      double bnbValue = userBnbInvest(0.1); // if user don't choose anything default value invest is 0.1
      debugPrint("bnbValue :$bnbValue");

      BigInt _bnbValueWithDecimal = BigInt.from(bnbValue*pow(10, currentDecimal));


      Fluttertoast.showToast(
        msg: "Your request is in progress",
        timeInSecForIosWeb: 50,
      );

      /// check if current token is bnb or not
      if(cryptochoose == "BNB") {
        // 1bnb = priceBnbByNftb -> valeurNFTB invest
        //_bnbValueWithDecimal
        debugPrint("_bnbAmount : $_bnbValueWithDecimal");

        PresaleContract().joinWithBNB(_bnbValueWithDecimal).then((value) =>
        {
          debugPrint("Buy - WithBnb : $value"),
          value ? showAlertDialog(context, 1) : showAlertDialog(context, 0),
          getCurrentCryptoInfo(), // update token value after transaction completed
        });

      }
      else{
        // buy with others tokens
        double _tokenValueInOneBnb = await getTokenPriceInBnb(currentSCAddress);
        double _tokenValByBnb = bnbValue*_tokenValueInOneBnb;

        debugPrint("_tokenValueInOneBnb : $_tokenValueInOneBnb");
        debugPrint("_tokenValByBnb : $_tokenValByBnb");

        // params need to be send to SC
        var _bep20Address = currentSCAddress;
        var _bep20Amount = currentTokenBalance;
        var _tokenAmount = BigInt.from((_tokenValByBnb*priceBnbByNFTB)/_tokenValueInOneBnb);//priceBnbByNFTB = 20000000
        var _bnbAmount = _bnbValueWithDecimal;


        debugPrint("----- Others Token Send I -----");

        debugPrint("_bep20Address : $_bep20Address");
        debugPrint("_bep20Amount : $_bep20Amount");
        debugPrint("_tokenAmount : $_tokenAmount");
        debugPrint("_bnbAmount : $_bnbAmount");

        debugPrint("----- Others Token Send O -----");

        PresaleContract().joinWithMultiCoin(_bep20Address,_bep20Amount,_tokenAmount,_bnbAmount).then((value) =>
        {
          debugPrint("Buy - WithBnb : $value"),
          value ? showAlertDialog(context, 1) : showAlertDialog(context, 0),
          getCurrentCryptoInfo(), // update token value after transaction completed
        });

      }
    }else{
      Fluttertoast.showToast(
        msg: "You need to approve before you can buy",
        timeInSecForIosWeb: 4,
      );
    }
  }

  getCurrentCryptoInfo() async {
    debugPrint("--GetCurrentCryptoInfo--");
    /// currentTokenBalance is BigInt (token balance with exp value)
    BigInt balance = BigInt.zero;
    currentTokenBalance = balance; /// Initialize to BigInt.zero at each call
    if(cryptochoose == "BTC"){
      balance = await BtcContract().getTokenBalance();
      var _currentDecimal = await BtcContract().getDecimal();
      var _currentAllowance = await BtcContract().allowance();
      var _currentSCAddress = await BtcContract().getMainAddress();
      setState(() {
        currentTokenBalance = balance;
        currentDecimal = _currentDecimal;
        currentAllowance = _currentAllowance.toInt();
        currentSCAddress = _currentSCAddress;
      });
      debugPrint("BTC-balance : $currentTokenBalance");
    }
    if(cryptochoose == "CAKE"){
      balance = await CakeContract().getTokenBalance();
      var _currentDecimal = await CakeContract().getDecimal();
      var _currentAllowance = await CakeContract().allowance();
      var _currentSCAddress = await CakeContract().getMainAddress();
      setState(() {
        currentTokenBalance = balance;
        currentDecimal = _currentDecimal;
        currentAllowance = _currentAllowance.toInt();
        currentSCAddress = _currentSCAddress;
      });
      debugPrint("CAKE-balance : $currentTokenBalance");
    }
    if(cryptochoose == "ETH"){
      balance = await EthContract().getTokenBalance();
      var _currentDecimal = await EthContract().getDecimal();
      var _currentAllowance = await EthContract().allowance();
      var _currentSCAddress = await EthContract().getMainAddress();
      setState(() {
        currentTokenBalance = balance;
        currentDecimal = _currentDecimal;
        currentAllowance = _currentAllowance.toInt();
        currentSCAddress = _currentSCAddress;
      });
      debugPrint("ETH-balance : $currentTokenBalance");
    }
    if(cryptochoose == "FEG"){
      balance = await FegContract().getTokenBalance();
      var _currentDecimal = await FegContract().getDecimal();
      var _currentAllowance = await FegContract().allowance();
      var _currentSCAddress = await FegContract().getMainAddress();
      setState(() {
        currentTokenBalance = balance;
        currentDecimal = _currentDecimal;
        currentAllowance = _currentAllowance.toInt();
        currentSCAddress = _currentSCAddress;
      });
      debugPrint("balance : $balance");
      debugPrint("FEG-balance : $currentTokenBalance");
    }
    if(cryptochoose == "SAFEMOON"){
      balance = await SafemoonContract().getTokenBalance();
      var _currentDecimal = await SafemoonContract().getDecimal();
      var _currentAllowance = await SafemoonContract().allowance();
      var _currentSCAddress = await SafemoonContract().getMainAddress();
      setState(() {
        currentTokenBalance = balance;
        currentDecimal = _currentDecimal;
        currentAllowance = _currentAllowance.toInt();
        currentSCAddress = _currentSCAddress;
      });
      print("SAFEM-balance : $currentTokenBalance");
    }
    if(cryptochoose == "USDC"){
      balance = await USDCContract().getTokenBalance();
      var _currentDecimal = await USDCContract().getDecimal();
      var _currentAllowance = await USDCContract().allowance();
      var _currentSCAddress = await USDCContract().getMainAddress();
      setState(() {
        currentTokenBalance = balance;
        currentDecimal = _currentDecimal;
        currentAllowance = _currentAllowance.toInt();
        currentSCAddress = _currentSCAddress;
      });
      print("USDC-balance : $currentTokenBalance");
    }
    if(cryptochoose == "USDT"){
      balance = await USDTContract().getTokenBalance();
      var _currentDecimal = await USDTContract().getDecimal();
      var _currentAllowance = await USDTContract().allowance();
      var _currentSCAddress = await USDTContract().getMainAddress();
      setState(() {
        currentTokenBalance = balance;
        currentDecimal = _currentDecimal;
        currentAllowance = _currentAllowance.toInt();
        currentSCAddress = _currentSCAddress;
      });
      print("USDT-balance : $currentTokenBalance");
    }
    /// check if cryptochoose == "BNB"
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
                                  debugPrint("title : ${widget.paymentData[index]['name'].toString()}");
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
                    placeholder: "Enter value in bnb (1)",
                    backgroundColor: Colors.white,
                    controller: amountController,
                    textColor: Colors.deepOrange,
                    keyboardType: TextInputType.number,
                    onChanged: (text){
                      print("text : $text");
                      if(text != null && text.trim() != ""){
                        setState(() {
                          currentValSelected = 0;
                        });
                      }else{
                        /// Assign max min if user delete inout value
                        currentValSelected = 1;
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
                    onTap: ()=> approveFunc(context),
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
                        //BtcContract().allowance();
                        Api().getCurrentTokenPrice("0x7130d2a12b9bcbfae4f2634d864a1ee1ce3ead9c");
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
