import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/layout/shop_app/cubit/cubit.dart';
import 'package:shop_application/layout/shop_app/cubit/states.dart';
import 'package:shop_application/models/categories_model.dart';
import 'package:shop_application/models/home_model.dart';
import 'package:shop_application/shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (!state.model.status!) {
            print(state.model.message);
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
            condition: ShopCubit.get(context).homeModel != null &&
                ShopCubit.get(context).categoriesModel != null,
            builder: (context) => productBuilder(
                ShopCubit.get(context).homeModel!,
                ShopCubit.get(context).categoriesModel!,
                context),
            fallback: (context) => Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget productBuilder(
          HomeModel model, CategoriesModel categoriesModel, context) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CarouselSlider(
            //     items: model.data!.banners
            //         .map((e) => Image(
            //               image: NetworkImage('${e.image}'),
            //               width: double.infinity,
            //               fit: BoxFit.cover,
            //             ))
            //         .toList(),
            //     options: CarouselOptions(
            //       height: 250.0,
            //       initialPage: 0,
            //       enableInfiniteScroll: true,
            //       reverse: false,
            //       autoPlay: true,
            //       autoPlayInterval: Duration(seconds: 3),
            //       autoPlayAnimationDuration: Duration(seconds: 1),
            //       autoPlayCurve: Curves.fastOutSlowIn,
            //       scrollDirection: Axis.horizontal,
            //       viewportFraction: 1,
            //     )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100,
                    child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            buildCategory(categoriesModel.data!.data![index]),
                        separatorBuilder: (context, index) => SizedBox(
                              width: 10,
                            ),
                        itemCount: categoriesModel.data!.data!.length),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 1 / 1.72,
                children: List.generate(
                  model.data!.products.length,
                  (index) =>
                      buildGridProduct(model.data!.products[index], context),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildGridProduct(ProductModel model, context) => Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.image!),
                  width: double.infinity,
                  height: 200.0,
                ),
                if (model.discount != 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    color: Colors.red,
                    child: Text(
                      'DISCOUNT',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        ' ${model.price.round()}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: defaultColor,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      if (model.discount != 0)
                        Text(
                          ' ${model.oldPrice.round()}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(model.id!);
                          print(model.id);
                        },
                        icon: CircleAvatar(
                          radius: 15,
                          backgroundColor:
                              ShopCubit.get(context).favorites[model.id]!
                                  ? defaultColor
                                  : Colors.grey,
                          child: Icon(
                            Icons.favorite_border_outlined,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildCategory(DataModel model) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(model.image!),
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          Container(
            width: 100,
            color: Colors.black.withOpacity(.8),
            child: Text(
              model.name!,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
}
