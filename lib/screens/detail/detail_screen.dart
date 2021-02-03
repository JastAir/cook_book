import 'package:cached_network_image/cached_network_image.dart';
import 'package:cook_book/common/screens/photo_view_screen.dart';
import 'package:cook_book/network/model/product_entity.dart';
import 'package:cook_book/network/repository.dart';
import 'package:cook_book/screens/detail/detail_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({Key key, this.entity}) : super(key: key);

  final ProductEntity entity;
  int bottomSelectedIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    var cubit = DetailCubit(repository: NetworkRepository());
    return BlocProvider(
      create: (_) => cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Hero(
            tag: "product_name_${widget.entity.id}",
            child: Text(widget.entity.title ?? "Детали рецепта"),
          ),
          actions: [
            IconButton(
              color: Colors.yellow,
              icon: Icon(
                cubit.isFavorite ? CupertinoIcons.star_fill : CupertinoIcons.star,
              ),
              onPressed: () {
                setState(() async {
                  await cubit.addToFavorite(widget.entity);
                });
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.bottomSelectedIndex,
          onTap: (value) {
            setState(() {
              widget.bottomSelectedIndex = value;
              widget.pageController.animateToPage(value, duration: Duration(milliseconds: 500), curve: Curves.ease);
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Инфо',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Ингридиенты',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Рецепт',
            ),
          ],
        ),
        body: Container(
          child: PageView(
            controller: widget.pageController,
            onPageChanged: (value) {
              setState(() {
                widget.bottomSelectedIndex = value;
              });
            },
            children: [
              _infoPage(),
              _ingridientsPage(),
              _recieptPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoPage() {
    return SingleChildScrollView(
      child: Container(
        // padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      // height: 200,
                      child: Hero(
                        tag: "product_image_${widget.entity.id}",
                        child: GestureDetector(
                          child: CachedNetworkImage(
                            imageUrl: widget.entity.image,
                            fit: BoxFit.contain,
                          ),
                          onTap: () {
                            Get.to(PhotoViewScreen(src: widget.entity.image));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      Container(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(4),
                          child: Hero(
                            tag: "product_types_${widget.entity.id}",
                            child: Text(
                              widget.entity.tags.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green[400],
                          // borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 4, right: 34, bottom: 4, left: 34),
                          child: Hero(
                            tag: "product_kkal_${widget.entity.id}",
                            child: Text(
                              "Калорийность: ${widget.entity.total_calories} ккал.".toUpperCase(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        "Описание",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Text(widget.entity.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ingridientsPage() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Ингридиенты",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      for (var ingridient in widget.entity.ingredients)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(4),
                          child: Column(
                            children: [
                              Container(
                                // padding: EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        ingridient.ingredient,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ingridient.amount,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 8),
                                child: Divider(),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _recieptPage() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Рецепт",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                  ),
                ),
                Divider(),
                Container(
                  child: Column(
                    children: [
                      for (StepsEntity item in widget.entity.steps)
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  padding: EdgeInsets.all(8),
                                  child: ClipOval(
                                    child: GestureDetector(
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: item.image,
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                      onTap: () {
                                        Get.to(PhotoViewScreen(src: item.image));
                                      },
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
                                        Text(item.description),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
