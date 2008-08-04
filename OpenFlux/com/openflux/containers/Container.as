package com.openflux.containers
{
	import com.openflux.ListItem;
	import com.openflux.animators.IAnimator;
	import com.openflux.animators.TweenAnimator;
	import com.openflux.core.FluxFactory;
	import com.openflux.core.FluxView;
	import com.openflux.core.IFluxFactory;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxListItem;
	import com.openflux.layouts.ContraintLayout;
	import com.openflux.layouts.ILayout;
	import com.openflux.utils.CollectionUtil;
	import com.openflux.utils.MetaStyler;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ICollectionView;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.styles.IStyleClient;
	
	use namespace mx_internal;
	
	[DefaultProperty("content")]
	public class Container extends FluxView implements IDataView, IFluxContainer
	{	
		//*********************************
		// Constructor
		//*********************************
		
		public function Container()
		{
			super();
		}
		
		//************************************
		// IDataView implementation
		//************************************

		private var _renderers:Array = [];
		private var _content:*;
		private var _factory:Object;

		private var collection:ICollectionView;
		private var contentChanged:Boolean = false;

		/**
		 * Holds data (like dataProvider) or UIComponents
		 */
		[Bindable]
		public function get content():* { return _content; }
		public function set content(value:*):void {
			if(collection) {
				collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, contentChangeHandler);
				collection = null;
			}
			
			_content = value;
			collection = CollectionUtil.resolveCollection(value);
			
			if(collection) {
				collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, contentChangeHandler);
			}
			
			contentChanged = true;
			invalidateProperties();
		}
		
		/**
		 * Item renderer
		 */
		public function get factory():Object { return _factory; }
		public function set factory(value:Object):void {
			_factory = value;
			contentChanged = true;
			invalidateProperties();
		}
		
		
		//************************************
		// IFluxContainer Implementation
		//************************************
		
		private var _animator:IAnimator;
		private var _layout:ILayout;
		
		[StyleBinding] [Bindable]
		public function get animator():IAnimator { return _animator; }
		public function set animator(value:IAnimator):void {
			if(_animator) { _animator.detach(this); }
			_animator = value;
			if(_animator) { _animator.attach(this); }
		}
		
		[StyleBinding] [Bindable]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			if(_layout) {
				_layout.detach(this);
			}
			_layout = value;
			if(_layout) {
				_layout.attach(this);
				MetaStyler.initialize(_layout, this.data as IStyleClient);
			}
			if(_animator) {
				MetaStyler.initialize(_animator, this.data as IStyleClient);
			}
			invalidateDisplayList();
		}
		
		public function get children():Array {
			var arr:Array = [];
			var count:int = numChildren;
			for (var i:int = 0; i < count; i++) {
				var child:IUIComponent = getChildAt(i) as IUIComponent;
				if (child && child.includeInLayout)
					arr.push(child);
			}
			return arr;
		}
		
		/*
		public function get dragTargetIndex():int { return _dragTargetIndex; }
		public function set dragTargetIndex(value:int):void {
			if (_dragTargetIndex != value) {
				_dragTargetIndex = value;
				invalidateLayout();
			}
		}*/
		
		//***********************************************
		// Framework Overrides
		//***********************************************
		
		/** @private */
		override protected function createChildren():void {
			super.createChildren();
			if (animator == null) {
				animator = new TweenAnimator();
			}
			if (layout == null) {
				layout = new ContraintLayout();
			}
			if(factory == null) {
				factory = new ListItem();
			}
		}
		
		/** @private */
		override protected function commitProperties():void {
			super.commitProperties();
			
			if(contentChanged) {
				contentReset();
				contentChanged = false;
			}
		}
		
		/** @private */
		override protected function measure():void {
			super.measure();
			if (layout) {
				var point:Point = layout.measure(children); // filter out !includeInLayout
				measuredWidth = point.x;
				measuredHeight = point.y;
			}
		}
		
		/** @private */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.clear(); // draw over dead space so drag/mouse operations register
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
			
			updateLayout();
		}
		
		/** @private */
		override public function stylesInitialized():void {
			super.stylesInitialized();
			if(layout) { MetaStyler.initialize(layout, this.data as IStyleClient); }
			if(animator) { MetaStyler.initialize(animator, this.data as IStyleClient); }
		}
		
		/** @private */
		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);
			if(layout) { MetaStyler.updateStyle(styleProp, layout, this.data as IStyleClient); }
			if(animator) { MetaStyler.updateStyle(styleProp, animator, this.data as IStyleClient); }
		}
		
		//*****************************************
		// Private Functions
		//*****************************************
		
		private function updateLayout():void {
			if(layout && animator) {
				var rectangle:Rectangle = new Rectangle(0, 0, width, height);
				layout.update(children, rectangle);
			}
		}
		
		protected function contentReset():void {
			for each(var o:DisplayObject in _renderers) {
				removeChild(o);
			}
			_renderers = [];
			for each(var item:Object in _content) {
				addItem(item);
			}
			invalidateDisplayList();
		}
		
		protected function addItem(item:Object, index:int=-1):void {
			var instance:UIComponent;
			var factory:IFluxFactory = new FluxFactory(this.factory as IFactory); // testing CSS Data declarations
			if(item is UIComponent) {
				instance = item as UIComponent;
			} else if(factory is IFluxFactory) {
				instance = factory.createComponent(item) as UIComponent;
				
				if(instance is IDataRenderer) {
					(instance as IDataRenderer).data = item;
				}
			}
			
			instance.styleName = this; // ???

			if(instance is IFluxListItem) {
				(instance as IFluxListItem).list = component as IFluxList;
			}
			
			if (index != -1) {
				_renderers.splice(index, 0, instance);
				addChildAt(instance, index);
			} else {
				_renderers.push(instance);
				addChild(instance);
			}
			
			animator.addItem(instance);
			invalidateDisplayList();
		}
		
		protected function removeItem(item:Object, index:int = -1):void {
			var child:DisplayObject = _renderers.splice(index, 1)[0];
			animator.removeItem(child, cleanChild);
			invalidateDisplayList();
		}
		
		private function cleanChild(child:DisplayObject):void {
			removeChild(child);
			invalidateDisplayList();
		}
		
		//******************************************
		// Event Listeners
		//******************************************
		
		private function contentChangeHandler(event:CollectionEvent):void {
			switch(event.kind) {
				case CollectionEventKind.ADD:
					addItem(collection[event.location], event.location);
					break;
				case CollectionEventKind.REMOVE:
					removeItem(collection[event.location], event.location);
					break;
				case CollectionEventKind.RESET:
					contentChanged = true;
					invalidateProperties();
					break;
			}
		}
	}
}