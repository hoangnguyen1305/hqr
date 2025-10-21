import 'package:flutter/material.dart';
import 'package:hqr/contants/color_res.dart';
import 'package:hqr/model/province_response.dart';
import 'package:hqr/utils/convert_utils.dart';

class PlateResponse {
  final List<PlateModel> data;
  final Meta meta;

  const PlateResponse({this.data = const [], this.meta = const Meta()});

  factory PlateResponse.fromJson(Map<String, dynamic> json) => PlateResponse(
    data: ConvertUtils.getList<PlateModel>(json['data'], PlateModel.fromJson),
    meta: Meta.fromJson(json['meta']),
  );
}

class PlateModel {
  final String key;
  final String id;
  final String localSymbol;
  final String serialLetter;
  final String serialNumber;
  final String fullNumber;
  final int status;
  final int color;
  final String vehicle;
  final int startingPrice;
  final String provinceCode;
  final String auctionStartTime;
  final String auctionEndTime;
  final int auctionPrice;
  final int waitingConfirm;
  final ProvinceModel province;
  final String updatedAt;

  const PlateModel({
    this.key = '',
    this.id = '',
    this.localSymbol = '',
    this.serialLetter = '',
    this.serialNumber = '',
    this.fullNumber = '',
    this.status = 0,
    this.color = 0,
    this.vehicle = '',
    this.startingPrice = 0,
    this.provinceCode = '',
    this.auctionStartTime = '',
    this.auctionEndTime = '',
    this.auctionPrice = 0,
    this.waitingConfirm = 0,
    this.province = const ProvinceModel(),
    this.updatedAt = '',
  });

  Color get plateColor {
    switch (color) {
      case 0:
        return ColorRes.backgroundWhiteColor;
      case 3:
        return ColorRes.yellow;
      default:
        return ColorRes.backgroundWhiteColor;
    }
  }

  bool get isCar => vehicle.toLowerCase() == 'car';

  factory PlateModel.fromJson(Map<String, dynamic> json) => PlateModel(
    key: ConvertUtils.getString(json['key']),
    id: ConvertUtils.getString(json['id']),
    localSymbol: ConvertUtils.getString(json['localSymbol']),
    serialLetter: ConvertUtils.getString(json['serialLetter']),
    serialNumber: ConvertUtils.getString(json['serialNumber']),
    fullNumber: ConvertUtils.getString(json['fullNumber']),
    status: ConvertUtils.getInt(json['status']),
    color: ConvertUtils.getInt(json['color']),
    vehicle: ConvertUtils.getString(json['vehicle']),
    startingPrice: ConvertUtils.getInt(json['startingPrice']),
    provinceCode: ConvertUtils.getString(json['provinceCode']),
    auctionStartTime: ConvertUtils.getString(json['auctionStartTime']),
    auctionEndTime: ConvertUtils.getString(json['auctionEndTime']),
    auctionPrice: ConvertUtils.getInt(json['auctionPrice']),
    waitingConfirm: ConvertUtils.getInt(json['waitingConfirm']),
    province: ProvinceModel.fromJson(json['province']),
    updatedAt: ConvertUtils.getString(json['updatedAt']),
  );
}

class Meta {
  final int page;
  final int take;
  final int itemCount;
  final int pageCount;

  const Meta({
    this.page = 1,
    this.take = 50,
    this.itemCount = 0,
    this.pageCount = 0,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    page: ConvertUtils.getInt(json['page']),
    take: ConvertUtils.getInt(json['take']),
    itemCount: ConvertUtils.getInt(json['itemCount']),
    pageCount: ConvertUtils.getInt(json['pageCount']),
  );
}
