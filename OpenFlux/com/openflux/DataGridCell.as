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

package com.openflux
{
	import com.openflux.controllers.ComplexController;
	import com.openflux.core.FluxComponent;
	import com.openflux.views.DataGridCellView;
	
	import flash.events.Event;
	
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	
	/**
	 * Data Grid Cell Component
	 */
	public class DataGridCell extends FluxComponent implements IDataRenderer, IFactory
	{
		/**
		 * Constructor
		 */
		public function DataGridCell()
		{
			super();
		}
		
		// ========================================
		// data property
		// ========================================
		
		private var _data:Object;
		
		[Bindable("dataChange")]
		
		/**
		 * Data object for the current cell.
		 * 
		 * @see com.openflux.core.FluxFactory
		 */
		public function get data():Object { return _data; }
		public function set data(value:Object):void {
			if (_data != value) {
				_data = value;
				dispatchEvent(new Event("dataChange"));
			}
		}
		
		// ========================================
		// framework overrides
		// ========================================
		
		override protected function createChildren():void {
			if (!view) {
				view = new DataGridCellView();
			}
			
			if (!controller) {
				controller = new ComplexController();
			}
			
			super.createChildren();
		}
		
	} // End class
} // End package