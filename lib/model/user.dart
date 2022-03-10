


class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? avatarUrl;
  String? accessToken;
  String? fcmToken;
  double? totalBalance;

  User({this.phone,this.name,this.email,this.id,this.avatarUrl,this.accessToken,this.fcmToken,this.totalBalance});

  User.fromSnapshot(){
    id ='';
    email ='';
    name = '';
    phone = '';
    avatarUrl = '';


  }
}