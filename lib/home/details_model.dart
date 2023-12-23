// To parse this JSON data, do
//
//     final detailsModel = detailsModelFromJson(jsonString);

import 'dart:convert';

DetailsModel detailsModelFromJson(String str) => DetailsModel.fromJson(json.decode(str));

String detailsModelToJson(DetailsModel data) => json.encode(data.toJson());

class DetailsModel {
    bool success;
    String message;
    List<Response> response;

    DetailsModel({
        required this.success,
        required this.message,
        required this.response,
    });

    factory DetailsModel.fromJson(Map<String, dynamic> json) => DetailsModel(
        success: json["success"],
        message: json["message"],
        response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
    };
}

class Response {
    String id;
    String name;
    String email;
    String phone1;
    String campus;
    String district;
    String photo;
    bool attended;
    int v;

    Response({
        required this.id,
        required this.name,
        required this.email,
        required this.phone1,
        required this.campus,
        required this.district,
        required this.photo,
        required this.attended,
        required this.v,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone1: json["phone_1"],
        campus: json["campus"],
        district: json["district"],
        photo: json["photo"],
        attended: json["attended"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone_1": phone1,
        "campus": campus,
        "district": district,
        "photo": photo,
        "attended": attended,
        "__v": v,
    };
}
