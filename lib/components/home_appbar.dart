import 'package:coffee_flutter/store/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/src/provider.dart';

class HomeAppbar extends HookWidget {
  const HomeAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location_address = useState('Not found');
    void getLoc() async {
      Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await location.getLocation();

      List<Placemark> placemarks = await placemarkFromCoordinates(
          _locationData.latitude!.toDouble(),
          _locationData.longitude!.toDouble(),
          localeIdentifier: 'ru');
      Placemark place = placemarks[0];
      final address = '${place.street}';
      location_address.value = address;
    }

    useEffect(() {
      getLoc();
    }, []);

    void goToCart() {
      Get.toNamed('/cart');
    }

    void switchMode() {
      Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(24.0, 0, 0, 0),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Good Morning',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 35,
                          )),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/geo.svg',
                            color: context.iconColor,
                          ),
                          const SizedBox(
                            width: 9,
                          ),
                          Text(
                            location_address.value,
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xFF8E8E93)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Stack(children: [
                        IconButton(
                            onPressed: goToCart,
                            iconSize: 35,
                            icon: const Icon(Icons.shopping_bag_outlined)),
                        context.watch<Cart>().count > 0
                            ? Positioned(
                                // draw a red marble
                                top: 10.0,
                                right: 10.0,
                                child: Container(
                                  height: 20,
                                  width: 15,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Center(
                                      child: Text(
                                    context.watch<Cart>().count.toString(),
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ))
                            : Container()
                      ]),
                      IconButton(
                        onPressed: switchMode,
                        iconSize: 35,
                        icon: const Icon(
                          Icons.dark_mode_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
