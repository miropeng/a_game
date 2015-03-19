package com.miro.rt.core  {

	import com.miro.rt.data.Config;
	import com.miro.rt.obj.Backgroud;
	import com.miro.rt.obj.Rainbow;
	import com.miro.rt.obj.RainbowDrawer;
	import com.miro.rt.obj.Totoro;
	import com.miro.rt.res.ResAssets;
	
	import flash.geom.Point;
	
	import Box2D.Common.Math.b2Vec2;
	
	import citrus.core.starling.StarlingState;
	import citrus.physics.box2d.Box2D;
	
	import starling.display.Image;

	/**
	 * @author Cyril Poëtte
	 */
	public class GameManager extends StarlingState 
	{
		public static var instance:GameManager;
		
		private var _box2D:Box2D;
		private var _ball:Totoro;
//		private var _chaseBall:Monster;
		private var _hill:Rainbow;
		private var _back:Backgroud;
		
		private var _hillsTexture:RainbowDrawer;
		private var _heroView:Image;
//		private var _monsterView:Image;
		public var isStart:Boolean;
		public var touchInput:TouchInput;
//		public var chaseState:Boolean;
//		private var _chaseJoint:b2Joint;
//		private var _chaseJointDef:b2DistanceJointDef;

		public function GameManager() {
			super();
			
			instance = this;
		}

		override public function initialize():void {
			
			super.initialize();

			_box2D = new Box2D("box2d");
			_box2D.gravity = new b2Vec2(0, Config.G);
			add(_box2D);
			
			touchInput = new TouchInput();
			touchInput.initialize();
			
//			_box2D.visible = true;
			_back = new Backgroud();
			_heroView = new Image(ResAssets.getAtlas().getTexture("totoro"));
			_hillsTexture = new RainbowDrawer(_box2D.scale);
			
			_ball = new Totoro("hero", {radius:1, hurtVelocityX:5, hurtVelocityY:8, group:1, view: _heroView});
			_ball.x = Config.HEOR_START_X * _box2D.scale;
			_ball.y = -10 * _box2D.scale;
			add(_ball);
			
//			_monsterView = new Image(ResAssets.getAtlas().getTexture("m0"));
//			_chaseBall = new Monster("chaseHero", {radius:1, group:1, view: _monsterView});
//			_chaseBall.x = _ball.x - Config.CHASE_GAP * _box2D.scale;
//			_chaseBall.y = -10 * _box2D.scale;
//			add(_chaseBall);
			
			_hill = new Rainbow("hills",{rider:_ball, sliceWidth:30, roundFactor:15, sliceHeight:78, widthHills:stage.stageWidth, registration:"topLeft", view:_hillsTexture});
			add(_hill);
			
			view.camera.setUp(_ball,null,new Point(0.3 , 0.5));
		}
			
		public function get ball():Totoro
		{
			return _ball;
		}
		
//		private function updateChase():void
//		{
//			var velocity:b2Vec2 = _ball.body.GetLinearVelocity();
//			var positon:b2Vec2 = _ball.body.GetPosition();
//			if(velocity.x <= Config.HERO_MIN_V + 1)
//			{
//				chaseState= true;
//				
//				//同时删除鼠标关节
//				if (_chaseJoint != null) {
//					_box2D.world.DestroyJoint(_chaseJoint);
//					_chaseJoint = null;
//				}
//			}
//			else
//			{
//				if(positon.x - _chaseBall.body.GetPosition().x < Config.CHASE_GAP)
//				{
//					return;
//				}
//				
//				chaseState= false;
//				
//				if (_chaseJoint != null) 
//				{
//					//如果有鼠标关节存在，更新鼠标关节的拖动点
////					_chaseJoint.SetTarget(positon);
//				}
//				else
//				{
//					//创建鼠标关节需求
//					if(!_chaseJointDef) 
//					{
//						_chaseJointDef = new b2DistanceJointDef();
//					}
//					_chaseJointDef.bodyA = _ball.body;//设置鼠标关节的一个节点为空刚体，GetGroundBody()可以理解为空刚体
//					_chaseJointDef.bodyB = _chaseBall.body//设置鼠标关节的另一个刚体为鼠标点击的刚体
////					_chaseJointDef.maxForce = 1000;//设置鼠标可以施加的最大的力
////					_chaseJointDef.target.SetV(positon);
//					_chaseJointDef.frequencyHz = 0;
//					_chaseJointDef.dampingRatio = 10;
//					_chaseJointDef.collideConnected = false;
//					_chaseJointDef.Initialize(_ball.body, _chaseBall.body, _ball.body.GetPosition(), _chaseBall.body.GetPosition());
//					
//					//创建鼠标关节
//					_chaseJoint = _box2D.world.CreateJoint(_chaseJointDef);;
//				}
//			}
//		}
		
		override public function update(timeDelta:Number):void 
		{
			super.update(timeDelta);
			
			if(_hillsTexture) _hillsTexture.update();
			if(_back) _back.update();
			if(isStart)
			{
//				updateChase();
			}
			else
			{
				if(touchInput.screenTouched)
				{
					isStart = true;
				}
			}
		}
	}
}
