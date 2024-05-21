// import 'dart:convert';

// SubCategoryModel subCategoryModelFromJson(String str) =>
//     SubCategoryModel.fromJson(json.decode(str));

// String subCategoryModelToJson(SubCategoryModel data) =>
//     json.encode(data.toJson());

// class SubCategoryModel {
//   List<SubCategoryItemModel> data;
//   int statusCode;
//   String message;
//   bool isSuccess;
//   List<dynamic> errors;

//   SubCategoryModel({
//     required this.data,
//     required this.statusCode,
//     required this.message,
//     required this.isSuccess,
//     required this.errors,
//   });

//   factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
//       SubCategoryModel(
//         data: List<SubCategoryItemModel>.from((json["Data"] as List)
//             .map((x) => SubCategoryItemModel.fromJson(x))),
//         statusCode: json["StatusCode"],
//         message: json["Message"],
//         isSuccess: json["IsSuccess"],
//         errors: List<dynamic>.from(json["Errors"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "Data": List<dynamic>.from(data.map((x) => x.toJson())),
//         "StatusCode": statusCode,
//         "Message": message,
//         "IsSuccess": isSuccess,
//         "Errors": List<dynamic>.from(errors.map((x) => x)),
//       };
// }

// class SubCategoryItemModel {
//   int id;
//   String name;
//   dynamic description;
//   dynamic metaKeywords;
//   dynamic metaDescription;
//   dynamic metaTitle;
//   String seName;
//   int parentCategoryId;
//   PictureModel pictureModel;
//   dynamic subCategories;
//   dynamic featuredProducts;
//   dynamic products;

//   SubCategoryItemModel({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.metaKeywords,
//     required this.metaDescription,
//     required this.metaTitle,
//     required this.seName,
//     required this.parentCategoryId,
//     required this.pictureModel,
//     required this.subCategories,
//     required this.featuredProducts,
//     required this.products,
//   });

//   factory SubCategoryItemModel.fromJson(Map<String, dynamic> json) =>
//       SubCategoryItemModel(
//         id: json["Id"],
//         name: json["Name"],
//         description: json["Description"],
//         metaKeywords: json["MetaKeywords"],
//         metaDescription: json["MetaDescription"],
//         metaTitle: json["MetaTitle"],
//         seName: json["SeName"],
//         parentCategoryId: json["ParentCategoryId"],
//         pictureModel: PictureModel.fromJson(json["PictureModel"]),
//         subCategories: json["SubCategories"],
//         featuredProducts: json["FeaturedProducts"],
//         products: json["Products"],
//       );

//   Map<String, dynamic> toJson() => {
//         "Id": id,
//         "Name": name,
//         "Description": description,
//         "MetaKeywords": metaKeywords,
//         "MetaDescription": metaDescription,
//         "MetaTitle": metaTitle,
//         "SeName": seName,
//         "ParentCategoryId": parentCategoryId,
//         "PictureModel": pictureModel.toJson(),
//         "SubCategories": subCategories,
//         "FeaturedProducts": featuredProducts,
//         "Products": products,
//       };
// }

// class PictureModel {
//   String imageUrl;
//   dynamic thumbImageUrl;
//   String fullSizeImageUrl;
//   String title;
//   String alternateText;
//   CustomProperties customProperties;

//   PictureModel({
//     required this.imageUrl,
//     required this.thumbImageUrl,
//     required this.fullSizeImageUrl,
//     required this.title,
//     required this.alternateText,
//     required this.customProperties,
//   });

//   factory PictureModel.fromJson(Map<String, dynamic> json) => PictureModel(
//         imageUrl: json["ImageUrl"],
//         thumbImageUrl: json["ThumbImageUrl"],
//         fullSizeImageUrl: json["FullSizeImageUrl"],
//         title: json["Title"],
//         alternateText: json["AlternateText"],
//         customProperties: CustomProperties.fromJson(json["CustomProperties"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "ImageUrl": imageUrl,
//         "ThumbImageUrl": thumbImageUrl,
//         "FullSizeImageUrl": fullSizeImageUrl,
//         "Title": title,
//         "AlternateText": alternateText,
//         "CustomProperties": customProperties.toJson(),
//       };
// }

// class CustomProperties {
//   CustomProperties();

//   factory CustomProperties.fromJson(Map<String, dynamic> json) =>
//       CustomProperties();

//   Map<String, dynamic> toJson() => {};
// }
