import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'IconData.dart';

Widget IconSvg(int id,
    {Color color, double width, double height, bool nullColor}) {
  String icon(String name, {bool active, bool check}) {
    String path = "assets/images/";
    if (active != null) path = "lib/assets/icons/active/";
    if (check != null) path = "lib/assets/icons/checkBox/";
    String ex = ".svg";
    return path + name + ex;
  }

  String iconName = "next";

  switch (id) {
    case 0:
      iconName = icon('back_ellipse');
      break;
    case 1:
      iconName = icon('heart');
      break;
    case 2:
      iconName = icon('voice');
      break;
    case 3:
      iconName = icon('profile');
      break;
    case 4:
      iconName = icon('paper');
      break;
    case 5:
      iconName = icon('home');
      break;
    case 6:
      iconName = icon('category');
      break;
    case 7:
      iconName = icon('menu');
      break;
    case 8:
      iconName = icon('more');
      break;
    case 9:
      iconName = icon('play');
      break;
    case 10:
      iconName = icon('audioArrow');
      break;
    case 11:
      iconName = icon('moreAudios');
      break;
    case 12:
      iconName = icon('changePhoto');
      break;
    case 13:
      iconName = icon('back_arrow');
      break;
    case 14:
      iconName = icon('audioRepeat');
      break;
    case 15:
      iconName = icon('pause');
      break;
    case 16:
      iconName = icon('cloud_storage');
      break;
    case 17:
      iconName = icon('infinity');
      break;
    case 18:
      iconName = icon('download');
      break;
    case 19:
      iconName = icon('active_subscription');
      break;
    case 20:
      iconName = icon('disactive_subscription');
      break;
    case 21:
      iconName = icon('next');
      break;

    case 22:
      iconName = icon('back15');
      break;

    case 23:
      iconName = icon('to15');
      break;
    case 24:
      iconName = icon('delete');
      break;
    case 25:
      iconName = icon('upload');
      break;
    case 26:
      iconName = icon('add');
      break;
      case 27:
      iconName = icon('photoCollection');
      break;
    case 28:
      iconName = icon('camera');
      break;
    case 29:
      iconName = icon('selectedOn');
      break;
    case 30:
      iconName = icon('selectedOff');
      break;
    case 31:iconName = icon('search');break;
    case 32:iconName = icon('edit');break;
    case 33:iconName = icon('wallet');break;
    case 34:iconName = icon('arrowBottom');break;
    case 35:iconName = icon('swap');break;
    case 36:iconName = icon('addOutline');break;
    default:
      iconName = icon('heart');
      break;
  }

  final String assetName = iconName;
  final Widget svg = SvgPicture.asset(assetName,
      height: height, width: width, color: color, semanticsLabel: 'Acme Logo');

  return svg;
}
