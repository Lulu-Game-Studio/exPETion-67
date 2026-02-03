extends Node

var levels = {
	"Level1": {"unlocked": true, "items": 0},
	"Level2": {"unlocked": false, "items": 0},
	"Level3": {"unlocked": false, "items": 0},
	"Level4": {"unlocked": false, "items": 0},
	"Level5": {"unlocked": false, "items": 0},
	"Level6": {"unlocked": false, "items": 0},
	"Level7": {"unlocked": false, "items": 0} 
}

func completed_level(level_num, poopCuantity):
	var level_key = "Level"+ str(level_num)
	levels[level_key].items = poopCuantity
	
	if level_num<6:
		var nextLevel = "Level"+ str(level_num+1)
		levels[nextLevel].unlocked=true
		
	checkSecretLevel()
	
func checkSecretLevel():
	var totalPoops = 0 
	for i in range(1, 7):
		totalPoops+=levels["Levels" + str(i)].items
		
	if totalPoops==18:
		levels["Level7"].unlocked =true
