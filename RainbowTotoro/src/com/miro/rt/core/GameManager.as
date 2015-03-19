package com.miro.rt.core  
{
	import com.miro.rt.scene.GameScene;
	
	import flash.events.EventDispatcher;
	
	import citrus.core.starling.StarlingCitrusEngine;

	public class GameManager extends EventDispatcher
	{
		private static var _instance:GameManager;
		private var _engine:StarlingCitrusEngine;
		
		public function GameManager() 
		{
			super();
		}
		
		public static function get instance():GameManager
		{
			return _instance ||= new GameManager();
		}
		
		public function initialize(engine:StarlingCitrusEngine):void
		{
			_engine = engine;
			
			GameManager.instance.engine.state = new GameScene();
		}
		
		public function get engine():StarlingCitrusEngine
		{
			return _engine;
		}
	}
}
