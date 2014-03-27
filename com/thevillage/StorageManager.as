package com.thevillage 
{
	public class StorageManager
	{
		var resources:Object;
		var maxResources:int;
		var gameScreen:GameScreen;
		
		public var reservations:Array;
		
		public function StorageManager(_gameScreen:GameScreen) 
		{
			gameScreen = _gameScreen;
			initResources();
			reservations = [];
			
			maxResources = 300;
		}
		
		public function initResources()
		{
			resources = new Object();
			resources.crops = 0;
			resources.cheese = 0;
			resources.fish = 0;
			resources.meat = 0;
			resources.wood = 0;
			resources.stone = 0;
			resources.metal = 0;
		}
		
		public function resourcePush(resAmount:int, resType:int)
		{
			var totalResources:int = 0;
			for each(var amt in resources)
			{
				totalResources += amt;
			}
			
			trace("storage manager res push. max res: "+maxResources+" total res: "+totalResources+" res added: "+resAmount);
			
			if(totalResources + resAmount > maxResources)
			{
				// not enough space - wait outside
			}
			else
			{
				// put the resources here and go back to being idle
				//trace("placing resources "+resAmount);
				resources[TileTypes.resourceNameByType(resType)]+=resAmount;
				trace("what i send to gamescreen - resType: "+resType+" amount: "+resources[TileTypes.resourceNameByType(resType)]);
				gameScreen.updateResources(resType, resources[TileTypes.resourceNameByType(resType)]);
				//resources["wheat"]+=resAmount;
			}
		}
		
		public function resourceQuery(resType:int, resAmount:int, courier:Minion = null) : int
		{
			var reservedRes:int = 0;
			
			if( resources[TileTypes.resourceNameByType(resType)] < resAmount)
			{
				reservations.push([resType, resources[TileTypes.resourceNameByType(resType)], courier])
			}
			else
			{
				reservations.push([resType, resAmount, courier]);
			}
			
			reservedRes = Math.min(resAmount, resources[TileTypes.resourceNameByType(resType)]);
			resources[TileTypes.resourceNameByType(resType)] = Math.max(0, resources[TileTypes.resourceNameByType(resType)] - resAmount);
			
			return(reservedRes);
		}
		
		public function pickupReservation(courier:Minion)
		{
			for(var rsrv:int = 0; rsrv < reservations.length; rsrv++)
			{
				if( reservations[rsrv][2] == courier ) // found your order sir!
				{
					courier.handsContent = [reservations[rsrv][0], reservations[rsrv][1]]
					reservations.splice(rsrv, 1);
				}
			}
		}
	}
}