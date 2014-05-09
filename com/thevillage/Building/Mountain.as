package com.thevillage.Building
{
	import com.thevillage.*;
	
	public class Mountain extends Building
	{

		public function Mountain(type:int, grid:Array, id:int, _gameScreen:GameScreen) 
		{
			super(type, grid, id, _gameScreen);
			gameScreen = _gameScreen;
		}
		
		public override function initBuilding()
		{
			super.initBuilding();
		}
		
		public function registerShaft(shaft:MountainShaft)
		{
			buildingContent.push(shaft);
		}
		
		public override function update()
		{
			super.update();
			
			for(var ind:int = 0; ind < buildingContent.length ; ind++)
			{
				buildingContent[ind].art.art.gotoAndStop(Math.ceil(buildingContent[ind].level/GameData.SHAFT_RESPAWN_TIME * buildingContent[ind].art.art.totalFrames));
			}
		}

	}
	
}
