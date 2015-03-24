/**
 *
 * Hungry Hero Game
 * http://www.hungryherogame.com
 * 
 * Copyright (c) 2012 Hemanth Sharma (www.hsharma.com). All rights reserved.
 * 
 * This ActionScript source code is free.
 * You can redistribute and/or modify it in accordance with the
 * terms of the accompanying Simplified BSD License Agreement.
 *  
 */

package com.miro.rt.obj
{

	import citrus.objects.CitrusSprite;
	
	/**
	 * This class represents the food items. 
	 * 
	 * @author hsharma
	 * 
	 */
	public class Item extends CitrusSprite
	{
		public var itemType:int;
		
		public function Item(name:String, params:Object = null)
		{
			super(name, params);
		}

	}
}