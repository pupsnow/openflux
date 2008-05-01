package com.openflux.core
{
	import com.openflux.utils.MetaStyler;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.states.State;
	
	// Here's the biggest hurtle we have so far. Everything's a Canvas, that's no good :-)
	// I'll be looking at taking this out after beta release.
	public class FluxView extends Canvas implements IFluxView
	{
		
		private var _state:String;
		public function get state():String { return _state; }
		public function set state(value:String):void {
			_state = value;
			for each(var state:State in states) {
				if(state.name == value) {
					super.currentState = value;
				}
			}
		}
		
		//************************************
		// Constructor
		//************************************
		
		public function FluxView()
		{
			super();
			clipContent = false;
			MetaStyler.initialize(this);
		}
		
		//************************************
		// Public Properties
		//************************************
		
		/*
		[Bindable]
		public function get data():Object { return _data; }
		public function set data(value:Object):void {
			_data = value;
			dataChanged = true;
			// data templates
		}*/
		/*
		override public function set currentState(value:String):void {
			for each(var state:State in states) {
				if(state.name == value) {
					super.currentState = value;
				}
			}
		}
		*/
		
		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);
			MetaStyler.updateStyle(styleProp, this);
		}
		
		
		//**********************************************
		// Private Content Utility Methods
		//**********************************************
		/*
		private function addContentFromArray(value:Array):void {
			for each(var o:Object in value) {
				if(o is UIComponent) {
					addContentFromUIComponent(o as UIComponent);
				} else {
					addContentFromData(o);
				}
			} 
		}
		
		private function addContentFromUIComponent(value:UIComponent):void {
			addChild(value);
		}
		
		private function addContentFromData(value:Object):void {
			
		}
		*/
	}
}