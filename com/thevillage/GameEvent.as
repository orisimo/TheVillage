package com.thevillage 
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		public static const ADD_ITEM_EVENT:String = "ADD_ITEM_EVENT";
		public static const PLACE_ITEM_EVENT:String = "PLACE_ITEM_EVENT";
		
		public var eventData:Object;
		
		public function GameEvent(type:String, eventData:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.eventData = eventData;
		}
	
		public override function clone():Event
		{
			return new GameEvent(type, eventData, bubbles, cancelable);
		}
	}
}
