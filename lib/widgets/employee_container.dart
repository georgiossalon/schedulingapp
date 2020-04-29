import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';

//!! Maybe stateful?
class EmployeeContainer extends StatelessWidget {
  final Employee employee;

  const EmployeeContainer({Key key, this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 55.0,
                height: 55.0,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://m.media-amazon.com/images/M/MV5BMTcxOTk4NzkwOV5BMl5BanBnXkFtZTcwMDE3MTUzNA@@._V1_.jpg'),
                ),
              ),
              SizedBox(width: 25.0),
              Column(
                children: <Widget>[
                  Text(
                    employee.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    employee.designation,
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              )
            ],
          ),
          //todo: add => availability, delete, edit
          Row()
        ],
      ),
    );
  }
}
