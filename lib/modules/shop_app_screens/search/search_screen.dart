import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/modules/shop_app_screens/search/cubit/cubit.dart';
import 'package:shop_application/modules/shop_app_screens/search/cubit/states.dart';
import 'package:shop_application/shared/components/component.dart';

class SearchScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer(
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
                          validate: (String text) {
                            if (text.isEmpty)
                              return 'Type something to search';
                            else
                              return null;
                          },
                          onSubmit: (String text) {
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
}
