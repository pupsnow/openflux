// =================================================================
//
// Copyright (c) 2009 The OpenFlux Team http://www.openflux.org
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// =================================================================

package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxView;
	import com.openflux.utils.ListUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IUIComponent;
	
	/**
	 * 3D Carousel layout. Front item is always the currently selected item
	 */
	public class CarouselLayout extends LayoutBase implements ILayout
	{
		/**
		 * Constructor
		 */
		public function CarouselLayout() {
			super();
			updateOnChange = true;
		}
		
		// ========================================
		// ILayout implementation
		// ========================================
		
		public function measure(children:Array):Point {
			// TODO: Figure out a min measured width/height
			return new Point(100, 100);
		}
		
		public function update(children:Array, rectangle:Rectangle):void {
			var numOfItems:int = children.length;			
			var list:IFluxList = (container as IFluxView).component as IFluxList;
			var selectedIndex:int = list ? Math.max(0, ListUtil.selectedIndex(list)) : 0;
			var radius:Number = rectangle.width - 10;
			var anglePer:Number = (Math.PI * 2) / numOfItems;

			var child:IUIComponent;
			var token:AnimationToken;
			
			animator.begin();

			for(var i:uint=0; i<numOfItems; i++) {
				child = children[i];
				token = new AnimationToken(child.getExplicitOrMeasuredWidth(), child.getExplicitOrMeasuredHeight());
				token.x = Math.sin((i-selectedIndex) * anglePer) * radius;
				token.z = -(Math.cos((i-selectedIndex) * anglePer) * radius) + radius;
				token.rotationY = (-(i-selectedIndex) * anglePer) * (180 / Math.PI);
				
				token.x = token.x + rectangle.width/2 - token.width/2;
				token.y = (token.y * -1) + rectangle.height / 2 - token.height / 2;
				animator.moveItem(child as DisplayObject, token);
			}
			
			animator.end();
		}

	}
}