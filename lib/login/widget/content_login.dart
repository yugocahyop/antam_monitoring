part of login;

class Content_login extends StatefulWidget {
  Content_login({super.key, required this.signUpDone});

  Function() signUpDone;

  @override
  State<Content_login> createState() => _Content_loginState();
}

class _Content_loginState extends State<Content_login> {
  bool isRemember = false;

  final Mytextfield email = Mytextfield(
    width: 500,
    hintText: "Email",
    obscure: false,
    inputType: TextInputType.emailAddress,
    prefixIcon: Icons.email,
  );

  final Mytextfield password = Mytextfield(
    width: 500,
    hintText: "Password",
    obscure: true,
    prefixIcon: Icons.lock,
    // inputType: TextInputType.emailAddress,
  );

  final cc = Login_controller();
  final sc = ScrollController();

  displayMessage() {}

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return Container(
      width: lWidth * 0.6,
      height: lheight * 0.8,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: MainStyle.secondaryColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: MainStyle.primaryColor,
            width: 7,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 30,
              offset: Offset(0, 20),
              color: Colors.black26,
              spreadRadius: 0,
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Text(
              "Sign-in",
              style: MyTextStyle.defaultFontCustom(
                  MainStyle.primaryColor, lheight < 500 ? 20 : 65,
                  weight: FontWeight.bold),
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            MainStyle.sizedBoxH10,
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/logo_antam.svg",
                    width: lWidth * 0.2,
                  ),
                  SizedBox(
                    width: lWidth * 0.2,
                    child: Scrollbar(
                      controller: sc,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: sc,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: lWidth * 0.2, child: email),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            MainStyle.sizedBoxH20,
                            SizedBox(width: lWidth * 0.2, child: password),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            MainStyle.sizedBoxH10,
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              runAlignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                SizedBox(
                                  width: lWidth < 1300
                                      ? lWidth * 0.2
                                      : (lWidth * 0.2) * 0.5,
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: MainStyle.primaryColor,
                                        value: isRemember,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: MainStyle.primaryColor),
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
                                    onPressed: () {},
                                    child: Text(
                                      "Forget Password ?",
                                      style: MyTextStyle.defaultFontCustom(
                                          MainStyle.primaryColor, 15,
                                          weight: FontWeight.bold),
                                    ))
                              ],
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
                            Center(
                              child: TextButton(
                                  onPressed: () => cc.signUp_login(
                                      context, () => widget.signUpDone()),
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    // runAlignment: WrapAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account? ",
                                        style: MyTextStyle.defaultFontCustom(
                                            Colors.black, 14,
                                            weight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Sign-up",
                                        style: MyTextStyle.defaultFontCustom(
                                            MainStyle.primaryColor, 14),
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
