package com.miro.rt.core
{
	import com.miro.rt.event.GameEvent;
	import com.miro.rt.obj.Item;
	import com.miro.rt.obj.RainbowElevation;
	import com.miro.rt.obj.Totoro;
	import com.miro.rt.ui.Sounds;
	
	import flash.geom.Point;
	
	import citrus.core.CitrusEngine;
	import citrus.core.IState;
	import citrus.objects.Box2DPhysicsObject;

	public class PatternManager
	{
		private var _elevation:int = -1;
		private var _changeElevation:Boolean;
		private var _createType:int = -1;
		private var _createHelpObj:Object;
		private var _itemCreater:ItemCreater;
		private static var _instance:PatternManager;
		private var _state:IState;
		private var _displays:Vector.<Item>;
		private var _rider:Box2DPhysicsObject;
		
		public function PatternManager()
		{
		}
		
		public static function get instance():PatternManager
		{
			return _instance ||= new PatternManager();
		}
		
		public function initialize():void
		{
			_itemCreater = new ItemCreater();
			_state = CitrusEngine.getInstance().state;
			_displays = new Vector.<Item>();
			if(!_rider)
			{
				_rider = _state.getFirstObjectByType(Totoro) as Totoro;
			}
			initEvent();
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
			
			if(_createType == ItemType.NULL)
			{
				rdmState();
			}
			
			if(_createType == ItemType.COIN)
			{
				doingCreatCoin(pos);
			}
			else if(_createType == ItemType.DAMOND)
			{
				doingCreatDamond(pos);
			}
		}
		
		private function rdmState():void
		{
			var stateRdm:Number = Math.random();
			if(stateRdm < 0.05)
			{
				_createType = ItemType.COIN;
				_createHelpObj = {creating:false, changeElevationNum: 0, creatingFrequency: 1};
			}
			else if(stateRdm >= 0.05 && stateRdm < 0.06)
			{
				_createType = ItemType.DAMOND;
				_createHelpObj = {creating:false, creatingCount: 0, creatingFrequency: 1};
			}
		}
		
		private function doingCreatCoin(pos:Point):void
		{
			if(!_createHelpObj.creating)
			{
				//判断开始
				if(_changeElevation && _elevation == RainbowElevation.DOWNHILL)
				{
					_createHelpObj.creating = true;
				}
			}
			else
			{
				_createHelpObj.creatingFrequency++;
				
				if(_createHelpObj.creatingFrequency == 3)
				{
					_createHelpObj.creatingFrequency = 0;
					
					//创建道具
					var item:Item = _itemCreater.create(ItemType.COIN, pos);
					_displays.push(item);
					
				}
				
				//判断结束
				if(_changeElevation)
				{
					_createHelpObj.changeElevationNum++;
				}
				if(_createHelpObj.changeElevationNum == 2)
				{
					_createHelpObj.creating = false;
					_createType = ItemType.NULL;
				}
			}
		}
		
		private function doingCreatDamond(pos:Point):void
		{
			if(!_createHelpObj.creating)
			{
				_createHelpObj.creating = true;
			}
			else
			{
				_createHelpObj.creatingFrequency++;
				
				if(_createHelpObj.creatingFrequency == 3)
				{
					_createHelpObj.creatingFrequency = 0;
					
					//创建道具
					var item:Item = _itemCreater.create(ItemType.DAMOND, pos);
					_displays.push(item);
					
					//判断结束
					_createHelpObj.creatingCount++;
					
					if(_createHelpObj.creatingCount == 5)
					{
						_createHelpObj.creating = false;
						_createType = ItemType.NULL;
					}
				}
			}
		}
		
		private function checkDeleteItem():void
		{
			for (var i:int = 0; i < _displays.length; i++) 
			{
				var item:Item = _displays[i];
				if (_rider.x - item.x > CitrusEngine.getInstance().screenWidth / 2) 
				{
					_displays.splice(i, 1);
					_itemCreater.recycle(item);
					
					i--;
				}
			}
		}
		
		public function checkEatItem():void
		{
			var heroItem_xDist:Number;
			var heroItem_yDist:Number;
			var heroItem_sqDist:Number;
			var item:Item;
			
			for (var i:int = 0; i < _displays.length; i++) 
			{
				item = _displays[i];
				
				heroItem_xDist = item.x - _rider.x;
				heroItem_yDist = item.y - _rider.y;
				heroItem_sqDist = heroItem_xDist * heroItem_xDist + heroItem_yDist * heroItem_yDist;
				if (heroItem_sqDist < 5000)
				{
					var score:int = 0;
					if(item.itemType == ItemType.COIN)
					{
						score = 1;
					}
					else if(item.itemType == ItemType.DAMOND)
					{
						score = 10;
					}
					
					GameManager.instance.gameData.score += score;
					if (!Sounds.muted) Sounds.sndEat.play();
					
					_displays.splice(i, 1);
					_itemCreater.recycle(item);
					
					i--;
				}
			}
		}
		
		public function update():void
		{
			checkDeleteItem();
			checkEatItem();
			
//			trace(_displays.length, _itemCreater.poolLength);
		}
	}
}

