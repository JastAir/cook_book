import 'package:cook_book/network/model/category_entity.dart';
import 'package:cook_book/network/model/product_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class DashboardState extends Equatable {
  @override
  List<Object> get props => [];
}

class DashboardState_OnLoadFavorites extends DashboardState {
  final List<ProductEntity> products;
  DashboardState_OnLoadFavorites({@required this.products});
}

class DashboardState_OnLoadMenu extends DashboardState {
  final List<CategoryEntity> items;
  DashboardState_OnLoadMenu({@required this.items});
}

class DashboardState_OnLoadSearchResult extends DashboardState {}

// MARK: General states
class DashboardState_InProgress extends DashboardState {}

class DashboardState_OnError extends DashboardState {
  final String error;
  DashboardState_OnError({@required this.error});
}

class DashboardState_SearchMode_InProgress extends DashboardState {}

class DashboardState_SearchMode_Disable extends DashboardState {}

class DashboardState_SearchMode_OnResults extends DashboardState {
  final List<ProductEntity> products;
  DashboardState_SearchMode_OnResults(this.products);
}
