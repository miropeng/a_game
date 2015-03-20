package com.miro.rt.obj  {

	import com.miro.rt.data.Config;
	
	import Box2D.Common.Math.b2Vec2;
	
	import citrus.objects.platformer.box2d.Hero;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.physics.box2d.Box2DShapeMaker;

	/**
	 * @author Cyril Poëtte
	 */
	public class Totoro extends Hero {

		private var _state:int;

		public function Totoro(name:String, params:Object = null) 
		{
			super(name, params);
		}
		
		public function get state():int
		{
			return _state;
		}
		
		public function set state(value:int):void
		{
			_state = value;
		}
		
		override protected function createShape():void
		{
			_shape = Box2DShapeMaker.Circle(radius*2, radius*2);
			
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.friction = _friction;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("GoodGuys");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAll();
		}

		override protected function getSlopeBasedMoveAngle():b2Vec2
		{
//			return Box2DUtils.Rotateb2Vec2(new b2Vec2(acceleration, 8), _combinedGroundAngle);
			return Config.HERO_DEVICE_V;
		}
		
		override public function update(timeDelta:Number):void
		{
			_timeDelta = timeDelta;
		
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			
			if (controlsEnabled)
			{
				
				if(_state == TotoroState.ADD_V)
				{
					friction = _friction;
					velocity.Add(getSlopeBasedMoveAngle());
				}
				else if(_state == TotoroState.FLY)
				{
					var pos:b2Vec2 = _body.GetPosition();
					var minY:int = -(_ce.screenHeight / 2 - Config.HERO_MIN_GAP) / _box2D.scale;
					if(pos.y < minY)
					{
						pos.y = minY;
						_body.SetPosition(pos);
					}
					
					if (velocity.x > Config.HERO_MAX_V)
					{
						velocity.x = Config.HERO_MAX_V;
						
						//update physics with new velocity
						_body.SetLinearVelocity(velocity);
					}
					else if (velocity.x < Config.HERO_MIN_V)
					{
						velocity.x = Config.HERO_MIN_V;
						
						//update physics with new velocity
						_body.SetLinearVelocity(velocity);
					}
					
				}
			}
			
//			updateAnimation();
		}
	}
}
