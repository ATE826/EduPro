import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> postSignUp(
  String email,
  String password,
  String lastName,
  String firstName,
  String midName,
  String city,
  String dob,
) async {
  http.Response response = await http.post(
    Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8080,
      path: '/api/register',
    ),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
      'last_name': lastName,
      'first_name': firstName,
      'patronymic': midName,
      'city': city,
      'birthday': dob,
    }),
  );
  if (response.statusCode == 201) {
    var data = jsonDecode(response.body);
    print(data);
    return response;
  } else {
    throw Exception(response.body);
  }
}

Future<http.Response> postLogin(
  String email,
  String password,
) async {
  http.Response response = await http.post(
    Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8080,
      path: '/api/login',
    ),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );
  if (response.statusCode == 201 || response.statusCode == 200) {
    print("201");
    var data = jsonDecode(response.body);
    print(data);
    return response;
  } else {
    print(response.body);
    throw Exception(response.body);
  }
}
