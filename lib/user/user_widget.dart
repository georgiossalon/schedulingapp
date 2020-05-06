import 'package:flutter/material.dart';
import 'package:snapshot_test/blocs/authentication_bloc/authentication.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserWidget extends StatelessWidget {
  //todo add user information. For this to happen I need a user in the db
  final String userEmail;

  const UserWidget({Key key, this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User: $userEmail'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                LoggedOut(),
              );
            },
          )
        ],
      ),
    );
  }
}