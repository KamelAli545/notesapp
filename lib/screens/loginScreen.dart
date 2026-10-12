import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:notesapp/cubit/auth_cubit.dart';
import 'registerScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hide = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit,AuthState>(
          listener: (context,state){
            if(state is AuthError){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        builder: (context,state){
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Lottie.asset('assets/animations/Notes.json',
                      height: 180
                      ),
                    ),
                    Text("Let’s Login",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    SizedBox(height: 5,),
                    Text("And note your ideas",
                      style: TextStyle(
                          fontSize: 15,
                        color: Colors.grey
                      ),
                    ),
                    SizedBox(height: 5,),

                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Colors.purple
                          )
                          , border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      )),
                      validator: (v) => v == null || !v.contains('@')
                          ? 'Enter a valid email'
                          : null,
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _password,
                      obscureText: _hide,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                            color: Colors.purple
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _hide ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _hide = !_hide),
                        ),
                      ),
                      validator: (v) => v == null || v.length < 6
                          ? 'Min 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Colors.purple
                        ),
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<AuthCubit>()
                                .login(_email.text, _password.text);
                          }
                        },
                        child: state is AuthLoading
                            ? const CircularProgressIndicator()
                            : const Text('Login',
                          style: TextStyle(
                            color: Colors.white
                          ),
                       ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RegisterScreen())),
                      child: Center(
                        child: const Text("Don't have an account? Register",
                        style: TextStyle(
                          color: Colors.purple
                        ),),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Center(
                      child: Text("OR",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                    GoogleSignInButton(
                        loadingIndicator:
                           SizedBox(
                            width: 24,
                            height: 24,
                             child: CircularProgressIndicator(strokeWidth: 2,),
                          ),
                        clientId: "254953698829-6niaqj5i73c44r5uavs2sevl4f76drs9.apps.googleusercontent.com")




                  ],
                )),
              ),
            );
        },
          ),




    );
  }
}
