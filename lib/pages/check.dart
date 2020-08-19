import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workouts/models/user.dart';
import 'package:workouts/pages/authorization.dart';
import 'home.dart';

class CheckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final bool isLogged = user != null;
    return isLogged ? HomePage() : AuthorizationPage();
  }
}
