import 'package:cached_network_image/cached_network_image.dart';
import 'package:cook_book/common/widgets/loading_container_view.dart';
import 'package:cook_book/network/model/category_entity.dart';
import 'package:cook_book/screens/catalog/catalog_screen.dart';
import 'package:cook_book/screens/dashboard/dashboard_cubit.dart';
import 'package:cook_book/screens/dashboard/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class DashboardMenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      buildWhen: (previous, current) => current is DashboardState_OnLoadMenu,
      builder: (context, state) {
        if (state is DashboardState_OnLoadMenu) {
          return _list(state.items);
        }
        return Container(
          height: 180,
          child: LoadingContainerView(),
        );
      },
    );
  }

  Widget _list(List<CategoryEntity> items) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Material(
        type: MaterialType.card,
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Меню",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      leading: ClipOval(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: items[index].pictureUrl,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      title: Container(
                        child: Text(
                          items[index].title,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        "Рецептов: ${items[index].recieptsCount}",
                        textAlign: TextAlign.right,
                      ),
                      children: _subcategoryList(context: context, items: items[index].subcategories),
                      tilePadding: EdgeInsets.all(0),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _subcategoryList({BuildContext context, List<SubCategoryEntity> items}) {
    List<Widget> rows = [];

    items.forEach((e) {
      rows.add(
        InkWell(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(14),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Text(
                        "${e.title}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "${e.recipesCount}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Get.to(CatalogScreen(
              title: e.title,
              subcategoryId: e.id,
            ));
          },
        ),
      );
    });
    return [
      Column(children: rows),
    ];
  }
}
