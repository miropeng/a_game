package com.miro.rt.obj 
{
	import com.miro.rt.core.GameManager;
	import com.miro.rt.data.Config;
	import com.miro.rt.res.ResAssets;
	
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class Backgroud 
	{
		public static const LAYER_NUM:int = 4;
		private var _layerMap:Object;
		private var _sky:Image;
		private var _clipWidth:Number;
		private var _state:StarlingState;
		
		public function Backgroud()
		{
			_state = CitrusEngine.getInstance().state as StarlingState;
			
			_sky = new Image(ResAssets.getAtlas().getTexture("sky"));
			_state.addChildAt(_sky, 0);
			
			_layerMap = new Object();
			for(var i:int = 0; i < LAYER_NUM; i++)
			{
				var imgs:Array = new Array();
				for(var a:int = 0; a < 2; a++)
				{
					var imgView:Texture  = ResAssets.getAtlas().getTexture("layer" + i);
					if(isNaN(_clipWidth))
					{
						_clipWidth = imgView.width - 1;
					}
					
					var group:int = (i == LAYER_NUM - 1) ? Config.DEPTH_MAX + i : i + 10;
					var img:CitrusSprite = new CitrusSprite("img" + i + a, 
						{x:_clipWidth * a, y:_state.stage.stageHeight - imgView.height, parallaxX:0.1 + i * 0.2, parallaxY:0, 
							width:_clipWidth, view:imgView, group: group});
					
					imgs.push(img);
					_state.add(img);
				}
				
				_layerMap["layer" + i] = {imgs: imgs, idx: 0}
			}
		}
		
		private function get state():GameManager
		{
			return GameManager.instance;
		}
		
		public function update(tarX:Number):void 
		{
			var outOfStage:Boolean = false;
			var outOffX:Number = 150;
			
			for(var i:int = 0; i <LAYER_NUM; i++)
			{
				var mapObj:Object = _layerMap["layer" + i];
				var layerImgs:Array = mapObj.imgs;
				
				outOfStage = tarX * layerImgs[0].parallaxX >= (mapObj.idx + 1) * _clipWidth + outOffX;
				
				if(outOfStage)
				{
					var h:CitrusSprite = layerImgs.shift();
					h.x = layerImgs[length -1].x + _clipWidth;
					layerImgs.push(h);
					mapObj.idx++;
				}
			}
		}
		
		public function destroy():void
		{
			
			for(var i:int = 0; i < LAYER_NUM; i++)
			{
				var mapObj:Object = _layerMap["layer" + i];
				
				var layerImgs:Array = mapObj.imgs;
				for(var a:int = 0; a < layerImgs.length; a++)
				{
					layerImgs[a].destroy();
				}
			}
			if(_sky)
			{
				if(_sky.parent)
				{
					_sky.parent.removeChild(_sky);
				}
				_sky.dispose();
				_sky = null;
			}
			_layerMap = null;
			_state = null;
		}
	}
}