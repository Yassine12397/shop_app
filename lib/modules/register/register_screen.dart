import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/layout/shop_app/home_screen.dart';
import 'package:shop_application/modules/register/cubit/cubit.dart';
import 'package:shop_application/modules/register/cubit/states.dart';
import 'package:shop_application/shared/components/component.dart';
import 'package:shop_application/shared/constant/constant.dart';
import 'package:shop_application/shared/network/local/cache_helper.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
            if (state.loginModel.status!) {
              print(state.loginModel.data!.token);
              print(state.loginModel.message!);
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data!.token)
                  .then((value) {
                /*ShowToast(
                    text: state.loginModel.message!,
                    state: ToastStates.SUCCESS);*/
                token = state.loginModel.data!.token;
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
                          'Register',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'Register now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        SizedBox(
                          height: 30,
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
                          height: 15,
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
                            isPassword:
                                ShopRegisterCubit.get(context).isPassword,
                            type: TextInputType.visiblePassword,
                            onSubmit: (value) {},
                            validate: (String value) {
                              if (value.isEmpty)
                                return 'Password must not be empty';
                              else
                                return null;
                            },
                            label: 'Password',
                            prefix: Icons.lock_outline,
                            suffix: ShopRegisterCubit.get(context).suffix,
                            suffixPressed: () {
                              ShopRegisterCubit.get(context)
                                  .changePasswordVisibility();
                            }),
                        SizedBox(
                          height: 15,
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
                          height: 30,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  ShopRegisterCubit.get(context).UserRegister(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text,
                                      phone: phoneController.text);
                                }
                              },
                              text: 'REGISTER',
                              isUpperCase: true),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
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
