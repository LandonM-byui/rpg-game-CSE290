extends Resource

## Tracks all data for a currently active enemy in-game
class_name ActiveEnemy

## Base enemy data
var data : EnemyData

## Current enemy health
var health : int

## Current status conditions
var status : Dictionary[EnemyStatus, int]