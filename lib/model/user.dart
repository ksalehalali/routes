


class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? avatarUrl;
  String? accessToken;
  String? fcmToken;
  double? totalBalance;
  String? PaymentCode;

  User({this.phone,this.name,this.email,this.id,this.avatarUrl,this.accessToken,this.fcmToken,this.totalBalance,this.PaymentCode});

  User.fromSnapshot(){
    id ='';
    email ='';
    name = '';
    phone = '';
    avatarUrl = '';
    PaymentCode = '';


  }
}