import 'package:cook_book/common/widgets/appbar_circle_shape.dart';
import 'package:cook_book/common/widgets/loading_container_view.dart';
import 'package:cook_book/network/model/product_entity.dart';
import 'package:cook_book/network/repository.dart';
import 'package:cook_book/screens/dashboard/dashboard_cubit.dart';
import 'package:cook_book/screens/dashboard/dashboard_state.dart';
import 'package:cook_book/screens/dashboard/widgets/dashboard_search_view.dart';
import 'package:cook_book/screens/detail/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'widgets/dashboard_menu_view.dart';
import 'widgets/dashboard_recommended_item_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = DashboardCubit(repository: NetworkRepository());
    return BlocProvider(
      create: (_) => cubit..fetchAll(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "COOK BOOK",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          //   bottom: PreferredSize(
          //     preferredSize: Size.fromHeight(54),
          //     child: Container(
          //       padding: EdgeInsets.all(8),
          //       child: _searchView(cubit),
          //     ),
          //   ),
        ),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          cubit: cubit,
          builder: (context, state) {
            if (state is DashboardState_SearchMode_InProgress) {
              return Center(child: LoadingContainerView());
            }

            if (state is DashboardState_SearchMode_OnResults) {
              return Wrap(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                    child: DashboardSearchView(
                      products: state.products,
                      onItemClick: (ProductEntity product) {
                        Get.to(DetailScreen(entity: product));
                      },
                      onClose: () => context.read<DashboardCubit>().fetchAll(),
                    ),
                  ),
                ],
              );
            }

            return SingleChildScrollView(
              child: Container(
                child: BlocBuilder<DashboardCubit, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardState_InProgress) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: LoadingContainerView(),
                      );
                    }

                    if (state is DashboardState_OnError) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: Text(state.error ?? "Неизвестная ошибка, поробуйте снова!"),
                      );
                    }
                    return _content();
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _content() {
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          height: 300,
          child: CustomPaint(
            painter: AppBarCircleShape(),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 8),
          child: Column(
            children: [
              Container(
                child: DashboardRecommendedItemView(),
              ),
              Container(
                child: DashboardMenuView(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _searchView(DashboardCubit cubit) {
    return Container(
      height: 42,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        padding: EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
        height: double.infinity,
        child: TextField(
          cursorColor: Colors.white70,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hoverColor: Colors.white70,
            labelStyle: TextStyle(color: Colors.white70),
            hintStyle: TextStyle(color: Colors.white70),
            helperStyle: TextStyle(color: Colors.white70),
            icon: Icon(
              Icons.search,
              color: Colors.white70,
            ),
            border: InputBorder.none,
            alignLabelWithHint: true,
            hintText: "Поиск",
          ),
          onChanged: (value) {
            cubit.fetchSearchResults(value);
          },
        ),
      ),
    );
  }
}
