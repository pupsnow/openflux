package com.openflux.controllers
{
	import com.openflux.core.IFluxComponent;
	import com.openflux.core.IFluxController;

	[DefaultProperty("controllers")]
	
	/**
	 * Adds ability to attach multiple controllers to a components
	 */
	public class ComplexController implements IFluxController
	{
		/**
		 * Constructor
		 * 
		 * @param controllers Optional Array of IFluxController objects
		 */
		public function ComplexController(controllers:Array=null)
		{
			super();
			_controllers = controllers;
		}
		
		// ========================================
		// controllers property
		// ========================================
		
		private var _controllers:Array;
		
		[ArrayElementType("com.openflux.core.IFluxController")]
		
		/**
		 * Array of IFluxController objects
		 */
		public function get controllers():Array { return _controllers; }
		public function set controllers(value:Array):void {
			_controllers = value;
		}

		// ========================================
		// component property (IFluxController implementation)
		// ========================================
		
		private var _component:IFluxComponent;
		
		/**
		 * IFluxComponent to attach controllers to
		 */
		public function get component():IFluxComponent { return _component; }
		public function set component(value:IFluxComponent):void {
			_component = value;
			for each(var c:IFluxController in _controllers) {
				c.component = value;
			}
		}
		
	}
}