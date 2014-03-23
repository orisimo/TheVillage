package com.thevillage {
	
	public class Forest 
	{

		public var trees:Array;
		
		public function Forest() 
		{
			initTrees();
		}
		
		public function initTrees()
		{
			var newTree:TileSprite;
			for(var treeInd:int = 0; treeInd < GameData.FOREST_SIZE; treeInd++)
			{
				newTree = new TileSprite(TileTypes.TREE);
				var treeObject:Object = {level: 0, col: 1, row: 1, art: newTree};
				trees.push(treeObject);
			}
		}
		
		public function public function update()
		{
			super.update();
			
			for(var ind:int = 0; ind < trees.length ; ind++)
			{
				var crop:Crop = buildingContent[ind];
				
				if(crop.level < 6) // crop not ready
				{
					crop.level++;
				}
				else if(crop.beingWorked) // crop being worked
				{
					// do nothing
				}
				else if(crop.worker) // crop has a worker (but not being woreked)
				{
					if(crop.worker.col == rally_col && crop.worker.row == rally_row && crop.worker.isIdle()) // the minion is in the cropfield location
					{
						crop.startWork();
					}
					else if(!crop.worker.targetPosition) // the minion isn't on the way (and not in the cropfield location)
					{
						crop.worker.targetPosition = {col: rally_col, row: rally_row};
						crop.worker.update();
					}
				}
				else if(workers) // we have some minions to work the field
				{
					for(var minion_ind:int = 0; minion_ind < workers.length; minion_ind++) // loop through the workers
					{
						var curr_minion:Minion = workers[minion_ind];
						if(!curr_minion.isAssigned) // found an available worker
						{
							//trace("got a ready minion");
							crop.worker = curr_minion;
							crop.worker.isAssigned = true;
							update();
							break;
						}
						
					}
				}
			}
		}

	}
	
}
