package games.tinywings.box2d {

	import Box2D.Common.Math.b2Vec2;
	
	import citrus.objects.platformer.box2d.Hero;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.physics.box2d.Box2DShapeMaker;

	/**
	 * @author Cyril Poëtte
	 */
	public class Ball extends Hero {

//		public var jumpDecceleration:Number = 1;
		
		public function Ball(name:String, params:Object = null) {

			super(name, params);
			
			_friction = 0.1;
			maxVelocity = Config.HERO_MAX_V;
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
			return new b2Vec2(3, 8);
		}
		
		override public function update(timeDelta:Number):void
		{
			_timeDelta = timeDelta;
		
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			
			if (controlsEnabled)
			{
				
				if(TinyWingsGameState.instance.touchInput.screenTouched)
				{
					friction = _friction;
					velocity.Add(getSlopeBasedMoveAngle());
				}
				
				/*var moveKeyPressed:Boolean = false;
				
				_ducking = (_ce.input.isDoing("duck", inputChannel) && _onGround && canDuck);
				
				if (_ce.input.isDoing("right", inputChannel) && !_ducking)
				{
					friction = _friction;
					velocity.Add(getSlopeBasedMoveAngle());
					moveKeyPressed = true;
				}
				
				if (_ce.input.isDoing("left", inputChannel) && !_ducking)
				{
					friction = _friction;
					velocity.Subtract(getSlopeBasedMoveAngle());
					moveKeyPressed = true;
				}
				
				//If player just started moving the hero this tick.
				if (moveKeyPressed && !_playerMovingHero)
				{
					_playerMovingHero = true;
					
				}
					//Player just stopped moving the hero this tick.
				else if (!moveKeyPressed && _playerMovingHero)
				{
					_playerMovingHero = false;
					_fixture.SetFriction(_friction);
				}
				
				if (_onGround && _ce.input.justDid("jump", inputChannel) && !_ducking)
				{
					velocity.y = -jumpHeight;
					onJump.dispatch();
				}
				
				if (_ce.input.isDoing("jump", inputChannel) && !_onGround && velocity.y < 0)
				{
					velocity.y -= jumpAcceleration;
				}
				
				if (_springOffEnemy != -1)
				{
					if (_ce.input.isDoing("jump", inputChannel))
						velocity.y = -enemySpringJumpHeight;
					else
						velocity.y = -enemySpringHeight;
					_springOffEnemy = -1;
				}*/
				
				//Cap velocities
				if(TinyWingsGameState.instance.isStart)
				{
					if (velocity.x > (maxVelocity))
						velocity.x = maxVelocity;
					else if (velocity.x < Config.HERO_MIN_V)
						velocity.x = Config.HERO_MIN_V;
					
					//update physics with new velocity
					_body.SetLinearVelocity(velocity);
				}
			}
			
//			updateAnimation();
		}
	}
}
