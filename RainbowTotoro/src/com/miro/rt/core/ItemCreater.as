package com.miro.rt.core
{
	import com.miro.rt.data.Config;
	import com.miro.rt.obj.Item;
	import com.miro.rt.res.ResAssets;
	
	import flash.geom.Point;
	
	import citrus.core.CitrusEngine;
	
	import starling.textures.Texture;

	public class ItemCreater
	{
		private var _pool:Vector.<Item>;
		
		public function ItemCreater()
		{
			_pool =new Vector.<Item>();
			for( var i:int = 0; i < 15; i++)
			{
				create(ItemType.COIN);
			}
		}
		
		public function create(type:int, px:int = -100, py:int = -100):Item
		{
			var item:Item = null;
			for(var i:int = 0; i < _pool.length; i++)
			{
				if(_pool[i].itemType == type)
				{
					item = _pool.splice(i, 1)[0];
					break;
				}
			}
			
			item = createImp(item, type, px, py);
			
			return item;
		}
		
		public function recycle(item:Item):void
		{
			item.x = -1000;
			item.y = -1000;
			
			_pool.push(item);
		}
		
		private function createImp(srcItem:Item, type:int, px:int, py:int):Item
		{
			var item:Item;
			
			if(!srcItem)
			{
				var itemView:Texture = ResAssets.getAtlas().getTexture("item0" + type);
				item = new Item("item", {group: Config.DEPTH_MAX, offsetX: -itemView.width / 2, offsetY: -itemView.height / 2, view: itemView});
				item.itemType = type;
				
				CitrusEngine.getInstance().state.add(item);
			}
			else
			{
				item = srcItem;
			}

			if(type == ItemType.COIN)
			{
				item.x = px;
				item.y = py - item.view.height / 2;
			}
			else if(type == ItemType.DAMOND)
			{
				item.x = px;
				item.y = -(CitrusEngine.getInstance().screenHeight * Config.RAINBOW_OFF_Y - Config.HERO_MIN_GAP);
			}
			else if(type == ItemType.HEART)
			{
				item.x = px;
				item.y = py - CitrusEngine.getInstance().screenHeight * Config.RAINBOW_OFF_Y;
			}
			else
			{
				item.x = px;
				item.y = py;
			}
			
			return item;
		}
		
		public function get poolLength():int
		{
			return _pool.length;
		}
	}
}