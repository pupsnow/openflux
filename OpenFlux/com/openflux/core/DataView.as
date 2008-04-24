package com.openflux.core
{
	import com.openflux.ListItem;
	import com.openflux.events.DataViewEvent;
	import com.openflux.layouts.ILayout;
	import com.openflux.layouts.VerticalLayout;
	import com.openflux.utils.CollectionUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import mx.collections.ICollectionView;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.ResizeEvent;
	
	[Event(name="dataViewChanged", type="com.openflux.events.DataViewEvent")]
	public class DataView extends FluxView implements IDataView
	{
		private var _collection:ICollectionView;
		
		private var _content:Object;
		private var _itemRenderer:IFactory;
		private var _layout:ILayout;
		private var _renderers:Array = [];
		private var _dragTargetIndex:int = -1;
		
		private var collectionChanged:Boolean;
		
		
		//*********************************
		// Constructor
		//*********************************
		
		public function DataView()
		{
			super();
		}
		
		
		//************************************
		// Public Properties
		//************************************
		
		[Bindable] // holds data (like dataProvider)
		public function get content():Object { return _content; }
		public function set content(value:Object):void {
			_content = value;
			if(collection) {
				collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
			collection = CollectionUtil.resolveCollection(value);
			if(collection) {
				collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
			collectionChanged = true;
			invalidateProperties();
			invalidateLayout();
		}
		
		public function get collection():ICollectionView { return _collection; }
		public function set collection(value:ICollectionView):void {
			_collection = value;
		}
		
		public function get itemRenderer():IFactory { return _itemRenderer; }
		public function set itemRenderer(value:IFactory):void {
			_itemRenderer = value;
		}
		
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			if(_layout) {
				_layout.detach(this);
			}
			_layout = value;
			if(_layout) {
				_layout.attach(this);
			}
			invalidateLayout();
		}
		
		public function get renderers():Array { return _renderers; }
		
		
		public function get dragTargetIndex():int { return _dragTargetIndex; }
		public function set dragTargetIndex(value:int):void {
			if (_dragTargetIndex != value) {
				_dragTargetIndex = value;
				invalidateLayout();
			}
		}
		//public function get horizontalScrollPosition():Number { return 0; }
		//public function get verticalScrollPosition():Number { return 0; }
		
		
		//***********************************************
		// Framework Overrides
		//***********************************************
		
		override protected function createChildren():void {
			super.createChildren();
			if(itemRenderer == null) {
				itemRenderer = new ListItem();
			}
			if(layout == null) {
				layout = new VerticalLayout();
			}
			
			this.addEventListener(ResizeEvent.RESIZE, resizeHandler);
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			if(collectionChanged) {
				collectionReset();
				collectionChanged = false;
				dispatchEvent(new DataViewEvent(DataViewEvent.DATA_VIEW_CHANGED));
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_layout && layoutChanged) {
				layoutChanged = false;
				_layout.generateLayout();
			}
		}
		
		override protected function measure():void {
			super.measure();
			var point:Point = layout.getMeasuredSize();
			measuredWidth = point.x;
			measuredHeight = point.y;
		}
		
		private var layoutChanged:Boolean = false;
		public function invalidateLayout():void {
			layoutChanged = true;
			invalidateSize();
			invalidateDisplayList();
		}
		
		//*****************************************
		// Private Functions
		//*****************************************
		
		private function collectionReset():void {
			for each(var o:DisplayObject in _renderers) {
				removeChild(o);
			}
			_renderers = [];
			for each(var item:Object in collection) {
				var renderer:UIComponent = itemRenderer.newInstance() as UIComponent;
				renderer.styleName = this; // ???
				(renderer as IDataRenderer).data = item;
				(renderer as IFluxListItem).list = data as IFluxList;
				_renderers.push(renderer);
				addChild(renderer);
			}
			
			this.invalidateLayout();
		}
		
		//******************************************
		// Event Listeners
		//******************************************
		
		private function collectionChangeHandler(event:CollectionEvent):void {
			switch(event.kind) {
				case CollectionEventKind.ADD:
					var renderer:UIComponent = itemRenderer.newInstance() as UIComponent;
					renderer.styleName = this; // ???
					(renderer as IDataRenderer).data = collection[event.location];
					(renderer as IFluxListItem).list = data as IFluxList;
					_renderers.splice(event.location, 0, renderer);
					addChildAt(renderer, event.location);
					this.invalidateLayout();
					break;
				case CollectionEventKind.REMOVE:
					removeChildAt(event.location);
					renderers.splice(event.location, 1);					
					this.invalidateLayout();
					break;
				case CollectionEventKind.RESET:
					collectionReset();
					break;
			}
		}
		
		private function resizeHandler(event:ResizeEvent):void {
			invalidateLayout();
		}
	}
}