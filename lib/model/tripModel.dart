
import 'location.dart';

class Trip {
   LocationModel startPoint;
   LocationModel endPoint;
    String routeId;
    String startStationId;
    String endStationId;
   String userId;
   String createDate;
  String startPointAddress;
  String endPointAddress;
  String routeName;
  String fromToOfRoute;




  Trip(this.endPointAddress,this.startPointAddress,this.startPoint, this.endPoint, this.routeId, this.startStationId, this.endStationId, this.userId, this.createDate,this.fromToOfRoute,this.routeName);
}