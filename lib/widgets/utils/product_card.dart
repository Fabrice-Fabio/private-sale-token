import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final imagePath;
  final title;
  final desc;
  const ProductCard({Key? key, this.imagePath, this.title, this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: 300,
        child: Card(
          elevation: 20,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(height: 8,),
                          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),),
                          SizedBox(height: 8,),
                          Text(desc,
                            style: TextStyle(fontSize: 13, color: Colors.black),),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0,
            ),
          ],
        )
    );
  }
}
