import 'package:flutter/material.dart';
import 'package:privatesale/widgets/utils/export_utils.dart';

class PaymentCard extends StatefulWidget {
  final title;
  final assetPath;
  const PaymentCard({Key? key, @required this.title, @required this.assetPath}) : super(key: key);

  @override
  _PaymentCardState createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(widget.assetPath, width: 50, height: 50,),
              ),
              TextBtn(
                height: 35,
                width: 60,
                title: widget.title,
                btnColor: Colors.deepOrange,
                textColor: Colors.white,
                onTap: ()=>print("Join Telegram"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
