import 'package:delivery_app/Shared/Shared_theme/shared_colors.dart';
import 'package:delivery_app/Shared/Shared_widget/custom_field.dart';
import 'package:delivery_app/Shared/Shared_widget/responsive_widget.dart';
import 'package:delivery_app/User/user_controller.dart';
import 'package:flutter/material.dart';

class Login_scrren extends StatefulWidget {
  const Login_scrren({super.key});

  @override
  State<Login_scrren> createState() => _Login_scrrenState();
}

class _Login_scrrenState extends State<Login_scrren> {
  TextEditingController emailcontrooler = TextEditingController();
  TextEditingController passwordcontrooler = TextEditingController();
  TextEditingController newemailcontrooler = TextEditingController();
  TextEditingController newpasswordcontrooler = TextEditingController();
  TextEditingController confirmpasswordcontrooler = TextEditingController();

  GlobalKey<FormState> emailkey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordkey = GlobalKey<FormState>();
  GlobalKey<FormState> newemailkey = GlobalKey<FormState>();
  GlobalKey<FormState> newpasswordkey = GlobalKey<FormState>();
  GlobalKey<FormState> confirmpasswordkey = GlobalKey<FormState>();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool login = false;
  bool StaySigned = false;
  bool birthday = false;
  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    double textlargefont = largetext(MediaQuery.of(context).size.height);
    double textmiddlefont = middletext(MediaQuery.of(context).size.height);
    return Scaffold(
      backgroundColor: Sharedcolors.backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screensize.height / 5, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  maxRadius: screensize.height / 20,
                  minRadius: screensize.height / 20,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/transparentlogo.png'),
                ),
                Text('Food Delivery',
                    style: TextStyle(
                        fontSize: textlargefont + 8,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    fixedSize:
                        Size(screensize.width / 4.5, screensize.height / 13)),
                onPressed: () {
                  setState(() {
                    login = false;
                  });
                },
                child: Column(
                  children: [
                    Text('SIGN IN',
                        style: TextStyle(
                            color: Sharedcolors.defaultColor,
                            fontSize: textlargefont)),
                    if (!login)
                      Divider(
                        color: Sharedcolors.defaultColor,
                        thickness: 3,
                        indent: 15,
                        endIndent: 15,
                      )
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    fixedSize:
                        Size(screensize.width / 4.5, screensize.height / 13)),
                onPressed: () {
                  setState(() {
                    login = true;
                  });
                },
                child: Column(
                  children: [
                    Text('SIGN UP',
                        style: TextStyle(
                            color: Sharedcolors.defaultColor,
                            fontSize: textlargefont)),
                    if (login)
                      Divider(
                        color: Sharedcolors.defaultColor,
                        thickness: 3,
                        indent: 15,
                        endIndent: 15,
                      )
                  ],
                ),
              )
            ],
          ),
          !login
              ? Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 25, right: 25),
                        child: Custom_filed(fieldmodel(
                            hinttext: 'Email',
                            texttype: TextInputType.emailAddress,
                            actiontype: TextInputAction.next,
                            controller: emailcontrooler,
                            key: emailkey,
                            onSubmit: () {})),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 25, right: 25),
                        child: Custom_filed(fieldmodel(
                            hinttext: 'Password',
                            texttype: TextInputType.visiblePassword,
                            actiontype: TextInputAction.done,
                            controller: passwordcontrooler,
                            key: passwordkey,
                            fieldtype: Fieldtype.password,
                            issecure: true,
                            onSubmit: () {})),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Row(
                          children: [
                            Checkbox(
                              value: StaySigned,
                              onChanged: (value) {
                                setState(() {
                                  StaySigned = value!;
                                });
                              },
                            ),
                            Text('Stay Signed in',
                                style: TextStyle(fontSize: textmiddlefont + 2))
                          ],
                        ),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Color(0xffe5222d),
                              elevation: 3.0,
                              fixedSize: Size(screensize.width / 1.2,
                                  screensize.height / 18),
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            if (!_formkey.currentState!.validate()) {
                            } else {
                              Usercontroller().signin(
                                  emailcontrooler, passwordcontrooler, context);
                            }
                          },
                          child: Text('SIGN IN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: textlargefont))),
                      TextButton(
                          onPressed: () {},
                          child: Text('Forget Password?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: textlargefont)))
                    ],
                  ),
                )
              : Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 25, right: 25),
                        child: Custom_filed(fieldmodel(
                            hinttext: 'Email',
                            texttype: TextInputType.emailAddress,
                            actiontype: TextInputAction.next,
                            controller: newemailcontrooler,
                            key: newemailkey,
                            onSubmit: () {})),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 25, right: 25),
                        child: Custom_filed(fieldmodel(
                            hinttext: 'Password',
                            texttype: TextInputType.visiblePassword,
                            actiontype: TextInputAction.next,
                            controller: newpasswordcontrooler,
                            key: newpasswordkey,
                            fieldtype: Fieldtype.password,
                            issecure: true,
                            onSubmit: () {})),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 15, 25, 25),
                        child: Custom_filed(fieldmodel(
                            hinttext: 'Confirn Password',
                            texttype: TextInputType.visiblePassword,
                            actiontype: TextInputAction.done,
                            controller: confirmpasswordcontrooler,
                            key: confirmpasswordkey,
                            fieldtype: Fieldtype.password,
                            issecure: true,
                            onSubmit: () {})),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Color(0xffe5222d),
                              elevation: 3.0,
                              fixedSize: Size(screensize.width / 1.2,
                                  screensize.height / 18),
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            if (!_formkey.currentState!.validate()) {
                            } else if (newpasswordcontrooler.text !=
                                confirmpasswordcontrooler.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.black,
                                      content: Text(
                                          'Password not match Confirm Password',
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: textmiddlefont))));
                            } else {
                              Usercontroller().signup(newemailcontrooler,
                                  newpasswordcontrooler, context);
                            }
                          },
                          child: Text('SIGN UP',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: textlargefont))),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
