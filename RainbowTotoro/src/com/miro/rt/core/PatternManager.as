package com.miro.rt.core
{
	import com.miro.rt.data.Config;
	import com.miro.rt.event.GameEvent;
	import com.miro.rt.obj.RainbowElevation;
	import com.miro.rt.res.ResAssets;
	
	import flash.geom.Point;
	
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	
	import starling.textures.Texture;

	public class PatternManager
	{
		private static const CREATESTATE_NULL:int = -1;
		private static const CREATESTATE_COIN:int = 0;
		
		private var _state:StarlingState;
		private var _elevation:int = -1;
		private var _changeElevation:Boolean;
		private var _createState:int = -1;
		private var _createHelpObj:Object;
		private static var _instance:PatternManager;
		
		public function PatternManager()
		{
			
		}
		
		public static function get instance():PatternManager
		{
			return _instance ||= new PatternManager();
		}
		
		public function initialize(state:StarlingState):void
		{
			_state = state;
			
//			initEvent();
		}
		
		private function initEvent():void
		{
			CitrusEngine.getInstance().addEventListener(GameEvent.CREATE_HILL_CLIP, _createItem);
		}
		
		private function _createItem(e:GameEvent):void
		{
			var pos:Point = e.data.pos as Point;
			var elevation:int = e.data.elevation;
				
			_changeElevation = _elevation != elevation;
			_elevation = elevation;
			
			if(_createState != CREATESTATE_COIN)
			{
				if(_elevation == RainbowElevation.DOWNHILL)
				{
					_createState = CREATESTATE_COIN;
					_createHelpObj = {changeElevationNum: 0};
				}
			}
			else
			{
				
			}
				
			if(_createState == CREATESTATE_COIN)
			{
				if(_changeElevation)
				{
					_createHelpObj.changeElevationNum++;
				}
				
				if(_createHelpObj.changeElevationNum == 2)
				{
					_createState = CREATESTATE_NULL;
				}
			}
			
			
			if(_createState == CREATESTATE_COIN)
			{
				createCoin(pos);
			}
		}
		
		private function createCoin(pos:Point):void
		{
			var itemView:Texture = ResAssets.getAtlas().getTexture("item0");
			var item:CitrusSprite = new CitrusSprite("item0", {group: Config.DEPTH_MAX, offsetX: -itemView.width / 2, offsetY: -itemView.height / 2, view: itemView});
			item.x = pos.x;
			item.y = pos.y - itemView.height / 2;
			
			_state.add(item);
			
		}
		
		public function update():void
		{
			
		}
	}
}