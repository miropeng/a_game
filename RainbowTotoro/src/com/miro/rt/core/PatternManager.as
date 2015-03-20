package com.miro.rt.core
{
	import com.miro.rt.obj.Item;
	import com.miro.rt.obj.Obstacle;
	import com.miro.rt.pool.PoolItem;
	import com.miro.rt.pool.PoolObstacle;
	
	import flash.geom.Rectangle;
	
	import citrus.core.starling.StarlingState;
	
	import starling.extensions.particles.Particle;

	public class PatternManager
	{
		/** Obstacle frequency. */
		public static const OBSTACLE_GAP:Number = 1200;
		/** Obstacle speed. */		
		public static const OBSTACLE_SPEED:Number = 300;
		
		private static var _instance:PatternManager;
		
		/** Game interaction area. */		
		private var gameArea:Rectangle;
		
		/** Items pool with a maximum cap for reuse of items. */		
		private var itemsPool:PoolItem;
		
		/** Obstacle count - to track the frequency of obstacles. */
		private var obstacleGapCount:Number = 0;
		
		/** Obstacles pool with a maximum cap for reuse of items. */		
		private var obstaclesPool:PoolObstacle;
		
		// ------------------------------------------------------------------------------------------------------------
		// ITEM GENERATION
		// ------------------------------------------------------------------------------------------------------------
		
		/** Current pattern of food items - 0 = horizontal, 1 = vertical, 2 = zigzag, 3 = random, 4 = special item. */
		private var pattern:int;
		
		/** Current y position of the item in the pattern. */
		private var patternPosY:int;
		
		/** How far away are the patterns created vertically. */
		private var patternStep:int;
		
		/** Direction of the pattern creation - used only for zigzag. */
		private var patternDirection:int;
		
		/** Gap between each item in the pattern horizontally. */
		private var patternGap:Number;
		
		/** Pattern gap counter. */
		private var patternGapCount:Number;
		
		/** How far should the player fly before the pattern changes. */
		private var patternChange:Number;
		
		/** How long are patterns created verticaly? */
		private var patternLength:Number;
		
		/** A trigger used if we want to run a one-time command in a pattern. */
		private var patternOnce:Boolean;
		
		/** Y position for the entire pattern - Used for vertical pattern only. */
		private var patternPosYstart:Number;
		
		// ------------------------------------------------------------------------------------------------------------
		// ANIMATION
		// ------------------------------------------------------------------------------------------------------------
		
		/** Items to animate. */
		private var itemsToAnimate:Vector.<Item>;
		
		/** Total number of items. */
		private var itemsToAnimateLength:uint = 0;
		
		/** Obstacles to animate. */
		private var obstaclesToAnimate:Vector.<Obstacle>;
		
		/** Obstacles to animate - array length. */		
		private var obstaclesToAnimateLength:uint = 0;
		
		/** Wind particles to animate. */
		private var windParticlesToAnimate:Vector.<Particle>;
		
		/** Wind particles to animate - array length. */		
		private var windParticlesToAnimateLength:uint = 0;
		
		/** Eat particles to animate. */
		private var eatParticlesToAnimate:Vector.<Particle>;
		
		/** Eat particles to animate - array length. */		
		private var eatParticlesToAnimateLength:uint = 0;
		
		private var _gameState:StarlingState;
		
		public function PatternManager()
		{
			
		}
		
		public static function get instance():PatternManager
		{
			return _instance ||= new PatternManager();
		}
		
		
		public function initialize(state:StarlingState):void
		{
			
			_gameState = state;
			
			// Define game area.
			gameArea = new Rectangle(0, 100, _gameState.stage.stageWidth, _gameState.stage.stageHeight - 250);
			
			// Reset item pattern styling.
			pattern = 1;
			patternPosY = gameArea.top;
			patternStep = 15;
			patternDirection = 1;
			patternGap = 20;
			patternGapCount = 0;
			patternChange = 100;
			patternLength = 50;
			patternOnce = true;
			
			
			// Initialize items-to-animate vector.
			itemsToAnimate = new Vector.<Item>();
			itemsToAnimateLength = 0;
			
			// Create items, add them to pool and place them outside the stage area.
			itemsPool = new PoolItem(foodItemCreate, foodItemClean);
			
			// Initialize obstacles-to-animate vector.
			obstaclesToAnimate = new Vector.<Obstacle>();
			obstaclesToAnimateLength = 0;
			
			// Create obstacles pool.
			obstaclesPool = new PoolObstacle(obstacleCreate, obstacleClean, 4, 10);
			
			// Initialize particles-to-animate vectors.
			eatParticlesToAnimate = new Vector.<Particle>();
			eatParticlesToAnimateLength = 0;
			windParticlesToAnimate = new Vector.<Particle>();
			windParticlesToAnimateLength = 0;
			
			// Create Eat Particle and Wind Particle pools and place them outside the stage area.
//			eatParticlesPool = new PoolParticle(eatParticleCreate, eatParticleClean, 20, 30);
//			windParticlesPool = new PoolParticle(windParticleCreate, windParticleClean, 10, 30);
			
		}
		
		/**
		 * Create food item objects and add to display list.
		 * Also called from the Pool class while creating minimum number of objects & run-time objects < maximum number.
		 * @return Food item that was created.
		 * 
		 */
		private function foodItemCreate():Item
		{
			var foodItem:Item = new Item("foodItem", {foodItemType:Math.ceil(Math.random() * 5)});
			foodItem.x = _gameState.stage.stageWidth + foodItem.view.width * 2;
			_gameState.add(foodItem);
			
			return foodItem;
		}
		
		/**
		 * Clean the food items before reusing from the pool. Called from the pool. 
		 * @param item
		 * 
		 */
		private function foodItemClean(item:Item):void
		{
			item.x = _gameState.stage.stageWidth + 100;
		}
		
		/**
		 * Create obstacle objects and add to display list.
		 * Also called from the Pool class while creating minimum number of objects & run-time objects < maximum number.
		 * @return Obstacle that was created.
		 * 
		 */
		private function obstacleCreate():Obstacle
		{
			var obstacle:Obstacle = new Obstacle("obstacle", {typeObstacle:Math.ceil(Math.random() * 4), distance:Math.random() * 1000 + 1000});
			obstacle.x = _gameState.stage.stageWidth + obstacle.width * 2;
			_gameState.add(obstacle);
			
			return obstacle;
		}
		
		/**
		 * Clean the obstacles before reusing from the pool. Called from the pool. 
		 * @param obstacle
		 * 
		 */
		private function obstacleClean(obstacle:Obstacle):void
		{
			obstacle.x = _gameState.stage.stageWidth + obstacle.width * 2;
		}
		
		
		/**
		 * Set food items pattern.  
		 * 
		 */
		public function setFoodItemsPattern():void
		{
			// If hero has not travelled the required distance, don't change the pattern.
			if (patternChange > 0)
			{
				patternChange -= 30;//playerSpeed * elapsed;
			}
			else
			{
				// If hero has travelled the required distance, change the pattern.
				if ( Math.random() < 0.7 )
				{
					// If random number is < normal item chance (0.7), decide on a random pattern for items.
					pattern = Math.ceil(Math.random() * 4); 
				}
				else
				{
					// If random number is > normal item chance (0.3), decide on a random special item.
					pattern = Math.ceil(Math.random() * 2) + 9;
				}
				
				if (pattern == 1)  
				{
					// Vertical Pattern
					patternStep = 15;
					patternChange = Math.random() * 500 + 500;
				}
				else if (pattern == 2)
				{
					// Horizontal Pattern
					patternOnce = true;
					patternStep = 40;
					patternChange = patternGap * Math.random() * 3 + 5;
				}
				else if (pattern == 3)
				{
					// ZigZag Pattern
					patternStep = Math.round(Math.random() * 2 + 2) * 10;
					if ( Math.random() > 0.5 )
					{
						patternDirection *= -1;
					}
					patternChange = Math.random() * 800 + 800;
				}
				else if (pattern == 4)
				{
					// Random Pattern
					patternStep = Math.round(Math.random() * 3 + 2) * 50;
					patternChange = Math.random() * 400 + 400;
				}
				else  
				{
					patternChange = 0;
				}
			}
		}
		
		/**
		 * Create food pattern after hero travels for some distance.
		 * 
		 */
		public function createFoodItemsPattern():void
		{
			// Create a food item after we pass some distance (patternGap).
			if (patternGapCount < patternGap )
			{
				patternGapCount += 100;//playerSpeed * elapsed;
			}
			else if (pattern != 0)
			{
				// If there is a pattern already set.
				patternGapCount = 0;
				
				// Reuse and configure food item.
				reuseAndConfigureFoodItem();
			}
		}
		
		/**
		 * Create a food item - called by createPattern() 
		 * 
		 */
		private function reuseAndConfigureFoodItem():void
		{
			var itemToTrack:Item;
			
			switch (pattern)
			{
				case 1:
					// Horizonatl, creates a single food item, and changes the position of the pattern randomly.
					if (Math.random() > 0.9)
					{
						// Set a new random position for the item, making sure it's not too close to the edges of the screen.
						patternPosY = Math.floor(Math.random() * (gameArea.bottom - gameArea.top + 1)) + gameArea.top;
					}
					
					// Checkout item from pool and set the type of item.
					itemToTrack = itemsPool.checkOut();
					itemToTrack.foodItemType = Math.ceil(Math.random() * 5);
					
					// Reset position of item.
					itemToTrack.x = _gameState.stage.stageWidth + itemToTrack.width;
					itemToTrack.y = patternPosY;
					
					// Mark the item for animation.
					itemsToAnimate[itemsToAnimateLength++] = itemToTrack;
					break;
				
				case 2:
					// Vertical, creates a line of food items that could be the height of the entire screen or just a small part of it.
					if (patternOnce == true)
					{
						patternOnce = false;
						
						// Set a random position not further than half the screen.
						patternPosY = Math.floor(Math.random() * (gameArea.bottom - gameArea.top + 1)) + gameArea.top;
						
						// Set a random length not shorter than 0.4 of the screen, and not longer than 0.8 of the screen.
						patternLength = (Math.random() * 0.4 + 0.4) * _gameState.stage.stageHeight;
					}
					
					// Set the start position of the food items pattern.
					patternPosYstart = patternPosY; 
					
					// Create a line based on the height of patternLength, but not exceeding the height of the screen.
					while (patternPosYstart + patternStep < patternPosY + patternLength && patternPosYstart + patternStep < _gameState.stage.stageHeight * 0.8)
					{
						// Checkout item from pool and set the type of item.
						itemToTrack = itemsPool.checkOut();
						itemToTrack.foodItemType = Math.ceil(Math.random() * 5);
						
						// Reset position of item.
						itemToTrack.x = _gameState.stage.stageWidth + itemToTrack.width;
						itemToTrack.y = patternPosYstart;
						
						// Mark the item for animation.
						itemsToAnimate[itemsToAnimateLength++] = itemToTrack;
						
						// Increase the position of the next item based on patternStep.
						patternPosYstart += patternStep;
					}
					break;
				
				case 3:
					// ZigZag, creates a single item at a position, and then moves bottom
					// until it hits the edge of the screen, then changes its direction and creates items
					// until it hits the upper edge.
					
					// Switch the direction of the food items pattern if we hit the edge.
					if (patternDirection == 1 && patternPosY > gameArea.bottom - 50)
					{
						patternDirection = -1;
					}
					else if ( patternDirection == -1 && patternPosY < gameArea.top )
					{
						patternDirection = 1;
					}
					
					if (patternPosY >= gameArea.top && patternPosY <= gameArea.bottom)
					{
						// Checkout item from pool and set the type of item.
						itemToTrack = itemsPool.checkOut();
						itemToTrack.foodItemType = Math.ceil(Math.random() * 5);
						
						// Reset position of item.
						itemToTrack.x = _gameState.stage.stageWidth + itemToTrack.width;
						itemToTrack.y = patternPosY;
						
						// Mark the item for animation.
						itemsToAnimate[itemsToAnimateLength++] = itemToTrack;
						
						// Increase the position of the next item based on patternStep and patternDirection.
						patternPosY += patternStep * patternDirection;
					}
					else
					{
						patternPosY = gameArea.top;
					}
					
					break;
				
				case 4:
					// Random, creates a random number of items along the screen.
					if (Math.random() > 0.3)
					{
						// Choose a random starting position along the screen.
						patternPosY = Math.floor(Math.random() * (gameArea.bottom - gameArea.top + 1)) + gameArea.top;
						
						// Place some items on the screen, but don't go past the screen edge
						while (patternPosY + patternStep < gameArea.bottom)
						{
							// Checkout item from pool and set the type of item.
							itemToTrack = itemsPool.checkOut();
							itemToTrack.foodItemType = Math.ceil(Math.random() * 5);
							
							// Reset position of item.
							itemToTrack.x = _gameState.stage.stageWidth + itemToTrack.width;
							itemToTrack.y = patternPosY;
							
							// Mark the item for animation.
							itemsToAnimate[itemsToAnimateLength++] = itemToTrack;
							
							// Increase the position of the next item by a random value.
							patternPosY += Math.round(Math.random() * 100 + 100);
						}
					}
					break;
				
				case 10:
					// Coffee, this item gives you extra speed for a while, and lets you break through obstacles.
					
					// Set a new random position for the item, making sure it's not too close to the edges of the screen.
					patternPosY = Math.floor(Math.random() * (gameArea.bottom - gameArea.top + 1)) + gameArea.top;
					
					// Checkout item from pool and set the type of item.
					itemToTrack = itemsPool.checkOut();
					itemToTrack.foodItemType = Math.ceil(Math.random() * 2) + 5;
					
					// Reset position of item.
					itemToTrack.x = _gameState.stage.stageWidth + itemToTrack.width;
					itemToTrack.y = patternPosY;
					
					// Mark the item for animation.
					itemsToAnimate[itemsToAnimateLength++] = itemToTrack;
					break;
				
				case 11:
					// Mushroom, this item makes all the food items fly towards the hero for a while.
					
					// Set a new random position for the food item, making sure it's not too close to the edges of the screen.
					patternPosY = Math.floor(Math.random() * (gameArea.bottom - gameArea.top + 1)) + gameArea.top;
					
					// Checkout item from pool and set the type of item.
					itemToTrack = itemsPool.checkOut();
					itemToTrack.foodItemType = Math.ceil(Math.random() * 2) + 5;
					
					// Reset position of item.
					itemToTrack.x = _gameState.stage.stageWidth + itemToTrack.width;
					itemToTrack.y = patternPosY;
					
					// Mark the item for animation.
					itemsToAnimate[itemsToAnimateLength++] = itemToTrack;
					
					break;
			}
		}
		
		/**
		 * Create an obstacle after hero has travelled a certain distance.
		 * 
		 */
		public function initObstacle():void
		{
			// Create an obstacle after hero travels some distance (obstacleGap).
			if (obstacleGapCount < OBSTACLE_GAP)
			{
				obstacleGapCount += 30;//playerSpeed * elapsed;
			}
			else if (obstacleGapCount != 0)
			{
				obstacleGapCount = 0;
				
				// Create any one of the obstacles.
				createObstacle(Math.ceil(Math.random() * 4), Math.random() * 1000 + 1000);
			}
		}
		
		/**
		 * Create the obstacle object based on the type indicated and make it appear based on the distance passed. 
		 * @param _type
		 * @param _distance
		 * 
		 */
		private function createObstacle(_type:int = 1, _distance:Number = 0):void
		{
			// Create a new obstacle.
			var obstacle:Obstacle = obstaclesPool.checkOut();
			obstacle.typeObstacle = _type;
			obstacle.distance = _distance;
			obstacle.x = _gameState.stage.stageWidth;
			
			// For only one of the obstacles, make it appear in either the top or bottom of the screen.
			if (_type <= Obstacle.OBSTACLE_TYPE_3)
			{
				// Place it on the top of the screen.
				if (Math.random() > 0.5)
				{
					obstacle.y = gameArea.top;
					obstacle.position = "top";
				}
				else
				{
					// Or place it in the bottom of the screen.
					obstacle.y = gameArea.bottom - obstacle.height;
					obstacle.position = "bottom";
				}
			}
			else
			{
				// Otherwise, if it's any other obstacle type, put it somewhere in the middle of the screen.
				obstacle.y = Math.floor(Math.random() * (gameArea.bottom-obstacle.height - gameArea.top + 1)) + gameArea.top;
				obstacle.position = "middle";
			}
			
			// Set the obstacle's speed.
			obstacle.speed = OBSTACLE_SPEED;
			
			// Set look out mode to true, during which, a look out text appears.
			obstacle.lookOut = true;
			
			// Animate the obstacle.
			obstaclesToAnimate[obstaclesToAnimateLength++] = obstacle;
		}
	}
}