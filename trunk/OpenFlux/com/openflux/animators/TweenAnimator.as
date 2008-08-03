package com.openflux.animators
{
	import caurina.transitions.Tweener;
	
	import com.openflux.containers.IFluxContainer;
	
	import flash.display.DisplayObject;
	
	/**
	 * An animator class which uses the Tweener library. This is the default animator provided by OpenFlux. 
	 */
	public class TweenAnimator implements IAnimator
	{
		
		//private var count:int = 0;
		
		static public const TRANSITION_LINEAR:String = "linear";
		static public const EASE_OUT_EXPO:String = "easeOutExpo";
		static public const EASE_OUT_BOUNCE:String = "easeOutBounce";
		
		/**
		 * The duration of time used to animate a component.
		 */
		[StyleBinding] public var time:Number = 1;
		
		/**
		 * The transition path on which to animate a component.
		 */
		[StyleBinding] public var transition:String = EASE_OUT_EXPO;
		
		public function attach(container:IFluxContainer):void {}
		public function detach(container:IFluxContainer):void {}
		
		public function begin():void {} // unused
		public function end():void {} // unused
		
		public function moveItem(item:DisplayObject, token:AnimationToken):void {
			var parameters:Object = createTweenerParameters(token, 1);
			Tweener.addTween(item, parameters);
		}
		
		public function adjustItem(item:DisplayObject, token:AnimationToken):void {
			var parameters:Object = createTweenerParameters(token, 1/3);
			Tweener.addTween(item, parameters);
		}
		
		public function addItem(item:DisplayObject):void {
			item.alpha = 0;
			Tweener.addTween(item, {alpha:1, time:0.25});
		}
		
		public function removeItem(item:DisplayObject, callback:Function):void
		{
			var token:Object = new Object();
			token.time = 1/4;
			/*
			token.x = item.x + item.width/2;
			token.y = item.y + item.height/2;
			token.width = 100;
			token.height = 100;
			*/
			token.alpha = 0;
			token.onComplete = callback;
			token.onCompleteParams = [item];
			Tweener.addTween(item, token);
		}
		
		
		private function createTweenerParameters(token:AnimationToken, time:Number = 1):Object {
			var parameters:Object = new Object();
			parameters.time = time;
			parameters.transition = transition;
			
			parameters.x = token.x;
			parameters.y = token.y;
			parameters.width = token.width;
			parameters.height = token.height;
			parameters.rotation = token.rotationY;
			//object.onComplete = onComplete;
			return parameters;
		}
		
	}
}