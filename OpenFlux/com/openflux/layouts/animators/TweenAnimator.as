package com.openflux.layouts.animators
{
	import caurina.transitions.Tweener;
	
	import com.openflux.core.IDataView;
	
	
	public class TweenAnimator implements ILayoutAnimator
	{
		
		private var count:int = 0;
		
		static public const TRANSITION_LINEAR:String = "linear";
		static public const EASE_OUT_EXPO:String = "easeOutExpo";
		static public const EASE_OUT_BOUNCE:String = "easeOutBounce";
		
		[StyleBinding] public var time:Number = 0.500;
		[StyleBinding] public var transition:String = EASE_OUT_EXPO;
		
		public function attach(container:IDataView):void {}
		public function detach(container:IDataView):void {}
		
		public function begin():void {} // unused
		public function end():void {} // unused
		
		public function moveItem(item:Object, token:Object):void
		{
			token.time = time;
			token.transition = transition;
			token.onComplete = onComplete;
			Tweener.addTween(item, token);
			count++;
		}
		
		public function addItem(item:Object, token:Object):void
		{
			moveItem(item, token);
		}
		
		public function removeItem(item:Object):void
		{
			var token:Object = new Object();
			token.x = item.width/2;
			token.y = item.width/2;
			token.width = 0;
			token.height = 0;
			moveItem(item, token);
		}
		
		// review for interface
		public function isAnimating():Boolean {
			return count > 0 ? true : false;
		}
		
		private function onComplete():void {
			count--;
		}
		
	}
}