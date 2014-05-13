package  {
	
	import com.untoldentertainment.pathfinding.Pathfinder;
	import com.untoldentertainment.pathfinding.INode;
	
	public class TileMap 
	{
		
		public var currentID:int;
		
		public var map:Vector.<Vector.<Array>>;
		
		public function TileMap() 
		{
			currentID = 0;
			
			initMap();
			
			Pathfinder.heuristic = Pathfinder.manhattanHeuristic;
		}
		
		public function initMap()
		{
			map = new Vector.<Vector.<Array>>(GameData.GRID_WIDTH);
			for(var col:int = 0; col< map.length; col++)
			{
				map[col] = new Vector.<Array>(GameData.GRID_HEIGHT)
				
				for(var row:int = 0; row< map[col].length; row++)
				{
					//map[col][row] = [0,0];
					node = new Node(r, c);
					node.x = c * (node.width + GRID_SPACING);
					node.y = r * (node.height + GRID_SPACING);				
					
					_gridHolder.addChild(node);
					
					_nodes.push( node );
					
					map[col][row] = node;
				}
			}
		}
		
		public function createRandomMap()
		{
			for(var col:int = 0; col< map.length; col++)
			{
				for(var row:int = 0; row< map[col].length; row++)
				{
					map[col][row] = [Math.random()<0.8?0:1,0];
				}
			}
		}
		
		public function getNewID():int
		{
			currentID++;
			return(currentID);
		}
		
		public function checkGridAvailability(queryGrid:Array, targetPosition:Array):Boolean
		{
			trace("targetPosition: "+targetPosition);
			for(var col:int = targetPosition[0]; col< Math.min(targetPosition[0]+Math.sqrt(queryGrid.length), map.length-1); col++)
			{
				
				for(var row:int = targetPosition[1]; row< Math.min(targetPosition[1]+Math.sqrt(queryGrid.length), map[col].length-1); row++)
				{
					trace("accessing map["+col+"]["+row+"]");
					if( map[col][row][0] != 0 && queryGrid[(row-targetPosition[1])*Math.sqrt(queryGrid.length)+col-targetPosition[0]] != 0 )
					{
						return(false);
					}
				}
			}
			return(true);
		}
		
		public function setBuildingPosition(building:Building, buildingPosition:Array)
		{
			for(var col:int = buildingPosition[0]; col< Math.min(buildingPosition[0]+Math.sqrt(building.buildingGrid.length), map.length-1); col++)
			{
				for(var row:int = buildingPosition[1]; row< Math.min(buildingPosition[1]+Math.sqrt(building.buildingGrid.length), map[col].length-1); row++)
				{
					if( building.buildingGrid[(row-buildingPosition[1])*Math.sqrt(building.buildingGrid.length)+col-buildingPosition[0]] != 0 )
					{
						map[col][row][0] = building.buildingType;
						map[col][row][1] = building.buildingID;
					}
				}
			}
		}
		
		public function findConnectedNodes( targetPos:Array ):Array
		{
			var connectedNodes:Array = [];
			var iNode:INode = new INode(
			connectedNodes.push([targetPos[0], targetPos[1]-1]);
			connectedNodes.push([targetPos[0], targetPos[1]+1]);
			connectedNodes.push([targetPos[0]-1, targetPos[1]]);
			connectedNodes.push([targetPos[0]+1, targetPos[1]]);
			
			return connectedNodes;
		}
		
		public function findPath()
		{
			Pathfinder.findPath(_startNode, _endNode, findConnectedNodes);
		}
	}
	
}
