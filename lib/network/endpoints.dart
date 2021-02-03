import 'package:flutter/material.dart';

class NetworkEndpoints {
  static String apiUrl = "http://smachno.net/api/v1";

  static String allCategories({int limit = 20, int offset = 0}) => "$apiUrl/categories/all?limit=$limit&offset=$offset";

  static String allFavorites({int limit = 10, int offset = 0}) => "$apiUrl/favorites?limit=$limit&offset=$offset";

  static String recipesBySubCategory({int limit = 20, int offset = 0, @required int subcategory}) =>
      "$apiUrl/recipes/list?limit=$limit&offset=$offset&subcategory_id=$subcategory";

  static String fullSearch({String row}) => "$apiUrl/recipe/full-search?title=$row";
}
