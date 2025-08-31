# クラス定義 ============
class_name singleton
extends Node

# 普通のクラスのように書く
var coins_num: int = 0
var playerPosition = ""

func get_coins_num():
	return coins_num

####情報を保存するやつ（あとで全部これにする
var references = {}

func AddReference(name : String, reference):
	references[name] = reference

func RemoveReference(name : String):
	if references.has(name):
		references.erase(name)

func ClearReferences():
	references.clear()

func GetReference(name : String):
	if references.has(name):
		return references[name]
	return null
