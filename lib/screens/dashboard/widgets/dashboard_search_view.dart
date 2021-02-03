import 'package:cached_network_image/cached_network_image.dart';
import 'package:cook_book/network/model/product_entity.dart';
import 'package:flutter/material.dart';

class DashboardSearchView extends StatelessWidget {
  const DashboardSearchView({Key key, this.products, this.onItemClick, this.onClose}) : super(key: key);

  final List<ProductEntity> products;
  final Function(ProductEntity) onItemClick;
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 32,
            padding: EdgeInsets.only(top: 4, right: 8),
            child: InkWell(
              child: Icon(Icons.close),
              onTap: () {
                onClose();
              },
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _searchRowResult(products[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _searchRowResult(ProductEntity entity) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(6),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                height: 52,
                width: 52,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: entity.image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Text(
                entity.title,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      onTap: () => onItemClick(entity),
    );
  }
}
