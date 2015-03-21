package com.miro.rt.event
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		public static const CREATE_HILL_CLIP:String = "createHillClip";
		
		private var _data:Object;

		public function GameEvent(type:String, data:Object = null)
		{
			super(type, bubbles, cancelable);
			
			_data = data;
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}