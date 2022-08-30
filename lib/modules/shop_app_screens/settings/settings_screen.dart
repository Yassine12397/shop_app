import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/layout/shop_app/cubit/cubit.dart';
import 'package:shop_application/layout/shop_app/cubit/states.dart';
import 'package:shop_application/shared/components/component.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;
        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;

        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if(state is ShopLoadingUpdateUserState)
                  LinearProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      validate: (String value) {
                        if (value.isEmpty)
                          return 'Name must not be empty';
                        else
                          return null;
                      },
                      label: 'Name',
                      prefix: Icons.person),
                  SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      validate: (String value) {
                        if (value.isEmpty)
                          return 'Email Address must not be empty';
                        else
                          return null;
                      },
                      label: 'Email Address',
                      prefix: Icons.email),
                  SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      validate: (String value) {
                        if (value.isEmpty)
                          return 'Phone number must not be empty';
                        else
                          return null;
                      },
                      label: 'Phone',
                      prefix: Icons.phone),
                  SizedBox(
                    height: 20,
                  ),
                  defaultButton(
                      function: () {
                        SignOut(context);
                      },
                      text: 'Logout'),
                  SizedBox(
                    height: 20,
                  ),
                  defaultButton(
                      function: () {
                        if (formKey.currentState!.validate()) {
                          ShopCubit.get(context).UpdateUserData(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text);
                        }
                      },
                      text: 'Update')
                ],
              ),
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
