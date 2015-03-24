package com.miro.rt.core  
{
	import com.miro.rt.data.GameData;
	import com.miro.rt.scene.WelScene;
	
	import flash.events.EventDispatcher;
	
	import citrus.core.starling.StarlingCitrusEngine;

	public class GameManager extends EventDispatcher
	{
		private static var _instance:GameManager;
		private var _engine:StarlingCitrusEngine;
		private var _gameData:GameData;
		
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
			_gameData = new GameData();
//			GameManager.instance.engine.state = new GameScene();
			GameManager.instance.engine.state = new WelScene();
		}
		
		public function get engine():StarlingCitrusEngine
		{
			return _engine;
		}
		
		public function get gameData():GameData
		{
			return _gameData;
		}
	}
}
