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
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IUIComponent;
	
	/**
	 * Vertical layout similar to VBox
	 */
	public class VerticalLayout extends LayoutBase implements ILayout, IDragLayout
	{
		/**
		 * Constructor
		 */
		public function VerticalLayout() {
			super();
		}
		
		// ========================================
		// gap property
		// ========================================
		
		private var _gap:Number = 0;
		
		[Bindable("gapProperty")]
		[StyleBinding]
		
		/**
		 * Gap between each item
		 */
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void {
			if (_gap != value) {
				_gap = value;
				dispatchEvent(new Event("gapChange"));
				
				if (container) {
					container.invalidateDisplayList();
				}
			}
		}
		
		// ========================================
		// ILayout implementation
		// ========================================
		
		public function measure(children:Array):Point {
			var point:Point = new Point(0, 0);
			for each(var child:IUIComponent in children) {
				point.x = Math.max(child.getExplicitOrMeasuredWidth(), point.x);
				point.y += child.getExplicitOrMeasuredHeight() + gap;
			}
			return point;
		}
		
		public function update(children:Array, rectangle:Rectangle):void {
			adjust(children, rectangle, []);
		}
		
		// ========================================
		// IDragLayout implementation
		// ========================================
		
		public function adjust(children:Array, rectangle:Rectangle, indices:Array):void {
			var position:Number = rectangle.y;
			var length:int = children.length;
			var s:int = 0;
			
			animator.begin();
			
			for (var i:int = 0; i < length; i++) {
				if(indices[s] == i) {
					position += 20 + gap;
				}
				var child:IUIComponent = children[i];
				var token:AnimationToken = new AnimationToken(rectangle.width, child.getExplicitOrMeasuredHeight(), 0, position);
				animator.moveItem(child as DisplayObject, token);
				position += token.height + gap;
			}
			
			animator.end();
		}
		
		public function findIndexAt(children:Array, x:Number, y:Number):int {
			var length:int = children.length;
			var closest:IUIComponent;
			var closestDistance:Number = Number.MAX_VALUE;
			
			// find the closest child
			for each(var child:IUIComponent in children) {
				var distance:Number = y - (child.y+child.getExplicitOrMeasuredHeight()/2);
				
				if (Math.abs(distance) < Math.abs(closestDistance)) {
					closest = child;
					closestDistance = distance;
				}
			}
			
			// set the index based on the closest child
			var index:int = children.indexOf(closest);
			
			if (closestDistance > 0) {
				index += 1;
			}
			
			return index;
		}
	}
}