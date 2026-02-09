extends Node


var totalPoops = 0

var levels = {
	1: {"unlocked": true, "items": 0},
	2: {"unlocked": false, "items": 0},
	3: {"unlocked": false, "items": 0},
	4: {"unlocked": false, "items": 0},
	5: {"unlocked": false, "items": 0},
	6: {"unlocked": false, "items": 0},
	7: {"unlocked": false, "items": 0} 
}

func completed_level(level_num: int, poopCuantity: int):

	if levels.has(level_num):

		if poopCuantity > levels[level_num].items:
			levels[level_num].items = poopCuantity

		if level_num < 6:
			levels[level_num + 1].unlocked = true
			
			
		checkSecretLevel()

func checkSecretLevel():
	totalPoops = 0
	for i in range(1, 7):
		totalPoops += levels[i].items
		
	if totalPoops >= 18:
		levels[7].unlocked = true
