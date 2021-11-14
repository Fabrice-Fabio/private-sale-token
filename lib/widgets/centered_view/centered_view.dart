import 'package:flutter/material.dart';

class CenteredView extends StatelessWidget {
  final Widget? child;
  const CenteredView({Key? key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.topCenter,

      /// SET background image
      /*decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/backgroundImg.png"),
          fit: BoxFit.cover,
        ),
      ),*/

      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1200,),
        child: child,
      ),
    );
  }
}
