
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:routes/view/screens/routes/search_widget.dart';

import '../../../Assistants/globals.dart';
import '../../../Data/routes_data.dart';
import '../../../controller/all_routes_controller.dart';
import '../../../main.dart';
import '../../../model/route_model.dart';

class FilterListRoutes extends StatefulWidget {
  @override
  FilterListRoutesState createState() => FilterListRoutesState();
}

class FilterListRoutesState extends State<FilterListRoutes> {
  late List<RouteModel> routes;
  String query = '';
  final AllRoutes allRoutesController = Get.find();

  @override
  void initState() {
    super.initState();

    routes = allRoutes;
  }

  @override
  Widget build(BuildContext context) =>  Container(
    color: Colors.white.withOpacity(0.9),
    child: Column(
            children: <Widget>[
              buildSearch(),
              SizedBox(
                height: Get.size.width,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: routes.length,
                  itemBuilder: (context, index) {
                    final route = routes[index];

                    return buildRouteItem(route);
                  },
                ),
              ),
            ],

        ),
  );

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'route_name_txt'.tr,
        onChanged: searchRoute,
      );

  Widget buildRouteItem(RouteModel route) => Column(
    children: [
      Container(width: 300,height: 1,color: routes_color,padding: EdgeInsets.zero,),
      ListTile(

        onTap: (){
print(route.name);
allRoutesController.getStationsRoute(route.id);

        },
            leading: Text(route.name,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
            title: Text(route.from_To),
            subtitle: Text(route.company),
          ),
    ],
  );

  void searchRoute(String query) {
    final routes = allRoutes.where((book) {
      final titleLower = book.name.toLowerCase();
      final authorLower = book.from_To.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          authorLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.routes = routes;
    });
  }
}
