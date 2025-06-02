// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinModel _$CoinModelFromJson(Map<String, dynamic> json) => CoinModel(
  id: json['id'] as String?,
  name: json['name'] as String?,
  apiSymbol: json['apiSymbol'] as String?,
  symbol: json['symbol'] as String?,
  marketCapRank: (json['marketCapRank'] as num?)?.toInt(),
  thumb: json['thumb'] as String?,
  large: json['large'] as String?,
);

Map<String, dynamic> _$CoinModelToJson(CoinModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'apiSymbol': instance.apiSymbol,
  'symbol': instance.symbol,
  'marketCapRank': instance.marketCapRank,
  'thumb': instance.thumb,
  'large': instance.large,
};
