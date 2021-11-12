import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:privatesale/smart_contracts/smart_contracts_index.dart';
import 'package:privatesale/wallet/walletprovider.dart';
import 'package:privatesale/widgets/centered_view/centered_view.dart';
import 'package:privatesale/widgets/navigation_bar/navigation_bar.dart';
import 'package:privatesale/widgets/utils/export_utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> WalletProvider()..init(),
      builder: (contextProv, snapshot) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 992) {
              return desktopView(context);
            } else {
              return mobileView(context);
            }},);
      },
    );
  }
}

Widget progressBar(context){
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: LinearPercentIndicator(
      width: MediaQuery.of(context).size.width/2,
      animation: true,
      lineHeight: 20.0,
      animationDuration: 2000,
      percent: 0.9,
      center: const Text("90.0%", style: TextStyle(color: Colors.white),),
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: Colors.deepOrange,
      leading: Text('0 ', style: TextStyle(color: Colors.deepOrange)),
      trailing: Text(' 120', style: TextStyle(color: Colors.deepOrange)),
    ),
  );
}

Widget desktopView(context) {
  return Scaffold(
    body: CenteredView(
      child: Column(
        children: [
          NavigationBar(),
          Text("✨ Join NFT Breed Presale ✨ ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              progressBar(context),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Column(
                    children: [
                      Text("Choose your payment method", style: TextStyle(color: Colors.black, fontSize: 17),),
                      AnimationLimiter(
                        child: GridView.count(
                          crossAxisCount: 4, // numbers of rows
                          shrinkWrap: true, // enable page to accept scroll gridview inside column
                          children: List.generate(5, (int index) {
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              columnCount: 5,
                              child: const SlideAnimation(
                                verticalOffset: 50.0,
                                child: FlipAnimation(
                                  child: PaymentCard(title: "BNB",assetPath: "assets/img.png",),
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
              Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Balance : \n", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20 ),),
                        Consumer<WalletProvider>(
                          builder: (context, provider, child) {
                            return Text("${provider.getUserBalance} ETH",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 35 ));
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

          Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      InkWell(
                        child: Text("© HENTCOIN - 2021"),
                        onTap: (){
                          SartContract().getTokenInfo();
                        },
                      ),
                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    ),
  );
}

Widget mobileView(context) {
  return Scaffold(
    appBar: AppBar(backgroundColor: Colors.deepOrange,),
    body: CenteredView(
      child: Column(
        children: [
          Text("✨ Join NFT Breed Presale ✨ ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              progressBar(context),
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
                        children: List.generate(6, (int index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 400),
                            columnCount: 5,
                            child: const SlideAnimation(
                              verticalOffset: 50.0,
                              child: FlipAnimation(
                                child: PaymentCard(title: "BNB",assetPath: "assets/img.png",),
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