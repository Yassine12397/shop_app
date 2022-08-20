

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/layout/shop_app/home_screen.dart';
import 'package:shop_application/modules/login/cubit/cubit.dart';
import 'package:shop_application/modules/login/cubit/states.dart';
import 'package:shop_application/shared/components/component.dart';
import 'package:shop_application/shared/network/local/cache_helper.dart';

import '../register_screen.dart';

class ShopLoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status!) {
              print(state.loginModel.data!.token);
              print(state.loginModel.message!);
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data!.token)
                  .then((value) {
                /*ShowToast(
                    text: state.loginModel.message!,
                    state: ToastStates.SUCCESS);*/
                NavigateAndFinish(context, ShopLayout());
              });
            } else {
              print(state.loginModel.message);
              /* ShowToast(
                  text: state.loginModel.message!, state: ToastStates.ERROR);*/
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String value) {
                              if (value.isEmpty)
                                return 'Email address must not be empty';
                              else
                                return null;
                            },
                            label: 'Email Address',
                            prefix: Icons.email_outlined),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                            controller: passwordController,
                            isPassword: ShopLoginCubit.get(context).isPassword,
                            type: TextInputType.visiblePassword,
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                ShopLoginCubit.get(context).UserLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            validate: (String value) {
                              if (value.isEmpty)
                                return 'Password must not be empty';
                              else
                                return null;
                            },
                            label: 'Password',
                            prefix: Icons.lock_outline,
                            suffix: ShopLoginCubit.get(context).suffix,
                            suffixPressed: () {
                              ShopLoginCubit.get(context)
                                  .changePasswordVisibility();
                            }),
                        SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  ShopLoginCubit.get(context).UserLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              text: 'LOGIN',
                              isUpperCase: true),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(('Dont\'t you have an account ?')),
                            TextButton(
                                onPressed: () {
                                  NavigateTo(context, RegisterScreen());
                                },
                                child: Text(
                                  'Register Now',
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
