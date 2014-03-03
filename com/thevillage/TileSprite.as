package com.thevillage 
{
	import com.thevillage.GameData;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	
	
	public class TileSprite extends MovieClip
	{
		public function TileSprite(itemType:int, positionAvailable:Boolean, isRallyPoint:Boolean = false) 
		{
			var art:MovieClip;
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
				default:
					break;
			}
			//graphics.beginFill(color, spriteAlpha);
			//graphics.drawRect(0, 0, GameData.TILE_SIZE, GameData.TILE_SIZE);
			//graphics.endFill();
		}

	}
	
}
