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
		
		public function create(type:int, pos:Point = null):Item
		{
			var item:Item = null;
			for(var i:int = 0; i < _pool.length; i++)
			{
				if(_pool[i].itemType == type)
				{
					item = _pool.splice(i, 1)[0];;
					break;
				}
			}
			
			if(!item)
			{
				item = createImp(type, pos);
			}
			
			if(pos)
			{
				item.x = pos.x;
				item.y = pos.y - item.view.height / 2;
			}
			
			return item;
		}
		
		public function recycle(item:Item):void
		{
			item.x = -1000;
			item.y = -1000;
			
			_pool.push(item);
		}
		
		private function createImp(type:int, pos:Point):Item
		{
			var item:Item;
			
			if(type == ItemType.COIN)
			{
				var itemView:Texture = ResAssets.getAtlas().getTexture("item0");
				
				item = new Item("itemCoin", {group: Config.DEPTH_MAX, offsetX: -itemView.width / 2, offsetY: -itemView.height / 2, view: itemView});
				item.itemType = type;
			}
			
			CitrusEngine.getInstance().state.add(item);
			
			return item;
		}
		
		public function get poolLength():int
		{
			return _pool.length;
		}
	}
}