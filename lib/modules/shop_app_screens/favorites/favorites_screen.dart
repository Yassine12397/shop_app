import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/layout/shop_app/cubit/cubit.dart';
import 'package:shop_application/layout/shop_app/cubit/states.dart';
import 'package:shop_application/shared/components/component.dart';
import 'package:shop_application/shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
            condition: state is! ShopLoadingGetFavoritesState,
            builder: (context) => ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => buildFavProduct(
                    ShopCubit.get(context)
                        .favoritesModel!
                        .data!
                        .data![index]
                        .product!,
                    context),
                separatorBuilder: (context, index) => MyDivider(),
                itemCount:
                    ShopCubit.get(context).favoritesModel!.data!.data!.length),
            fallback: (context) => Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget buildFavProduct(model, context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 120,
          child: Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage(model.image),
                    width: 120,
                    height: 120.0,
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
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          model.price.toString(),
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
                            model.oldPrice.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Spacer(),
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              ShopCubit.get(context).changeFavorites(model.id);
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
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
