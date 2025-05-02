import 'dart:math';

import 'package:delivery_app/Eat24/eat24_controller.dart';
import 'package:delivery_app/Eat24/eat24_states.dart';
import 'package:delivery_app/Map/map_controller.dart';
import 'package:delivery_app/Map/map_states.dart';
import 'package:delivery_app/Shared/Shared_widget/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

bool customlocation = false;

class Map_screen extends StatefulWidget {
  const Map_screen({super.key});

  @override
  State<Map_screen> createState() => _Map_screenState();
}

class _Map_screenState extends State<Map_screen> {
  bool hide = false;
  late GoogleMapController _Controller;
  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    double textlargefont = largetext(MediaQuery.of(context).size.height);
    double iconsize = iconSize(MediaQuery.of(context).size.height);
    EdgeInsets padding = hide
        ? EdgeInsets.zero
        : EdgeInsets.fromLTRB(0, 15, 0,
            map_screenheight(screensize.height) + screensize.height / 25);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !hide
          ? BlocBuilder<deliverycontroller, deliverystates>(
              builder: (context, state) {
                deliverycontroller controller =
                    BlocProvider.of<deliverycontroller>(context);
                if (state is getorderloadingstates) {
                  return Text('Loading.....',
                      style: TextStyle(
                          color: Colors.black, fontSize: textlargefont));
                } else if (state is getorderErrorstates) {
                  return Text('Some thing went wrong',
                      style: TextStyle(
                          color: Colors.black, fontSize: textlargefont));
                } else {
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.down,
                    onDismissed: (direction) {
                      hide = true;
                      setState(() {});
                    },
                    child: SizedBox(
                      height: map_screenheight(screensize.height) * 1.25,
                      child: PageView.builder(
                        padEnds: false,
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.order.length,
                        itemBuilder: (context, index) {
                          if (controller.order[index].location.length == 1) {
                            customlocation = true;
                          } else {
                            customlocation = false;
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: CircleBorder()),
                                  onPressed: () {
                                    controller
                                        .deleteorder(controller.order[index])
                                        .then((value) => controller.getorder());
                                  },
                                  child: Icon(Icons.done,
                                      color: Colors.black, size: iconsize - 5),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  !customlocation
                                      ? BlocProvider.of<mapcontroller>(context)
                                          .marker(
                                              double.parse(controller
                                                  .order[index].location[0]),
                                              double.parse(controller
                                                  .order[index].location[1]),
                                              '',
                                              _Controller)
                                      : BlocProvider.of<mapcontroller>(context)
                                          .marker(
                                              0.0,
                                              0.0,
                                              '${controller.order[index].location[0]}',
                                              _Controller);
                                },
                                onDoubleTap: () {
                                  hide = true;
                                  setState(() {});
                                },
                                child: Container(
                                  width: screensize.width / 1.1,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Colors.grey.shade600),
                                      color: Colors.white),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            maxRadius: iconsize,
                                            minRadius: iconsize,
                                            backgroundImage: AssetImage(
                                                'assets/transparentlogo.png'),
                                          ),
                                          Text(
                                              '- - - - - - - - - - - - - - - - - ->',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: iconsize)),
                                          Icon(Icons.location_on,
                                              color: Colors.red,
                                              size: iconsize + 5)
                                        ],
                                      ),
                                      Text(
                                          customlocation
                                              ? "${calculateDistance(28.5321131, 30.6635125, BlocProvider.of<mapcontroller>(context).latLng.latitude, BlocProvider.of<mapcontroller>(context).latLng.longitude)} Hours"
                                              : "${calculateDistance(28.5321131, 30.6635125, double.parse(controller.order[index].location[0]), double.parse(controller.order[index].location[1]))} Hours",
                                          style: TextStyle(
                                              fontSize: textlargefont)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                  '\n${controller.order[index].product.length} Item',
                                                  style: TextStyle(
                                                      fontSize: textlargefont)),
                                              orderdetail(controller, index)
                                            ],
                                          ),
                                          Text(
                                              textAlign: TextAlign.center,
                                              controller.order[index].payment ==
                                                      "Payment upon receipt"
                                                  ? 'Total Price: \n\$ ${controller.order[index].totalprice}  '
                                                  : 'Total Price: \npayment was made  ',
                                              style: TextStyle(
                                                  fontSize: textlargefont))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            )
          : TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.white, shape: CircleBorder()),
              onPressed: () {
                hide = false;
                setState(() {});
              },
              child: Icon(Icons.keyboard_arrow_up,
                  color: Colors.black, size: iconsize)),
      body: BlocBuilder<mapcontroller, mapstates>(
        builder: (context, state) {
          if (state is getmaploadingstates) {
            return Center(child: CircularProgressIndicator.adaptive());
          } else {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: BlocProvider.of<mapcontroller>(context).latLng,
                  zoom: 11),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              markers: BlocProvider.of<mapcontroller>(context).markers,
              onMapCreated: (controller) {
                _Controller = controller;
              },
              padding: padding,
              polylines: Set<Polyline>.of(
                  BlocProvider.of<mapcontroller>(context).polylines.values),
            );
          }
        },
      ),
    );
  }

  TextButton orderdetail(deliverycontroller controller, int index) {
    Size screensize = MediaQuery.of(context).size;
    return TextButton(
      style: TextButton.styleFrom(
        fixedSize: Size(screensize.width / 3, 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: Colors.blue),
        ),
      ),
      onPressed: () => showModalBottomSheet(
        elevation: 3.0,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => Container(
          height: screensize.height / 1.5,
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Text('Order details',
                  style: TextStyle(fontSize: largetext(screensize.height))),
              Expanded(
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemCount: controller.order[index].product.length,
                  itemBuilder: (context, index1) => Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('   ${controller.order[index].product[index1]}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: middletext(screensize.height))),
                        Text(
                            '${controller.order[index].number[index1]} X ${controller.order[index].price[index1]}    ',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: middletext(screensize.height))),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('   Delivery:',
                      style: TextStyle(
                          fontSize: largetext(screensize.height),
                          fontWeight: FontWeight.w400)),
                  Text('\$ ${controller.order[index].delivery}   ',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: middletext(screensize.height)))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('   Total:',
                        style: TextStyle(
                            fontSize: largetext(screensize.height),
                            fontWeight: FontWeight.w400)),
                    Text('\$ ${controller.order[index].totalprice}   ',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: middletext(screensize.height)))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      child: Text(
          textAlign: TextAlign.center,
          'Tap to more detail',
          style: TextStyle(fontSize: middletext(screensize.height))),
    );
  }

  calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return ((12742 * asin(sqrt(a)) / 40) + 0.40).toStringAsFixed(3);
  }
}
