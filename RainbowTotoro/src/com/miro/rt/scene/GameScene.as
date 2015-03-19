package com.miro.rt.scene
{
	import com.miro.rt.core.TouchInput;
	import com.miro.rt.data.Config;
	import com.miro.rt.obj.Backgroud;
	import com.miro.rt.obj.Rainbow;
	import com.miro.rt.obj.RainbowDrawer;
	import com.miro.rt.obj.Totoro;
	import com.miro.rt.res.ResAssets;
	import com.miro.rt.ui.HUD;
	
	import flash.geom.Point;
	
	import Box2D.Common.Math.b2Vec2;
	
	import citrus.core.starling.StarlingState;
	import citrus.physics.box2d.Box2D;
	
	import starling.display.Image;

	public class GameScene extends StarlingState implements IScene
	{
		private var _totoro:Totoro;
		private var _rainbow:Rainbow;
		private var _back:Backgroud;
		private var _rainbowDrawer:RainbowDrawer;
		private var _box2D:Box2D;
		private var _isStart:Boolean;
		private var _touchInput:TouchInput;
		private var _hud:HUD;
		
		public function GameScene()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();

			_box2D = new Box2D("box2d");
			_box2D.gravity = new b2Vec2(0, Config.G);
//			_box2D.visible = true;
			add(_box2D);
			
			_touchInput = new TouchInput();
			_touchInput.initialize();
			
			_totoro = new Totoro("hero", {radius:1, hurtVelocityX:5, hurtVelocityY:8, group:1});
			_totoro.view = new Image(ResAssets.getAtlas().getTexture("totoro"));
			_totoro.x = Config.HEOR_START_X * _box2D.scale;
			_totoro.y = -10 * _box2D.scale;
			add(_totoro);
			
			_back = new Backgroud(this, _totoro);
			
			_rainbowDrawer = new RainbowDrawer(_box2D.scale);
			_rainbow = new Rainbow("hills",{rider:_totoro, sliceWidth:30, roundFactor:15, sliceHeight:78, widthHills:stage.stageWidth, registration:"topLeft", view:_rainbowDrawer});
			add(_rainbow);
			
			_hud = new HUD();
			addChild(_hud);
			
			view.camera.setUp(_totoro,null,new Point(0.3 , 0.5));
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if(_rainbowDrawer) 
			{
				_rainbowDrawer.update();
			}
			
			if(_isStart)
			{
				if(_back) _back.update();
				if(_hud)
				{
					_hud.distance = Math.round(_totoro.x / _box2D.scale);
				}
				
				_totoro.addTouchVel = _touchInput.screenTouched;
			}
			else
			{
				if(_touchInput.screenTouched)
				{
					_isStart = true;
					_totoro.limitVel = true;
				}
			}
		}
		
		override public function destroy():void
		{
			_totoro.destroy();
			_rainbow.destroy();
			_back.destroy();
			_rainbowDrawer.destroy();
			_box2D.destroy();
			_touchInput.destroy();
			_rainbowDrawer.destroy();
			
			_totoro = null;
			_rainbow = null;
			_back = null;
			_rainbowDrawer = null;
			_box2D = null;
			_touchInput = null;
			_rainbowDrawer = null;
			
			super.destroy();
		}
	}
}