package com.thevillage {
	
	public class Wildlife extends Building
	{
		var forest:Forest;
		
		public function Wildlife(type:int, grid:Array, id:int, _gameScreen:GameScreen) 
		{
			super(type, grid, id, _gameScreen);
			gameScreen = _gameScreen;
			forest = gameScreen.forest;
		}
		
		public override function initBuilding()
		{
			super.initBuilding();
			
			for(var animalInd:int = 0; animalInd < GameData.WILFLIFE_NODES.length; animalInd++)
			{
				
				//var animalObject:Animal = {level: 0, col: GameData.WILDLIFE_NODES[animalInd][0], row: GameData.WILDLIFE_NODES[animalInd][1], art: newTree};
				var animalObject:Animal = new Animal (GameData.WILDLIFE_NODES[animalInd][0], GameData.WILDLIFE_NODES[animalInd][1], this);
				animalObject.x = animalObject.col * GameData.TILE_SIZE;
				animalObject.y = animalObject.row * GameData.TILE_SIZE;
				gameScreen.itemsContainer.addChild(animalObject);
				buildingContent.push(animalObject);
			}
		}
		
		public override function update()
		{
			super.update();
			
			
			for(var ind:int = 0; ind < buildingContent.length ; ind++)
			{
				var animal:Animal = buildingContent[ind];
				
				if(animal.level < GameData.ANIMAL_BIRTH_RATE) // crop not ready
				{
					if(Math.random() < forest.numTrees/forest.buildingContent.length)
					{
						animal.level++;
					}
					animal.art.art.gotoAndStop(Math.ceil(animal.level/GameData.TREE_RESPAWN_TIME * animal.art.art.totalFrames));
				}
			}
		}

	}
	
}
