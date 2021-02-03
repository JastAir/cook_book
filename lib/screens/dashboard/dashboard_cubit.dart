import 'dart:io';

import 'package:cook_book/network/model/category_entity.dart';
import 'package:cook_book/network/repository.dart';
import 'package:cook_book/screens/dashboard/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final NetworkRepository repository;
  DashboardCubit({@required this.repository}) : super(DashboardState_InProgress());

  // DATA

  Future<void> fetchAll() async {
    emitDefaultState();
    fetchFavorites();
    fetchMenu();
  }

  Future<void> fetchFavorites() async {
    try {
      var cItems = await repository.getAllFavorites();
      emit(DashboardState_OnLoadFavorites(products: cItems));
    } on SocketException {
      emit(DashboardState_OnError(error: "No internet connection!"));
    } on HttpException {
      emit(DashboardState_OnError(error: "No Service Found"));
    } catch (e) {
      emit(DashboardState_OnError(error: "Unknown error: ${e.toString()}"));
    }
  }

  Future<void> fetchMenu() async {
    try {
      var cItems = await repository.getAllCategories();
      emit(DashboardState_OnLoadMenu(items: cItems));
    } on SocketException {
      emit(DashboardState_OnError(error: "No internet connection!"));
    } on HttpException {
      emit(DashboardState_OnError(error: "No Service Found"));
    } catch (e) {
      emit(DashboardState_OnError(error: "Unknown error: ${e.toString()}"));
    }
  }

  Future<void> fetchSearchResults(String row) async {
    if (row.length < 3) {
      return null;
    }

    try {
      emit(DashboardState_SearchMode_InProgress());
      var items = await repository.getSearchResult(row);
      emit(DashboardState_SearchMode_OnResults(items));
    } on SocketException {
      emit(DashboardState_OnError(error: "No internet connection!"));
    } on HttpException {
      emit(DashboardState_OnError(error: "No Service Found"));
    } catch (e) {
      emit(DashboardState_OnError(error: "Unknown error: ${e.toString()}"));
    }
  }

  Future<void> emitDefaultState() async {
    emit(DashboardState_SearchMode_Disable());
  }
}
