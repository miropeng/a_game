package com.miro.rt.core  {

	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	
	import citrus.core.starling.StarlingState;
	import citrus.physics.box2d.Box2D;
	import com.miro.rt.obj.Backgroud;
	import com.miro.rt.obj.Monster;
	import com.miro.rt.obj.Totoro;
	import com.miro.rt.obj.Rainbow;
	import com.miro.rt.obj.HillsTexture;
	import com.miro.rt.data.Config;

	/**
	 * @author Cyril Poëtte
	 */
	public class GameManager extends StarlingState {
		
		[Embed(source="/../embed/totoro.png")]
		public static const HeroView:Class;
		[Embed(source="/../embed/m0.png")]
		public static const MView:Class;
		public static var instance:GameManager;
		
		private var _box2D:Box2D;
		private var _ball:Totoro;
		private var _chaseBall:Monster;
		private var _hill:Rainbow;
		private var _back:Backgroud;
		
		private var _hillsTexture:HillsTexture;
		private var _heroView:DisplayObject;
		private var _mView:DisplayObject;
		public var isStart:Boolean;
		public var touchInput:TouchInput;
		public var chaseState:Boolean;
		private var _chaseJoint:b2MouseJoint;
		private var _chaseJointDef:b2MouseJointDef;

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
			_heroView = new HeroView();
			_mView = new MView();
			_hillsTexture = new HillsTexture();
//			
			
			_ball = new Totoro("hero", {radius:1, hurtVelocityX:5, hurtVelocityY:8, group:1, view: _heroView});
			_ball.x = Config.HEOR_START_X * _box2D.scale;
			_ball.y = -10 * _box2D.scale;
			add(_ball);
			
			_chaseBall = new Monster("chaseHero", {radius:1, group:1, view: _mView});
			_chaseBall.x = _ball.x - Config.CHASE_GAP * _box2D.scale;
			_chaseBall.y = -10 * _box2D.scale;
			add(_chaseBall);
			
			_hill = new Rainbow("hills",{rider:_ball, sliceWidth:30, roundFactor:15, sliceHeight:78, widthHills:stage.stageWidth, registration:"topLeft", view:_hillsTexture});
			add(_hill);
			
			view.camera.setUp(_ball,null,new Point(0.3 , 0.5));
		}
			
		public function get ball():Totoro
		{
			return _ball;
		}
		
		private function updateChase():void
		{
			var velocity:b2Vec2 = _ball.body.GetLinearVelocity();
			var positon:b2Vec2 = _ball.body.GetPosition();
			if(velocity.x <= Config.HERO_MIN_V + 1)
			{
				chaseState= true;
				
				//同时删除鼠标关节
				if (_chaseJoint != null) {
					_box2D.world.DestroyJoint(_chaseJoint);
					_chaseJoint = null;
				}
			}
			else
			{
				if(positon.x - _chaseBall.body.GetPosition().x < Config.CHASE_GAP)
				{
					return;
				}
				
				chaseState= false;
				
				if (_chaseJoint != null) 
				{
					//如果有鼠标关节存在，更新鼠标关节的拖动点
					_chaseJoint.SetTarget(positon);
				}
				else
				{
					//创建鼠标关节需求
					if(!_chaseJointDef) 
					{
						_chaseJointDef = new b2MouseJointDef();
					}
					_chaseJointDef.bodyA = _box2D.world.GetGroundBody();//设置鼠标关节的一个节点为空刚体，GetGroundBody()可以理解为空刚体
					_chaseJointDef.bodyB = _chaseBall.body//设置鼠标关节的另一个刚体为鼠标点击的刚体
					_chaseJointDef.maxForce = 1000;//设置鼠标可以施加的最大的力
					_chaseJointDef.target.SetV(positon);
					
					//创建鼠标关节
					_chaseJoint = _box2D.world.CreateJoint(_chaseJointDef) as b2MouseJoint;
				}
			}
		}
		
		override public function update(timeDelta:Number):void 
		{
			super.update(timeDelta);
			
			if(_hillsTexture) _hillsTexture.update();
			if(_back) _back.update();
			if(isStart)
			{
				updateChase();
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
