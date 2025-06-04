// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinDataModel _$CoinDataModelFromJson(Map<String, dynamic> json) =>
    CoinDataModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      image: CoinImage.fromJson(json['image'] as Map<String, dynamic>),
      description: json['description'] as Map<String, dynamic>,
      marketData: MarketData.fromJson(
        json['market_data'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CoinDataModelToJson(CoinDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'market_data': instance.marketData,
    };

CoinImage _$CoinImageFromJson(Map<String, dynamic> json) =>
    CoinImage(large: json['large'] as String);

Map<String, dynamic> _$CoinImageToJson(CoinImage instance) => <String, dynamic>{
  'large': instance.large,
};

MarketData _$MarketDataFromJson(Map<String, dynamic> json) => MarketData(
  currentPrice: json['current_price'] as Map<String, dynamic>,
  marketCap: json['market_cap'] as Map<String, dynamic>,
  totalVolume: json['total_volume'] as Map<String, dynamic>,
  priceChange24h: (json['price_change_percentage_24h'] as num?)?.toDouble(),
  sparkline7d: SparklineData.fromJson(
    json['sparkline_7d'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$MarketDataToJson(MarketData instance) =>
    <String, dynamic>{
      'current_price': instance.currentPrice,
      'market_cap': instance.marketCap,
      'total_volume': instance.totalVolume,
      'price_change_percentage_24h': instance.priceChange24h,
      'sparkline_7d': instance.sparkline7d,
    };

SparklineData _$SparklineDataFromJson(Map<String, dynamic> json) =>
    SparklineData(
      price: (json['price'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$SparklineDataToJson(SparklineData instance) =>
    <String, dynamic>{'price': instance.price};
