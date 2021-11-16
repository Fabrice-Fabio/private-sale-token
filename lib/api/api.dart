import 'package:dio/dio.dart';

class Api {


  var dio = Dio();
  String urlTokenPrice = "https://tokenprice.herokuapp.com";

  Future<String> getCurrentTokenPrice(String address) async {
    // address test : 0x7130d2a12b9bcbfae4f2634d864a1ee1ce3ead9c
    try {
      var response = await dio.get('$urlTokenPrice/address/price?address=$address');
      var price = response.data['data']['lastPrice'];
      print("tokenCurrentPrice : $price");
      return price;
    } catch (e) {
      print("err api tokenprice : $e");
    }
    return "";
  }

}