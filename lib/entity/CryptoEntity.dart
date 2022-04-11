import 'dart:convert';

CryptoEntity cryptoEntityFromJson(String str) => CryptoEntity.fromJson(json.decode(str));


class CryptoEntity{

  CryptoEntity({
    required this.price,
    required this.name,
    required this.dateResult,
  });

  double price;
  String name;
  DateTime dateResult;



  factory CryptoEntity.fromJson(Map<String, dynamic> json) => CryptoEntity(
    price: json["price"],
    name: json["name"],
    dateResult: json["dateResult"],
  );

    

}