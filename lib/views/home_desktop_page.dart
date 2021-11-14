import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:privatesale/smart_contracts/smart_contracts_index.dart';
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

  getCurrentCryptoInfo() async {
    BigInt balance = BigInt.zero;
    currentTokenBalance = balance; /// Initialize to BigInt.zero at each call
    if(cryptochoose == "FEG"){
      balance = await FegContract().getTokenBalance();
      setState(() {
        currentTokenBalance = balance;
      });
      print("balance : $balance");
      print("FEG-balance : $currentTokenBalance");
    }
    if(cryptochoose == "SAFEMOON"){
      balance = await SafemoonContract().getTokenBalance();
      setState(() {
        currentTokenBalance = balance;
      });
      print("SAFEM-balance : $currentTokenBalance");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
                            Consumer<WalletProvider>(
                              builder: (context, provider, child) {
                                return cryptochoose == "BNB" ?
                                Text("${provider.getUserBalance}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 35 )) :
                                Text("$currentTokenBalance",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 35 ));
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
                  TextBtn(
                    height: 35,
                    width: 100,
                    title: "Approve",
                    btnColor: Colors.orangeAccent,
                    textColor: Colors.white,
                    onTap: ()=> {
                    },
                  ),
                  TextBtn(
                    height: 35,
                    width: 100,
                    title: "Valider",
                    btnColor: Colors.deepOrange,
                    textColor: Colors.white,
                    onTap: ()=> {
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
                        SartContract().getTokenInfo();
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
