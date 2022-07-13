import 'package:flutter/material.dart';
import 'package:kalawadtimes/bloc/bloc.dart';

String link = "https://www.industrialempathy.com/img/remote/ZiClJf-1920w.jpg";
Bloc PAGENOBLOC = Bloc();
Color? buttonselectColor = Color.fromARGB(255, 170, 0, 0);
Color? buttonColor = Color.fromARGB(255, 226, 43, 43);

List SECTIONS = [
  "होम",
  "देश",
  "विदेश",
  "राजस्थान",
  "जयपुर",
  "खेल",
  "चोमू-आमेर", //1
  "शाहपुरा-जमवारामगढ़",
  "कोटपूतली-विराट नगर",
  "बस्सी-चाकसू",
  "बगरू-दूदू",
  "झोटवाड़ा-फुलेरा",
  "खेती-बाड़ी", //2
  "बागवानी",
  "पशु पालन",
  "मुर्गी पालन",
  "मछली पालन",
  "मंडी भाव",
];
Map S1 = {
  "E-papers": 39,
  "Uncategorized": 1,
  "ई पेपर": 61,
  "कोटपूतली-विराट नगर": 41,
  "खेती-बाड़ी": 50,
  "खेल": 49,
  "चोमू-आमेर": 36,
  "जयपुर": 48,
  "झोटवाड़ा-फुलेरा": 44,
  "देश": 45,
  "पशु पालन": 52,
  "बगरू-दूदू": 43,
  "बस्सी-चाकसू": 42,
  "बागवानी": 51,
  "मछली पालन": 54,
  "मंडी भाव": 55,
  "मुर्गी पालन": 53,
  "राजस्थान": 47,
  "विदेश": 46,
  "शाहपुरा-जमवारामगढ़": 40
};

Map AUTHORS = {
  1: "Prateek",
};

List DATA = [
  for (int i = 1; i < 10; i++)
    {
      "data": [
        for (int j = 1; j < 5; j++)
          {"image": link, "title": "Title $i $j", "content": "Content $i $j"}
      ]
    }
];
