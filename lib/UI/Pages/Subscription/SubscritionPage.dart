import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/Pages/Subscription/widgets/chooseSubscription.dart';
import 'package:recorder/UI/widgets/Appbar.dart';
import 'package:recorder/UI/widgets/Background.dart';
import 'package:recorder/UI/widgets/ButtonOrange.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:recorder/generated/l10n.dart';
import 'package:provider/provider.dart';

import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {

  var _subscription;

  var sub_test;
  //sub_month;
  //sub_year;

  void init () async{

    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    print("!!!!!!!!!!!");
    if (!available) {
      // The store cannot be reached or accessed. Update the UI accordingly.
      print("!!!!!!!!!!!aviable");
    }else{
      const Set<String> _kIds = {'test'};
      final ProductDetailsResponse response = await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        // Handle the error.
      }
      List<ProductDetails> products = response.productDetails;
      sub_test = products[0];
    }
  }

  void _listenToPurchaseUpdated(det){

  }

  void buy(subs){
    final ProductDetails productDetails = subs;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    InAppPurchaseConnection.instance.buyConsumable(purchaseParam: purchaseParam);
  }



  @override
  void initState(){
    init();
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }



  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
          alignment: Alignment.topCenter,
          child: Background(
            color: cBlueSoso,
          )),
      SafeArea(
          child: Scaffold(
        backgroundColor: cBackground.withOpacity(0.0),
        appBar: MyAppBar(
          buttonBack: false,
          buttonMenu: true,
          top: 10,
          height: 80,
          tapLeftButton: (){
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
                    letterSpacing: 2),
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
                    letterSpacing: 2),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 5, top: 41, bottom: 110),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: cBackground,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 24,
                        color: cBlack.withOpacity(0.15))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 34,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      S.of(context).choose_subscription,
                      style: TextStyle(
                          fontFamily: fontFamilyMedium,
                          color: cBlack,
                          fontSize: 24,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 34,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11),
                      child: ChooseSubscription(
                        onChange: (index) {
                          currentIndex = index;
                          setState(() {});
                          print('index $index');
                        },
                        items: [

                          SubscriptionPrice(
                            price: S.of(context).price_for_month,
                            timeDuration: S.of(context).for_month,
                          ),
                          SubscriptionPrice(
                            price: S.of(context).price_for_year,
                            timeDuration: S.of(context).for_year,
                          )
                        ],
                      )),
                  SizedBox(
                    height: 37,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 51, right: 47),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).subscription_preference,
                          style: TextStyle(
                              fontFamily: fontFamilyMedium,
                              color: cBlack,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        buildRow(context, S.of(context).no_limit_memory,
                            IconsSvg.infinity),
                        SizedBox(
                          height: 10,
                        ),
                        buildRow(context, S.of(context).cloud_storage,
                            IconsSvg.cloudStorage),
                        SizedBox(
                          height: 10,
                        ),
                        buildRow(context, S.of(context).no_limit_downloads,
                            IconsSvg.download),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 36,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ButtonOrange(
                        onTap: () {
                          buy(sub_test);
                        },
                        text: S.of(context).subscription_for_month),
                  ),
                  SizedBox(
                    height: 34,
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    ]);
  }

  Widget buildRow(BuildContext context, String text, int icon) {
    return Row(
      children: [
        IconSvg(icon, width: 20),
        SizedBox(
          width: 11,
        ),
        Text(
          text,
          style: TextStyle(
              fontFamily: fontFamily,
              color: cBlack,
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
