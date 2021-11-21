import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Api {


  var dio = Dio();
  String urlTokenPrice = "https://tokenprice.herokuapp.com";

  Future<double> getCurrentTokenPrice(String address) async {
    // address test : 0x7130d2a12b9bcbfae4f2634d864a1ee1ce3ead9c
    try {
      var response = await dio.get('$urlTokenPrice/address/price?address=$address');
      var price = response.data['data']['lastPrice'];
      debugPrint("tokenCurrentPrice : $price");
      return double.parse(price.toString()); // price is int
    } catch (e) {
      debugPrint("err api tokenprice : $e");
    }
    return 0.0;
  }

}