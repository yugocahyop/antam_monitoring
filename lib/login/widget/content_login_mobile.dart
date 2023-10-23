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

  createMsg(String text) {
    msgs.add(
      MyMessage(
          warningMsg: text,
          dismiss: () {
            msgs.removeAt(msgs.length - 1);
            setState(() {});
          }),
    );

    setState(() {});
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
          child: Column(
            children: [
              Up(),
              const SizedBox(
                height: 50,
              ),
              SvgPicture.asset(
                "assets/logo_antam.svg",
                width: 250,
              ),
              const SizedBox(
                height: 50,
              ),
              Transform.translate(
                offset: Offset(0, 15),
                child: Container(
                  width: lWidth,
                  // height: 500 ,
                  decoration: BoxDecoration(
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
                    child: Column(children: [
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
                                        side: BorderSide(
                                            color: MainStyle.primaryColor),
                                        borderRadius: BorderRadius.circular(3)),
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
                                        style: MyTextStyle.defaultFontCustom(
                                            Colors.black, 14,
                                            weight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            TextButton(
                                onPressed: () {},
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
                          icon: Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                          color: MainStyle.primaryColor,
                          text: "Sign-in",
                          onPressed: () => cc.pageRoute(context, Home()),
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
        Stack(
          children: msgs,
        )
      ],
    );
  }
}
