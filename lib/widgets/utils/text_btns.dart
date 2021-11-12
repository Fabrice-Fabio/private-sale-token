import 'package:flutter/material.dart';

class TextBtn extends StatelessWidget {
  final String? title;
  final height;
  final width;
  final onTap;
  final btnColor;
  final textColor;
  const TextBtn({Key? key, this.title, this.btnColor, this.onTap, this.height, this.width, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(5),
        child: Center(child: Text(title!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor),)),
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: onTap,
    );
  }
}
