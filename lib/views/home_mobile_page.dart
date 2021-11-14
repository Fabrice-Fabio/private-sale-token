import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:privatesale/smart_contracts/smart_contracts_index.dart';
import 'package:privatesale/wallet/walletprovider.dart';
import 'package:privatesale/widgets/centered_view/centered_view.dart';
import 'package:privatesale/widgets/navigation_bar/navigation_bar.dart';
import 'package:privatesale/widgets/utils/export_utils.dart';
import 'package:provider/provider.dart';

class HomeMobilePage extends StatefulWidget {
  final paymentData;
  const HomeMobilePage({Key? key, required this.paymentData}) : super(key: key);

  @override
  _HomeMobilePageState createState() => _HomeMobilePageState();
}

class _HomeMobilePageState extends State<HomeMobilePage> {
  int? val = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.deepOrange,),
      body: CenteredView(
        child: Column(
          children: [
            Text("✨ Join NFT Breed Presale ✨ ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProgressBar(),
              ],
            ),
            SizedBox(height: 10,),
            Text("Balance : \n", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20 ),),
            Consumer<WalletProvider>(
              builder: (context, provider, child) {
                return Text("${provider.getUserBalance} ETH",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 35 ));
              },
            ),
            SizedBox(height: 6,),
            Text("What's NFT Breed ? \n", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, )),
            Text("NFTBreed is a new concept and game to breed and collect so-adorable creatures like Cat , Dog  and Horse  ! Each creature is one-of-a-kind and 100% owned by collector; it cannot be replicated, taken away, or destroyed.",
              style: TextStyle(color: Colors.grey,),textAlign: TextAlign.justify,),
            SizedBox(height: 10,),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all()),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text("Choose your payment method", style: TextStyle(color: Colors.black, fontSize: 17),),
                      AnimationLimiter(
                        child: GridView.count(
                          crossAxisCount: 3, // numbers of rows
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
                                            });
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

            InkWell(
              child: Text("© PRIVATESALE - 2021"),
              onTap: (){
                SartContract().getTokenInfo();
              },
            ),
          ],
        ),
      ),
      // TODO : uncomment to active drawer
      drawer: NavigationBar(),
    );
  }
}
