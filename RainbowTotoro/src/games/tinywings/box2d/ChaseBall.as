package games.tinywings.box2d
{
	import Box2D.Common.Math.b2Vec2;
	
	import citrus.physics.box2d.Box2DShapeMaker;

	public class ChaseBall extends Ball
	{
		public function ChaseBall(name:String, params:Object=null)
		{
			super(name, params);
			
			_friction = 0.1;
		}
		
		override protected function createShape():void
		{
			_shape = Box2DShapeMaker.Circle(radius*2, radius*2);
			
		}
//		override protected function defineFixture():void
//		{
//			super.defineFixture();
//			_fixtureDef.density = 10;
//		}
		override public function update(timeDelta:Number):void
		{
			_timeDelta = timeDelta;
			
//			//Cap velocities
			if(TinyWingsGameState.instance.isStart && TinyWingsGameState.instance.chaseState)
			{
				var velocity:b2Vec2 = _body.GetLinearVelocity();
				if (velocity.x < Config.HERO_MIN_V + 1)
				{
					velocity.x = Config.HERO_MIN_V + 1;
				}
				
				//update physics with new velocity
				_body.SetLinearVelocity(velocity);
			}
		}
	}
}