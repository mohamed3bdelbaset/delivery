class ordermodel {
  String orderid;
  List location;
  String payment;
  String totalprice;
  double delivery;
  List product;
  List number;
  List price;

  ordermodel(
      {required this.delivery,
      required this.location,
      required this.number,
      required this.orderid,
      required this.payment,
      required this.price,
      required this.product,
      required this.totalprice});
  factory ordermodel.fromjson(String id, Map data) {
    return ordermodel(
        delivery: data['delivery'],
        location: data['location'],
        number: data['number'],
        orderid: id,
        payment: data['payment'],
        price: data['price'],
        product: data['product'],
        totalprice: data['totalprice']);
  }
}
