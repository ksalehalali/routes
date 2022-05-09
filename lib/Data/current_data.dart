import 'package:intl/intl.dart';
import '../model/charge_toSave_model.dart';
import '../model/location.dart';
import '../model/payment_saved_model.dart';
import '../model/tripModel.dart';
import '../model/trip_to_save_model.dart';
import '../model/user.dart';


var time = DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now());
Trip trip = Trip('','',LocationModel(29.37631633045168,47.98637351560368), LocationModel(0.0,0.0), '', '', '', '', time,'','');
LocationModel currentLocation = LocationModel(29.37631633045168,47.986373515603680);

LocationModel locationChoose = LocationModel(29.37631633045168,47.986373515603680);

ChargeSaved chargeSaved = ChargeSaved();
PaymentSaved paymentSaved = PaymentSaved();
TripToSave tripToSave = TripToSave();
User user = User(accessToken: ' ');
String promoterId ="";