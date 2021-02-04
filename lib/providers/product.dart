import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavouriteStatus(String authToken, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://shopappflutter-73532-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(url, body: json.encode(isFavourite));
      print(json.decode(response.body));
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      print(error.toString());
      isFavourite = oldStatus;
      notifyListeners();
      throw HttpException('Could not update product');
    }
  }
}
