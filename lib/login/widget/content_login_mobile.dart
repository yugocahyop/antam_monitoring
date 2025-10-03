part of login;

class Content_login_mobile extends StatefulWidget {
  Content_login_mobile({super.key});

  @override
  State<Content_login_mobile> createState() => _Content_login_mobileState();
}

class _Content_login_mobileState extends State<Content_login_mobile> {
  bool isRemember = false;

  final Mytextfield email = Mytextfield(
    width: 800,
    hintText: "Email",
    obscure: false,
    inputType: TextInputType.emailAddress,
    prefixIcon: Icons.email,
  );

  final Mytextfield password = Mytextfield(
    width: 800,
    hintText: "Password",
    obscure: true,
    prefixIcon: Icons.lock,
    // inputType: TextInputType.emailAddress,
  );

  final cc = Login_controller();

  List<Widget> msgs = [];

  bool isOverlay = false;

  double overlayOpacity = 0;

  toggleOverlay() {
    bool temp = !isOverlay;

    if (temp) {
      setState(() {
        isOverlay = temp;
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          overlayOpacity = 1;
        });
      });
    } else {
      setState(() {
        overlayOpacity = 0;
      });
    }
  }

  createMsg(String text) {
    msgs.add(
      MyMessage_mobile(
          warningMsg: text,
          dismiss: () {
            msgs.removeAt(msgs.length - 1);
            setState(() {});
          }),
    );

    setState(() {});
  }

  getEmail() async {
    final String? emailTemp =
        await cc.loadSharedPref("com.antam.email", "String") as String?;

    email.con.text = emailTemp ?? "";

    if (email.con.text.isNotEmpty) {
      setState(() {
        isRemember = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // createMsg("text");

    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        SizedBox(
          width: lWidth,
          // height: lheight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Up(),
                const SizedBox(
                  height: 50,
                ),
                SvgPicture.asset(
                  "assets/logo_xirka.svg",
                  width: 250,
                ),
                 SizedBox(
                  height: lheight * 0.1,
                ),
                Transform.translate(
                  offset: const Offset(0, 0),
                  child: Container(
                    alignment: Alignment.center,
                    width: lWidth,
                    height: lheight * 0.60,
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, -2),
                              blurRadius: 10,
                              spreadRadius: 0)
                        ],
                        color: MainStyle.secondaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32))),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Login",
                              style: MyTextStyle.defaultFontCustom(
                                  MainStyle.primaryColor, 36,
                                  weight: FontWeight.bold),
                            ),
                            email,
                            password,
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            MainStyle.sizedBoxH10,
                            SizedBox(
                              width: lWidth,
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                runAlignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  SizedBox(
                                    width: (lWidth * 0.4),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: MainStyle.primaryColor,
                                          value: isRemember,
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color:
                                                      MainStyle.primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          onChanged: (value) {
                                            setState(() {
                                              isRemember = value ?? false;
                                            });
                                          },
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isRemember = !isRemember;
                                              });
                                            },
                                            child: Text(
                                              "Remember me",
                                              style:
                                                  MyTextStyle.defaultFontCustom(
                                                      Colors.black, 14,
                                                      weight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () =>
                                          cc.forgetPassword(context),
                                      child: Text(
                                        "Forget Password ?",
                                        style: MyTextStyle.defaultFontCustom(
                                            MainStyle.primaryColor, 15,
                                            weight: FontWeight.bold),
                                      ))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            MyButton(
                                icon: const Icon(
                                  Icons.login,
                                  color: Colors.white,
                                ),
                                color: MainStyle.primaryColor,
                                text: "Sign-in",
                                onPressed: () => cc.login([email, password],
                                    context, isRemember, () => toggleOverlay()),
                                textColor: Colors.white),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            MainStyle.sizedBoxH10,
                            TextButton(
                                onPressed: () => cc.signUp_login(
                                    context,
                                    () => createMsg(
                                        "Activaton link has been sent to your email")),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account? ",
                                      style: MyTextStyle.defaultFontCustom(
                                          Colors.black, 15),
                                    ),
                                    Text(
                                      "Sign-up",
                                      style: MyTextStyle.defaultFontCustom(
                                          MainStyle.primaryColor, 15),
                                    )
                                  ],
                                ))
                          ]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Stack(
          children: msgs,
        ),
        Visibility(
            visible: isOverlay,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: overlayOpacity,
              onEnd: () {
                if (overlayOpacity == 0) {
                  setState(() {
                    isOverlay = false;
                  });
                }
              },
              child: MyOverlay(
                isBlur: true,
                isTransparent: true,
              ),
            ))
      ],
    );
  }
}
