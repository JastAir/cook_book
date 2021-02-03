import 'dart:convert';
import 'dart:io';
import 'package:cook_book/common/log_manager.dart';
import 'package:cook_book/network/model/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cook_book/network/endpoints.dart';
import 'package:cook_book/network/model/category_entity.dart';

class NetworkRepository {
  Future<List<CategoryEntity>> getAllCategories() async {
    final responce = await http.get(NetworkEndpoints.allCategories());

    if (responce.statusCode == 200) {
      final json = jsonDecode(responce.body) as List;
      return json.map((e) => CategoryEntity.fromJson(e)).toList();
    } else {
      throw LogManager.exception("${responce.statusCode}: ${responce.body}", type: ExceptionType.bad_responce);
    }
  }

  Future<List<ProductEntity>> getAllFavorites() async {
    final responce = await http.get(NetworkEndpoints.allFavorites());

    if (responce.statusCode == 200) {
      final json = jsonDecode(responce.body) as List;
      return json.map((e) => ProductEntity.fromJson(e)).toList();
    } else {
      throw LogManager.exception("${responce.statusCode}: ${responce.body}", type: ExceptionType.bad_responce);
    }
  }

  Future<List<ProductEntity>> getRecipesBySubcategory({int limit = 20, int offset = 0, @required int subcategory}) async {
    final responce = await http.get(NetworkEndpoints.recipesBySubCategory(limit: limit, offset: offset, subcategory: subcategory));

    if (responce.statusCode == 200) {
      final json = jsonDecode(responce.body) as List;
      return json.map((e) => ProductEntity.fromJson(e)).toList();
    } else {
      throw LogManager.exception("${responce.statusCode}: ${responce.body}", type: ExceptionType.bad_responce);
    }
  }

  Future<List<ProductEntity>> getSearchResult(String row) async {
    final responce = await http.get(NetworkEndpoints.fullSearch(row: row));

    if (responce.statusCode == 200) {
      final json = jsonDecode(responce.body) as List;
      return json.map((e) => ProductEntity.fromJson(e)).toList();
    } else {
      throw LogManager.exception("${responce.statusCode}: ${responce.body}", type: ExceptionType.bad_responce);
    }
  }
}
