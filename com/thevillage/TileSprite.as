package com.thevillage 
{
	import com.thevillage.GameData;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	
	
	public class TileSprite extends MovieClip
	{
		public var art:MovieClip;
		public function TileSprite(itemType:int, positionAvailable:Boolean, isRallyPoint:Boolean = false, tileOrientation:int = 0) 
		{
			switch (itemType)
			{
				case TileTypes.MAP_TILE_BASIC:
					art = new ArtMapTileBasic() as MovieClip;
					addChild(MovieClip(art));
					break;
				case TileTypes.VILLAGER: // villager
					art = new ArtVillager() as MovieClip;
					addChild(MovieClip(art));
					break;
					
				case TileTypes.TREE: // tree
					art = new ArtTree() as MovieClip;
					addChild(MovieClip(art));
					break;
					
				case TileTypes.STOREHOUSE:
					if(isRallyPoint)
					{
						art = new ArtStorageRally() as MovieClip;
						addChild(MovieClip(art));
					}
					else
					{
						//art = new ArtStorageContent() as MovieClip;
						//addChild(MovieClip(art));
					}
					break;
					
				case TileTypes.CROP_FIELD:
					if(isRallyPoint)
					{
						art = new ArtCropFieldRally() as MovieClip;
						addChild(MovieClip(art));
					}
					else
					{
						art = new ArtCropFieldContent() as MovieClip;
						addChild(MovieClip(art));
					}
					break;
					
				case TileTypes.PASTURE:
					if(isRallyPoint)
					{
						art = new ArtPastureRally() as MovieClip;
						addChild(MovieClip(art));
					}
					else
					{
						art = new ArtPastureContent() as MovieClip;
						addChild(MovieClip(art));
					}
					break;
					
				case TileTypes.FISHERMAN:
					if(isRallyPoint)
					{
						art = new ArtFishermanRally() as MovieClip;
						addChild(MovieClip(art));
					}
					else
					{
						art = new ArtFishermanContent() as MovieClip;
						addChild(MovieClip(art));
					}
					break;
					
				default:
					break;
			}
			
			if(tileOrientation != 0)
			{
				art.gotoAndStop(tileOrientation);
			}
			//graphics.beginFill(color, spriteAlpha);
			//graphics.drawRect(0, 0, GameData.TILE_SIZE, GameData.TILE_SIZE);
			//graphics.endFill();
		}

	}
	
}
