﻿package com.thevillage {
	
	public class Forest extends Building
	{
		
		var animalAmount:int = GameData.ANIMAL_START_AMOUNT;
		var animalRate:int = GameData.ANIMAL_BIRTH_RATE;
		
		public function Forest(type:int, grid:Array, id:int, _gameScreen:GameScreen) 
		{
			super(type, grid, id, _gameScreen);
			gameScreen = _gameScreen;
		}
		
		public override function initBuilding()
		{
			super.initBuilding();
			
			for(var treeInd:int = 0; treeInd < GameData.FOREST_NODES.length; treeInd++)
			{
				
				//var treeObject:ForestTree = {level: 0, col: GameData.FOREST_NODES[treeInd][0], row: GameData.FOREST_NODES[treeInd][1], art: newTree};
				var treeObject:ForestTree = new ForestTree (GameData.FOREST_NODES[treeInd][0], GameData.FOREST_NODES[treeInd][1], this);
				treeObject.x = treeObject.col * GameData.TILE_SIZE;
				treeObject.y = treeObject.row * GameData.TILE_SIZE;
				gameScreen.itemsContainer.addChild(treeObject);
				buildingContent.push(treeObject);
				
				
			}
		}
		
		public override function update()
		{
			super.update();
			
			var numTrees:int = 0;
			
			for(var ind:int = 0; ind < buildingContent.length ; ind++)
			{
				var tree:ForestTree = buildingContent[ind];
				
				if(tree.level < GameData.TREE_RESPAWN_TIME) // crop not ready
				{
					tree.level++;
					tree.art.art.gotoAndStop(Math.ceil(tree.level/GameData.TREE_RESPAWN_TIME * tree.art.art.totalFrames));
				}
				else
				{
					numTrees++;
				}
			}
			
			animalAmount += int(animalRate * numTrees / buildingContent.length);
			
		}

	}
	
}
