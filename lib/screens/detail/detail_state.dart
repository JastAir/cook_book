import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class DetailState extends Equatable {
  @override
  List<Object> get props => [];
}

// MARK: General states
class DetailState_Info extends DetailState {}

class DetailState_InProgress extends DetailState {}

class DetailState_Favorite extends DetailState {
  final bool isFavorite;

  DetailState_Favorite(this.isFavorite);
}

class DetailState_OnError extends DetailState {
  final String error;
  DetailState_OnError({@required this.error});
}
