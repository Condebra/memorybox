import 'package:adapty_flutter/models/adapty_paywall.dart';
import 'package:adapty_flutter/models/adapty_product.dart';
import 'package:adapty_flutter/models/adapty_purchaser_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/Pages/Subscription/widgets/chooseSubscription.dart';
import 'package:recorder/UI/widgets/Appbar.dart';
import 'package:recorder/UI/widgets/Background.dart';
import 'package:recorder/UI/widgets/ButtonOrange.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:recorder/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adapty_flutter/models/adapty_error.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int currentIndex = 1;
  List<AdaptyPaywall> paywalls;
  AdaptyProduct productMonthly;
  AdaptyProduct productYearly;
  SharedPreferences prefs;
  AdaptyPurchaserInfo purchaserInfo;

  void init() async {
    prefs = await SharedPreferences.getInstance();
    // TODO make a server request to check subscription status
    try {
      Adapty.activate();
    } on AdaptyError catch (adaptyErr) {
      print("Adapty ERROR $adaptyErr");
    } catch (e) {
      print("ERROR $e");
    }
    try {
      var getPaywallsResult = await Adapty.getPaywalls();
      paywalls = getPaywallsResult.paywalls;
    } catch (e) {
      print(e);
    }
    try {
      purchaserInfo = await Adapty.getPurchaserInfo();
      print("Info $purchaserInfo");
      if (purchaserInfo.accessLevels['premium']?.isActive ?? false)
        prefs.setString("status", "premium");
      else
        prefs.setString("status", "free");
    } on AdaptyError catch (e) {
      print(e);
    }
    // print(paywalls.length);
    // print(paywalls.first.products.length);
    this.productMonthly = paywalls.first.products.first;
    this.productYearly = paywalls.last.products.first;
    setState(() {});
    print(prefs.getString("status"));
  }

  makePurchase({int id}) async {
    List products = [this.productMonthly, this.productYearly];
    try {
      var purchaseResult = await Adapty.makePurchase(products[id]);
      if (purchaseResult.purchaserInfo.accessLevels['premium'].isActive) {
        await prefs.setString("status", "premium");
        print("===== You are PREMIUM user =====");
      }
    } on AdaptyError catch (adaptyErr) {
      print("ADAPTY ERROR $adaptyErr");
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.sync(context.read<GeneralController>().onWillPop),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Background(
              color: cBlueSoso,
            ),
          ),
          SafeArea(
            child: Scaffold(
              backgroundColor: cBackground.withOpacity(0.0),
              appBar: MyAppBar(
                buttonBack: false,
                buttonMenu: true,
                top: 10,
                height: 80,
                tapLeftButton: () {
                  context.read<GeneralController>().setMenu(true);
                },
                child: Column(
                  children: [
                    Text(
                      S.of(context).subscription,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        fontFamily: fontFamilyMedium,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      S.of(context).more_opportunity,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: fontFamilyMedium,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 41,
                    bottom: 110,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: cBackground,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 24,
                          color: cBlack.withOpacity(0.15),
                        )
                      ],
                    ),
                    child: prefs.getString("status") != "premium"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 34),
                                child: Text(
                                  S.of(context).choose_subscription,
                                  style: TextStyle(
                                    fontFamily: fontFamilyMedium,
                                    color: cBlack,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 11),
                                child: ChooseSubscription(
                                  currentIndex: currentIndex,
                                  onChange: (index) {
                                    currentIndex = index;
                                    setState(() {});
                                    print('index $index');
                                  },
                                  items: [
                                    SubscriptionPrice(
                                      price:
                                          "${this.productMonthly?.localizedPrice ?? S.of(context).price_for_month}",
                                      timeDuration: S.of(context).for_month,
                                    ),
                                    SubscriptionPrice(
                                      price:
                                          "${this.productYearly?.localizedPrice ?? S.of(context).price_for_year}",
                                      timeDuration: S.of(context).for_year,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 40, right: 40, top: 37),
                                child: Container(
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: Text(
                                          S.of(context).subscription_preference,
                                          style: TextStyle(
                                            fontFamily: fontFamilyMedium,
                                            color: cBlack,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      buildRow(
                                        context,
                                        S.of(context).no_limit_memory,
                                        IconsSvg.infinity,
                                      ),
                                      buildRow(
                                        context,
                                        S.of(context).cloud_storage,
                                        IconsSvg.cloudStorage,
                                      ),
                                      buildRow(
                                        context,
                                        S.of(context).no_limit_downloads,
                                        IconsSvg.download,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 36,
                                ),
                                child: ButtonOrange(
                                  onTap: () {
                                    // buy(subTest);
                                    makePurchase(id: currentIndex);
                                  },
                                  text: currentIndex == 0
                                      ? S.of(context).subscription_for_month
                                      : S.of(context).subscription_for_year,
                                ),
                              ),
                            ],
                          )
                        : Container(
                            height: 500,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                iconSvg(IconsSvg.heart, height: 50),
                                SizedBox(height: 6),
                                Text(
                                  "У вас уже есть подписка.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: cBlack,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Спасибо за поддержку!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: cBlack,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Следующий платёж: ??",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: cBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRow(BuildContext context, String text, int icon) {
    return Row(
      children: [
        iconSvg(icon, width: 20),
        SizedBox(
          width: 11,
        ),
        Text(
          text,
          style: TextStyle(
            fontFamily: fontFamily,
            color: cBlack,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
