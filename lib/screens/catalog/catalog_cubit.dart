import 'dart:io';

import 'package:cook_book/network/model/product_entity.dart';
import 'package:cook_book/network/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final NetworkRepository repository;
  final int subcategoryId;

  int _page = 0;
  List<ProductEntity> catalogItems = [];

  CatalogCubit(this.repository, this.subcategoryId)
      : super(Catalog_InProgress());

  Future<void> fetchPage() async {
    try {
      emit(Catalog_WillLoad(items: catalogItems));

      var cItems = await repository.getRecipesBySubcategory(
        subcategory: subcategoryId,
        limit: 20,
        offset: _page > 0 ? _page * 20 : _page,
      );

      catalogItems.addAll(cItems);
      _page++;

      emit(Catalog_DidLoaded(items: catalogItems));
    } on SocketException {
      emit(Catalog_OnError(error: "No internet connection!"));
    } on HttpException {
      emit(Catalog_OnError(error: "No Service Found"));
    } catch (e) {
      emit(Catalog_OnError(error: "Unknown error: ${e.toString()}"));
    }
  }
}

abstract class CatalogState extends Equatable {
  @override
  List<Object> get props => [];
}

class Catalog_InProgress extends CatalogState {}

class Catalog_OnError extends CatalogState {
  final String error;
  Catalog_OnError({this.error});
}

class Catalog_DidLoaded extends CatalogState {
  final List<ProductEntity> items;
  Catalog_DidLoaded({this.items});
}

class Catalog_WillLoad extends CatalogState {
  final List<ProductEntity> items;
  Catalog_WillLoad({this.items});
}
