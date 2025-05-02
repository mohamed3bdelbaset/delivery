import 'dart:convert';

import 'package:delivery_app/Eat24/eat24_model.dart';
import 'package:delivery_app/Eat24/eat24_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

final String domainadress =
    'https://fourthproject-61945-default-rtdb.firebaseio.com';

class deliverycontroller extends Cubit<deliverystates> {
  deliverycontroller() : super(initialdeliverystates()) {
    getorder();
  }

  List<ordermodel> _order = [];
  List<ordermodel> get order => _order;

  Future<void> getorder() async {
    _order.clear();
    emit(getorderloadingstates());
    try {
      http.Response res =
          await http.get(Uri.parse('$domainadress/delivery.json'));
      Map data = json.decode(res.body);
      if (res.statusCode == 200) {
        data.forEach((key, value) {
          _order.add(ordermodel.fromjson(key, value));
        });
        emit(getordersuccesstates());
      } else {
        emit(getorderErrorstates());
      }
    } catch (e) {
      emit(getorderErrorstates());
    }
  }

  Future<void> deleteorder(ordermodel order) async {
    emit(deleteorderloadingstates());
    try {
      http.Response res = await http
          .delete(Uri.parse('$domainadress/delivery/${order.orderid}.json'));
      if (res.statusCode == 200) {
        for (int i = 0; i < _order.length;) {
          if (order.orderid == _order[i].orderid) {
            _order.removeAt(i);
          }
          break;
        }
        emit(deleteordersuccesstates());
      } else {
        emit(deleteorderErrorstates());
      }
    } catch (e) {
      emit(deleteorderErrorstates());
    }
  }
}
