package com.thevillage {
	
	public class Forest extends Building
	{

		public function Forest(type:int, grid:Array, id:int, _gameScreen:GameScreen) 
		{
			super(type, grid, id, _gameScreen);
			gameScreen = _gameScreen;
		}
		
		public function initBuilding()
		{
			var newTree:TileSprite;
			for(var treeInd:int = 0; treeInd < GameData.FOREST_NODES.length; treeInd++)
			{
				newTree = new TileSprite(TileTypes.TREE, true);
				var treeObject:Object = {level: 0, col: GameData.FOREST_NODES[treeInd][0], row: GameData.FOREST_NODES[treeInd][1], art: newTree};
				newTree.x = treeObject.col * GameData.TILE_SIZE;
				newTree.y = treeObject.row * GameData.TILE_SIZE;
				gameScreen.itemsContainer.addChild(newTree);
				buildingContent.push(treeObject);
			}
		}
		
		public override function update()
		{
			super.update();
			
			for(var ind:int = 0; ind < trees.length ; ind++)
			{
				var tree:Object = buildingContent[ind];
				
				if(tree.level < 6) // crop not ready
				{
					tree.level++;
				}
			}
		}

	}
	
}
