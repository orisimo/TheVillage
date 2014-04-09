package com.thevillage
{
	
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import com.thevillage.GameEvent;
	import flash.events.KeyboardEvent;
	import flash.display.Stage;

	public class GameUI extends MovieClip
	{
		var buildBtn:MovieClip;
		var buildBtnTypes:Array;
		var buildBtnItems:Array;
		var buildBtnOpen:Boolean;
		
		var trainBtn:MovieClip;
		var trainBtnTypes:Array;
		var trainBtnItems:Array;
		var trainBtnOpen:Boolean;
		
		var foodBtn:MovieClip;
		
		var resourcePanel:MovieClip;
		
		var ind:int;
		
		public function GameUI(food_btn:MovieClip, villagers_btn:MovieClip, train_btn:MovieClip, build_btn:MovieClip, resource_panel:MovieClip) 
		{
			buildBtn = build_btn;
			trainBtn = train_btn;
			foodBtn = food_btn;
			resourcePanel = resource_panel;
			
			addChild(food_btn);
			addChild(villagers_btn);
			addChild(train_btn);
			addChild(build_btn);
			addChild(resource_panel);
			
			initGameUI();
		}
		
		public function initGameUI() 
		{
			initBuildBtn();
			initTrainBtn();
		}
		
		public function initBuildBtn()
		{
			buildBtnTypes = [TileTypes.MANOR_HOUSE, TileTypes.CROP_FIELD, TileTypes.STOREHOUSE, TileTypes.LUMBERMILL,
							 TileTypes.STONECUTTER, TileTypes.BLACKSMITH, TileTypes.HUNTER, TileTypes.FISHERMAN,
							 TileTypes.PASTURE, TileTypes.INN, TileTypes.BONFIRE, TileTypes.WALL,
							 TileTypes.ARCHER_TURRET, TileTypes.GUARD_HOUSE, TileTypes.SPIKED_HOLE, TileTypes.GATEHOUSE];
			
			buildBtn.addEventListener(MouseEvent.CLICK, toggleBuildMenu);
			buildBtnOpen = false;
			
			buildBtnItems = [];
			
			for (ind=0;ind<buildBtnTypes.length;ind++)
			{
				var buildBtnItem:MovieClip = new MenuItemBtn();
				buildBtnItem.text_field.text = TileTypes.itemNameByType(buildBtnTypes[ind]);
				
				buildBtnItem.y = -buildBtnItem.height * (ind+1);
				buildBtn.addChild(buildBtnItem);
				
				buildBtnItem.itemType = buildBtnTypes[ind];
				
				buildBtnItem.addEventListener(MouseEvent.CLICK, dispatchAddItemEvent);
				buildBtnItem.mouseChildren = false;
				
				buildBtnItems.push(buildBtnItem);
				
				buildBtnItem.visible = false;
			}
		}
		
		public function initTrainBtn()
		{
			trainBtnTypes = [TileTypes.VILLAGER];
			trainBtn.addEventListener(MouseEvent.CLICK, toggleTrainMenu);
			trainBtnOpen = false;
			
			trainBtnItems = [];
			
			for (ind=0;ind<trainBtnTypes.length;ind++)
			{
				var trainBtnItem:MovieClip = new MenuItemBtn();
				trainBtnItem.text_field.text = TileTypes.itemNameByType(trainBtnTypes[ind]);
				trainBtnItem.y = -trainBtnItem.height * (ind+1);
				trainBtn.addChild(trainBtnItem);
				
				trainBtnItem.itemType = trainBtnTypes[ind];
				
				trainBtnItem.addEventListener(MouseEvent.CLICK, dispatchAddItemEvent);
				trainBtnItem.mouseChildren = false;
				
				trainBtnItems.push(trainBtnItem);
				
				trainBtnItem.visible = false;
			}
		}
		
		public function dispatchAddItemEvent(e:MouseEvent)
		{
			e.target.dispatchEvent(new GameEvent(GameEvent.ADD_ITEM_EVENT, e.target.itemType, true));
		}
		
		public function toggleBuildMenu(e:MouseEvent)
		{
			buildBtnOpen = !buildBtnOpen;
			for (ind=0;ind<buildBtnItems.length;ind++)
			{
				buildBtnItems[ind].visible = buildBtnOpen;
			}
		}
		
		public function toggleTrainMenu(e:MouseEvent)
		{
			trainBtnOpen = !trainBtnOpen;
			for (ind=0;ind<trainBtnItems.length;ind++)
			{
				trainBtnItems[ind].visible = trainBtnOpen;
			}
		}
		
		public function updateResourcePanel(resourceType:int, resourceAmount:int)
		{
			trace("update res panel - "+String(resourceAmount));
			switch (resourceType)
			{
				case TileTypes.RESOURCE_WHEAT:
					resourcePanel.wheat_txt.text = String(resourceAmount);
					break;
				case TileTypes.RESOURCE_CHEESE:
					resourcePanel.cheese_txt.text = String(resourceAmount);
					break;
				case TileTypes.RESOURCE_FISH:
					resourcePanel.fish_txt.text = String(resourceAmount);
					break;
				case TileTypes.RESOURCE_MEAT:
					resourcePanel.meat_txt.text = String(resourceAmount);
					break;
				case TileTypes.RESOURCE_WOOD:
					resourcePanel.wood_txt.text = String(resourceAmount);
					break;
				case TileTypes.RESOURCE_STONE:
					resourcePanel.stone_txt.text = String(resourceAmount);
					break;
				case TileTypes.RESOURCE_METAL:
					resourcePanel.metal_txt.text = String(resourceAmount);
					break;
				case TileTypes.RESOURCE_FOOD:
					foodBtn.amount_txt.text = String(resourceAmount);
					break;
				default:
					break;
			}
		}
	}
	
}
