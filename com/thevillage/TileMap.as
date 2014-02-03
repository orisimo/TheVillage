package com.thevillage {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	import com.untoldentertainment.pathfinding.Pathfinder;
	import com.untoldentertainment.pathfinding.INode;
	import flash.text.TextField;
	
	public class TileMap extends Sprite
	{
		
		public var currentID:int;
		
		public var map:Array;
		
		private var _startNode:INode;
		private var _endNode:INode;
		
		private var _gridHolder:Sprite;
		
		public function TileMap() 
		{
			currentID = 0;
			
			initMap();
			
			//Pathfinder.heuristic = Pathfinder.manhattanHeuristic;
			Pathfinder.heuristic = Pathfinder.euclidianHeuristic;
			
			addChild(_gridHolder);
		}
		
		public function initMap()
		{
			map = [];
			_gridHolder = new Sprite();
			
			for(var row:int = 0; row< GameData.GRID_HEIGHT; row++)
			{
				for(var col:int = 0; col< GameData.GRID_WIDTH; col++)
				{
					//map[col][row] = [0,0];
					//trace(row, col);
					var node:Node = new Node(row, col);
					node.x = col*GameData.TILE_SIZE;
					node.y = row*GameData.TILE_SIZE;
					
					var numTxt:TextField = new TextField();
					numTxt.text = String(map.length);
					node.addChild(numTxt);
					
					map.push( node );
					
					_gridHolder.addChild(node);
				}
			}
		}
		
		private function clearMap():void
		{
			var node:Node;
			for (var i:int = 0; i < map.length; i++) 
			{
				node = map[i];								
				node.highlight();
			}			
		}
		
		public function createRandomMap()
		{
			for(var col:int = 0; col< GameData.GRID_WIDTH; col++)
			{
				for(var row:int = 0; row< GameData.GRID_HEIGHT; row++)
				{
					//map[col][row] = [Math.random()<0.8?0:1,0];
				}
			}
		}
		
		public function getNewID():int
		{
			currentID++;
			return(currentID);
		}
		
		public function verifyPosition(position:Object, itemGrid:Array):Boolean
		{
			//trace(item.itemGrid);
			for(var row:int = position.row; row< Math.min(position.row+Math.sqrt(itemGrid.length), GameData.GRID_HEIGHT); row++)
			{
				for(var col:int = position.col; col< Math.min(position.col+Math.sqrt(itemGrid.length), GameData.GRID_WIDTH); col++)
				{
					if(itemGrid[col-position.col+(row-position.row)*Math.sqrt(itemGrid.length)]==0)
					{
						//trace(row-position.col+(col-position.row)*Math.sqrt(itemGrid.length));
						continue;
					}
					if( !map[col+row*GameData.GRID_WIDTH].traversable )
					{
						return(false);
					}
				}
			}
			return(true);
		}
		
		public function setNode(item:MovieClip, clearNode:Boolean = false)
		{
			//trace("item.col: "+item.col, "item.row: "+item.row);
			for(var col:int = item.col; col< Math.min(item.col+Math.sqrt(item.itemGrid.length), GameData.GRID_WIDTH); col++)
			{
				for(var row:int = item.row; row< Math.min(item.row+Math.sqrt(item.itemGrid.length), GameData.GRID_HEIGHT); row++)
				{
					if( item.itemGrid[(row-item.row)*Math.sqrt(item.itemGrid.length)+col-item.col] != 0 )
					{
						if(clearNode)
						{
							map[col+row*GameData.GRID_WIDTH].type = 0;
							map[col+row*GameData.GRID_WIDTH].id = 0;
							map[col+row*GameData.GRID_WIDTH].traversable = true;
						}
						else
						{
							map[col+row*GameData.GRID_WIDTH].type = item.itemType;
							map[col+row*GameData.GRID_WIDTH].id = item.itemID;
							map[col+row*GameData.GRID_WIDTH].traversable = false;
						}
						//trace("set "+col+" "+row+" "+(col+row*GameData.GRID_WIDTH)+" traversable "+map[col+row*GameData.GRID_WIDTH].traversable);
					}
				}
			}
		}
		
		public function getPathTo(startPosition:Object, targetPosition:Object):Array
		{
			clearMap();
			return Pathfinder.findPath(map[startPosition.col+startPosition.row*GameData.GRID_WIDTH], map[targetPosition.col+targetPosition.row*GameData.GRID_WIDTH], findConnectedNodes);
		}
		
		public function findConnectedNodes( node:INode ):Array
		{
			var n:Node = node as Node;
			var connectedNodes:Array = [];			
			var testNode:Node;
			
			//trace("targetNode: "+n.col, n.row);
			
			if(map[n.col + n.row*GameData.GRID_WIDTH + 1])
				connectedNodes.push( map[n.col + n.row*GameData.GRID_WIDTH + 1] );
			if(map[n.col + n.row*GameData.GRID_WIDTH - 1])
				connectedNodes.push( map[n.col + n.row*GameData.GRID_WIDTH - 1] );
			if(map[n.col + (n.row+1)*GameData.GRID_WIDTH])
				connectedNodes.push( map[n.col + (n.row+1)*GameData.GRID_WIDTH] );
			if(map[n.col + (n.row-1)*GameData.GRID_WIDTH])
				connectedNodes.push( map[n.col + (n.row-1)*GameData.GRID_WIDTH] );
			
			
			for(var i:int = 0; i < connectedNodes.length; i++)
			{
				if(Math.abs(connectedNodes[i].col-n.col)>1 || Math.abs(connectedNodes[i].row-n.row)>1)
					connectedNodes.splice(i, 1);
			}
			
			/*for (var i:int = 0; i < map.length; i++) 
			{
				testNode = map[i];
				if (testNode.row < n.row - 1 || testNode.row > n.row + 1) continue;
				if (testNode.col < n.col - 1 || testNode.col > n.col + 1) continue;
				//if (testNode.row == n.row && testNode.col < n.col-1 && testNode.col > n.col+1 ) continue;
				//else if (testNode.col != n.col && testNode.row < n.row-1 && testNode.row > n.row+1 ) continue;
				//else continue;
				
				connectedNodes.push( testNode );
				//trace("connected node: "+testNode.col, testNode.row);
				//trace("testNode: "+testNode.x, testNode.y);
			}*/
			
			return connectedNodes;
		}
	}
}
