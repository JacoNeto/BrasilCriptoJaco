import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coin_model.g.dart';

@JsonSerializable()
class CoinModel extends Equatable {
  final String? id;
  final String? name;
  final String? apiSymbol;
  final String? symbol;
  final int? marketCapRank;
  final String? thumb;
  final String? large;

  const CoinModel({
    this.id,
    this.name,
    this.apiSymbol,
    this.symbol,
    this.marketCapRank,
    this.thumb,
    this.large,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) => _$CoinModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoinModelToJson(this);
  
  @override
  List<Object?> get props => [id, name, apiSymbol, symbol, marketCapRank, thumb, large];
}
