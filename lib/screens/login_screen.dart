import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/resources/auth_methods.dart';
import 'package:insta_clone/screens/signup_screen.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _passwordController =TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if(res=="success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
      //navigate to home screen
    } else {
      //show error
      setState(() {
        _isLoading = false;
      });
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2,child: Container(),),
              SvgPicture.asset('assets/images/ic_instagram.svg', height: 64, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
              const SizedBox(height: 64,),
              TextFieldInput(textEditingController: _emailController, hintText: 'Enter your email', textInputType: TextInputType.emailAddress),
              TextFieldInput(textEditingController: _passwordController, hintText: 'Enter your password', textInputType: TextInputType.emailAddress, isPass: true,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: loginUser,
                  child: _isLoading ? Center(child: CircularProgressIndicator(),) : Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))), color: Colors.blue[500] ),
                    child: const Text('Log In',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12,),
              Flexible(flex: 2,child: Container(),),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("Don't have an account?"),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUpScreen()));
                      });

                      //navigate to signup screen
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(" Sign Up", style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  )
                ],
              )

              //svg image
              //text field for email
              //text field for password
              //button for login
              //transition to signup
            ],
          ),
        ),
      ),
    );
  }
}
