import 'package:aspania_city_group/Dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mouse_parallax/mouse_parallax.dart';

import '../Common_Used/button_tile.dart';
import '../Common_Used/text_tile.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController account = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool onLoginHover = false.obs;
  late FocusNode fc;
  @override
  void initState() {
    fc = FocusNode(
      onKeyEvent: (node, event) {
        if (event.physicalKey.debugName ==
            PhysicalKeyboardKey.enter.debugName) {
          validateDataEnteredAndPushTheDashboard();
        }
        return KeyEventResult.ignored;
      },
      canRequestFocus: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: RawKeyboardListener(
        focusNode: fc,
        autofocus: true,
        child: Center(
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  width: width * 0.4,
                  height: height * 0.6,
                  child: ParallaxStack(
                    layers: [
                      ParallaxLayer(
                        xRotation: 0.20,
                        yRotation: 0.35,
                        xOffset: 60,
                        child: Center(
                          child: Container(
                            width: width * 0.4,
                            height: height * 0.6,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                      'assets/images/spainCity.jpg')),
                            ),
                          ),
                        ),
                      ),
                      ParallaxLayer(
                        xRotation: 0.40,
                        yRotation: 0.35,
                        xOffset: 80,
                        yOffset: 0,
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            backgroundBlendMode: BlendMode.softLight,
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage(
                                    'assets/images/Boudy-Elhegaz-real-estate-logo-10.jpg')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),

              /* *SECTION - Dialog To Log In */
              Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 450,
                  margin: const EdgeInsets.only(right: 30, left: 20),
                  height: 375,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(children: [
                    const SizedBox(
                      height: 20,
                    ),
                    /* *SECTION - Sign In Header */
                    Text(
                      'بيانات الدخول',
                      style: GoogleFonts.notoSansArabic(
                          fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    /* *!SECTION */
                    /* *SECTION - Account */
                    TextTile(
                        width: 300,
                        textController: account,
                        onSubmit: (value) {
                          validateDataEnteredAndPushTheDashboard();
                        },
                        title: 'البريد الاكتروني',
                        hintText: 'ادخل البريد الاكتروني',
                        icon: Icons.account_circle_outlined),

                    /* *!SECTION */

                    /* *SECTION - Password */
                    TextTile(
                        width: 300,
                        textController: password,
                        isPassword: true,
                        onSubmit: (value) {
                          validateDataEnteredAndPushTheDashboard();
                        },
                        title: 'الكلمة السرية',
                        hintText: 'ادخل الكلمة السرية',
                        icon: Icons.password_outlined),

                    /* *!SECTION */
                    ButtonTile(
                      onTap: () => validateDataEnteredAndPushTheDashboard(),
                      buttonText: 'تسجيل الدخول',
                    ),
                  ]),
                ),
              ),
              /* *!SECTION */
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validateDataEnteredAndPushTheDashboard() {
    if (account.text == 'admin123@gmail.com' && password.text == 'admin2876') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } else {
      Get.showSnackbar(const GetSnackBar(
        animationDuration: Duration(seconds: 1),
        duration: Duration(seconds: 2),
        message: 'اعد كتابة البريد الالكتروني // كلمة السرية صحيحا',
      ));
    }
  }
}
