import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/modules/shop_app_screens/search/cubit/cubit.dart';
import 'package:shop_application/modules/shop_app_screens/search/cubit/states.dart';
import 'package:shop_application/shared/components/component.dart';
import 'package:shop_application/shared/styles/colors.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(),
              body: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      defaultFormField(
                          controller: searchController,
                          type: TextInputType.text,
                          validate: (String? text) {
                            if (text!.isEmpty)
                              return 'Type something to search';
                            else
                              return null;
                          },
                          onSubmit: (String text) {
                            SearchCubit.get(context).search(text);
                          },
                          onChange: (String text) {
                            SearchCubit.get(context).search(text);
                          },
                          label: 'Search',
                          prefix: Icons.search),
                      SizedBox(
                        height: 10,
                      ),
                      if (state is SearchLoadingStates)
                        LinearProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      if (state is SearchSuccessStates)
                        Expanded(
                          child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) => buildListProduct(
                                  SearchCubit.get(context)
                                      .model!
                                      .data!
                                      .data![index],
                                  context,
                                  isOldPrice: false),
                              separatorBuilder: (context, index) => MyDivider(),
                              itemCount: SearchCubit.get(context)
                                  .model!
                                  .data!
                                  .data!
                                  .length),
                        )
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget buildListProduct(
    model,
    context, {
    bool isOldPrice = true,
  }) =>
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 120,
          child: Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage(model!.image),
                    width: 120,
                    height: 120.0,
                  ),
                  if (model.discount != 0 && isOldPrice)
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
                        if (model.discount != 0 && isOldPrice)
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
