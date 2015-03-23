package com.miro.rt.obj 
{
	import com.miro.rt.event.GameEvent;
	
	import flash.geom.Point;
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	
	import citrus.core.CitrusEngine;
	import citrus.objects.platformer.box2d.Hills;

	
	public class Rainbow extends Hills
	{
		private var _initHillPlatform:Boolean;
		private var _amplitude:Number;
		private var _elevation:int;
		
		public function Rainbow(name:String, params:Object=null)
		{
			super(name, params);
		}
		
		override protected function _prepareSlices():void {
			
			if (view)
				(view as RainbowDrawer).init(sliceWidth, sliceHeight);
			
			super._prepareSlices();
		}
		
		override protected function _pushHill():void 
		{
			if (view)
			{
				(view as RainbowDrawer).createSlice(body, _nextYPoint * _box2D.scale, _currentYPoint * _box2D.scale);
			}
			
			super._pushHill();
			
			var ab2V2:b2Vec2 = body.GetPosition();
			dispatchHillChange(GameEvent.CREATE_HILL_CLIP, new Point(ab2V2.x * _box2D.scale, _currentYPoint * _box2D.scale));
		}
		
		override protected function _deleteHill(index:uint):void {
			
			if(view)
			{
				(view as RainbowDrawer).deleteHill(index);
			}
			
			var db2V2:b2Vec2 = (_slices[index] as b2Body).GetPosition();
			dispatchHillChange(GameEvent.DELETE_HILL_CLIP, new Point(db2V2.x * _box2D.scale, db2V2.y * _box2D.scale));
			
			super._deleteHill(index);
		}
		
		private function dispatchHillChange(type:String, pos:Point):void
		{
			var eDate:Object = new Object();
			var event:GameEvent =new GameEvent(type, eDate);
			
			eDate.elevation = _elevation;
			eDate.pos = pos;
			
			CitrusEngine.getInstance().dispatchEvent(event);
		}
		
		override protected function _createSlice():void {
			// Every time a new hill has to be created this algorithm predicts where the slices will be positioned
			if (_indexSliceInCurrentHill >= _slicesInCurrentHill) {
				if(roundFactor == 0) ++roundFactor;			
				
				_amplitude = 0;
				
				var hillWidth:Number = sliceWidth * roundFactor + Math.ceil(Math.random() * (roundFactor / 2) + roundFactor / 2) * sliceWidth;
				
				_slicesInCurrentHill = hillWidth / sliceWidth;
				if(_slicesInCurrentHill % 2 != 0) ++_slicesInCurrentHill;
				
				_indexSliceInCurrentHill = 0;
				
				if (_realWidth > 0)
				{
					while (true)
					{
						_amplitude =  Math.random() * hillWidth / 7.5;
						if(Math.abs(_realHeight  + _amplitude) <= 550 && _amplitude > 50)
						{
							break;
						}
					}
					
				} else {
					_amplitude = 0;
				}
				
				_realWidth += hillWidth;
				
				_elevation = RainbowElevation.DOWNHILL;
			}
			
			
			if (_indexSliceInCurrentHill == _slicesInCurrentHill / 2)
			{
				_elevation = RainbowElevation.UPHILL;
			}
			
			// Calculate the position slice
			_currentYPoint = _sliceVectorConstructor[0].y = (_amplitude - _amplitude *  Math.cos(2 * Math.PI / _slicesInCurrentHill * _indexSliceInCurrentHill)) / _box2D.scale;
			_nextYPoint =_sliceVectorConstructor[1].y = (_amplitude - _amplitude *  Math.cos(2 * Math.PI / _slicesInCurrentHill * (_indexSliceInCurrentHill+1))) / _box2D.scale;
			
			var slicePolygon:b2PolygonShape = new b2PolygonShape();
			slicePolygon.SetAsVector(_sliceVectorConstructor, 2);
			
			_bodyDef = new b2BodyDef();
			_bodyDef.position.Set(_slicesCreated * sliceWidth/_box2D.scale, 0);
			
			var sliceFixture:b2FixtureDef = new b2FixtureDef();
			sliceFixture.shape = slicePolygon;
			
			_body = _box2D.world.CreateBody(_bodyDef);
			_body.SetUserData(this);
			_body.CreateFixture(sliceFixture);
			_pushHill();
		}
	}
}