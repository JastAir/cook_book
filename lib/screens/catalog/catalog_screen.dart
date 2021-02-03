import 'package:cached_network_image/cached_network_image.dart';
import 'package:cook_book/common/widgets/loading_container_view.dart';
import 'package:cook_book/network/model/product_entity.dart';
import 'package:cook_book/network/repository.dart';
import 'package:cook_book/screens/catalog/catalog_cubit.dart';
import 'package:cook_book/screens/detail/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';

class CatalogScreen extends StatelessWidget {
  final String title;
  final int subcategoryId;

  CatalogScreen({Key key, this.title, this.subcategoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CatalogCubit(NetworkRepository(), subcategoryId)..fetchPage(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title ?? "Каталог рецептов"),
        ),
        body: BlocBuilder<CatalogCubit, CatalogState>(
          builder: (context, state) {
            if (state is Catalog_InProgress) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(16),
                child: LoadingContainerView(),
              );
            }

            if (state is Catalog_OnError) {
              return Text("Unknown error!");
            }

            if (state is Catalog_WillLoad) {
              return ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return LazyLoadingList(
                    initialSizeOfItems: 20,
                    index: index,
                    child: _listTile(state.items[index]),
                    loadMore: () {
                      context.read<CatalogCubit>().fetchPage();
                    },
                    hasMore: true,
                  );
                },
              );
            }

            if (state is Catalog_DidLoaded) {
              return ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return LazyLoadingList(
                    initialSizeOfItems: 20,
                    index: index,
                    child: _listTile(state.items[index]),
                    loadMore: () {
                      context.read<CatalogCubit>().fetchPage();
                    },
                    hasMore: true,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _listTile(ProductEntity product) {
    return InkWell(
      onTap: () {
        Get.to(DetailScreen(
          entity: product,
        ));
      },
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            padding: EdgeInsets.all(8),
            child: ClipOval(
              child: Hero(
                tag: "product_image_${product.id}",
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: product.image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: "product_name_${product.id}",
                    child: Text(
                      product.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Hero(
                    tag: "product_kkal_${product.id}",
                    child: Text(
                      "${product.total_calories} калл.",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Text(
                    product.tags,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
