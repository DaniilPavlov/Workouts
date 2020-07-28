import 'package:flutter/material.dart';
import 'package:workouts/pages/authorization.dart';

import 'home.dart';

class CheckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isLogged = false;
    return isLogged ? HomePage() : AuthorizationPage();
  }
}
