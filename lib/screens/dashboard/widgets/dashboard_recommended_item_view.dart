import 'package:cached_network_image/cached_network_image.dart';
import 'package:cook_book/common/widgets/loading_container_view.dart';
import 'package:cook_book/network/model/product_entity.dart';
import 'package:cook_book/screens/dashboard/dashboard_cubit.dart';
import 'package:cook_book/screens/dashboard/dashboard_state.dart';
import 'package:cook_book/screens/detail/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class DashboardRecommendedItemView extends StatelessWidget {
  const DashboardRecommendedItemView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      buildWhen: (previous, current) => current is DashboardState_OnLoadFavorites,
      builder: (context, state) {
        if (state is DashboardState_OnLoadFavorites) {
          return _list(state.products);
        }
        return Container(
          height: 180,
          child: LoadingContainerView(),
        );
      },
    );
  }

  Widget _list(List<ProductEntity> items) {
    List<Widget> widgets = [];
    items.forEach((element) {
      widgets.add(_listTile(item: element));
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widgets,
      ),
    );
  }

  Widget _listTile({ProductEntity item}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Container(
            height: 190,
            constraints: BoxConstraints(minWidth: 180, maxWidth: 200),
            padding: EdgeInsets.all(8),
            child: Material(
              type: MaterialType.card,
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      child: ClipOval(
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Hero(
                            tag: "product_image_${item.id}",
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: item.image,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Text Block
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: Container(
                        child: Column(
                          children: [
                            Hero(
                              tag: "product_name_${item.id}",
                              child: Text(
                                item.title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // Container(
                            //   padding: EdgeInsets.all(8),
                            //   child: Hero(
                            //     tag: "product_types_${item.id}",
                            //     child: badgeItems(item),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
      onTap: () {
        Get.to(DetailScreen(entity: item));
      },
    );
  }

  Widget badgeItems(ProductEntity item) {
    List<Widget> rowItems = List();
    var tags = item.tags.split(",");
    tags.forEach((element) {
      rowItems.add(
        Container(
          decoration: BoxDecoration(
            color: Colors.green[400],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              element,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ),
      );
    });
    return Row(
      children: rowItems,
    );
  }
}
