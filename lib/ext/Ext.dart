
import 'package:flutter/material.dart';

bool isPortrait(BuildContext context){
   if(MediaQuery.of(context).orientation == Orientation.portrait) {
     return true ;
   } else {
     return false ;
   }
}