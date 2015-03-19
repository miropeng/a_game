package com.miro.rt.obj 
{
	import com.miro.rt.core.GameManager;
	import com.miro.rt.data.Config;
	import com.miro.rt.res.ResAssets;
	
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Hero;
	
	import starling.textures.Texture;

	public class Backgroud 
	{
		private var _backSky0:CitrusSprite;
		private var _backSky1:CitrusSprite;
	
		private var _backGroud0:CitrusSprite;
		private var _backGound1:CitrusSprite;
		
		private var _clipSkyIdx:int;
		private var _clipGroundIdx:int;
		private var _clipWidth:Number;
		private var _state:StarlingState;
		private var _target:Hero;
		
		public function Backgroud(state:StarlingState, target:Hero)
		{
			_state = state;
			_target = target;
			
			var backView1:Texture  = ResAssets.getAtlas().getTexture("b0");
			_clipWidth = backView1.width - 1;
			var clipHeight:Number = backView1.height;
			var backY:Number = _state.stage.stageHeight - clipHeight + 10;
			
			_backSky0 = new CitrusSprite("back1", {y:backY,parallaxX:Config.BACK0_MOVE_RATE, parallaxY:0,  width:_clipWidth,view:backView1});
			_backSky1 = new CitrusSprite("back2", {y:backY, parallaxX:Config.BACK0_MOVE_RATE, parallaxY:0, x:_clipWidth, width:_clipWidth, view:backView1});
			_state.add(_backSky0);
			_state.add(_backSky1);
			
			var backView2:Texture  = ResAssets.getAtlas().getTexture("b1");
			clipHeight = backView2.height;
			backY = _state.stage.stageHeight - clipHeight + 20;
			
			_backGroud0 = new CitrusSprite("back3", {y:backY,parallaxX:Config.BACK1_MOVE_RATE, group:10,parallaxY:0,  width:_clipWidth,view:backView2});
			_backGound1 = new CitrusSprite("back4", {y:backY, parallaxX:Config.BACK1_MOVE_RATE, group:10,parallaxY:0, x:_clipWidth, width:_clipWidth, view:backView2});
			
			_state.add(_backGroud0);
			_state.add(_backGound1);
		}
		
		private function get state():GameManager
		{
			return GameManager.instance;
		}
		
		public function update():void 
		{
			var outOfStage:Boolean = false;
			var outOffX:Number = 100;
			
			outOfStage = _target.x * Config.BACK0_MOVE_RATE >= (_clipSkyIdx + 1) * _clipWidth + outOffX;
			if(outOfStage)
			{
				if(_clipSkyIdx % 2 == 0)
				{
					_backSky0.x = _backSky1.x + _clipWidth;
				}
				else
				{
					_backSky1.x = _backSky0.x + _clipWidth;
				}
				_clipSkyIdx++;
			}
			
			outOfStage = _target.x * Config.BACK1_MOVE_RATE >= (_clipGroundIdx + 1) * _clipWidth + outOffX;
			if(outOfStage)
			{
				if(_clipGroundIdx % 2 == 0)
				{
					_backGroud0.x = _backGound1.x + _clipWidth;
				}
				else
				{
					_backGound1.x = _backGroud0.x + _clipWidth;
				}
				_clipGroundIdx++;
			}
		}
		
		public function destroy():void
		{
			_backSky0.destroy();
			_backSky1.destroy();
			
			_backGroud0.destroy();
			_backGound1.destroy();
			
			_state = null;
			_target = null;
		}
	}
}