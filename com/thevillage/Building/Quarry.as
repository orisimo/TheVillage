﻿package com.thevillage.Building
{
	import com.thevillage.*;
	
	public class Quarry extends Building
	{

		public function Quarry(type:int, grid:Array, id:int, _gameScreen:GameScreen) 
		{
			super(type, grid, id, _gameScreen);
			gameScreen = _gameScreen;
		}
		
		public override function initBuilding()
		{
			super.initBuilding();
			
			for(var stoneInd:int = 0; stoneInd < GameData.QUARRY_NODES.length; stoneInd++)
			{
				
				//var stoneObject:QuarryStone = {level: 0, col: GameData.FOREST_NODES[stoneInd][0], row: GameData.FOREST_NODES[stoneInd][1], art: newTree};
				var stoneObject:QuarryStone = new QuarryStone (GameData.QUARRY_NODES[stoneInd][0], GameData.QUARRY_NODES[stoneInd][1], this);
				stoneObject.x = stoneObject.col * GameData.TILE_SIZE;
				stoneObject.y = stoneObject.row * GameData.TILE_SIZE;
				gameScreen.itemsContainer.addChild(stoneObject);
				buildingContent.push(stoneObject);
			}
		}
		
		public override function update()
		{
			super.update();
			
			for(var ind:int = 0; ind < buildingContent.length ; ind++)
			{
				var rock:QuarryStone = buildingContent[ind];
				
				if(rock.level < GameData.STONE_RESPAWN_TIME) // crop not ready
				{
					rock.art.art.gotoAndStop(Math.ceil(rock.level/GameData.STONE_RESPAWN_TIME * rock.art.art.totalFrames));
				}
			}
		}

	}
	
}
