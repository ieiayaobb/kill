package  com.caller.call
{
	
	import com.caller.ICall.ICallBack;
	
	import flash.utils.Dictionary;
	
	public class CallBack implements ICallBack
	/**
	 *这个类的功能跟EventDispatcher是完全一样的，但是实现原理不同， EventDispatcher的原理是事件机制
	 * 此类的原理是回调机制，通常回调的性能会比事件机制要高
	 * 使用addCallBack后，如不需要再监听就要使用removeCallback移除掉
	 * 被回调的方法必须有一个类型为object的参数，否则报错
	 */
	{
		public function CallBack()
		{
			funcDic = new Dictionary();
		}
		
		private var funcDic:Dictionary;
		//类型是全局共享记录的
		private static var allType:Vector.<String>;
		private static var funcCount:int = 0;
		private static var counter:Dictionary = new Dictionary();
		/**
		 *增加回调方法 
		 * @param type 回调类型
		 * @param func 回调方法
		 * 
		 */		
		public function addCallback(type:String, func:Function):void
		{
			if(!funcDic[type]){
				funcDic[type] = new Vector.<Function>();
			}
			if(!allType){
				allType = new Vector.<String>;
			}
			
			if(!counter[type]){
				counter[type] = new Object();
				counter[type].num = 0;
				allType.push(type);
			}
			counter[type].num += 1;		
			funcCount += 1;
			funcDic[type].push(func);
		}

		/**
		 *移除回调方法 
		 * @param type 回调类型
		 * @param func 回调方法
		 * 
		 */		
		public function removeCallback(type:String, func:Function):void
		{
			if(funcDic[type]){
				var idx:int;
				idx = (funcDic[type] as Vector.<Function>).indexOf(func);
				//如果在数组里能找到相应的方法，就把它从数组中删除
				if(idx >= 0){
					(funcDic[type] as Vector.<Function>).splice(idx,1);
					funcCount -= 1;
				}
				//如果相应类型的回调已经删除干净，把相应的键也删了
				if(funcDic[type].length == 0){
					delete funcDic[type];
				}
				
				//如果相应的类型数量还大于0的，就把相应的数量减掉1
					if(counter[type].num > 0){
						counter[type].num -= 1;
				//如果相应类型的数量已经等于0的，就删除那个类型的计数
					if(counter[type].num == 0){
						delete counter[type];
						idx = allType.indexOf(type);
						if(idx >= 0){
							allType.splice(idx,1);
						}
					}
				}
					
			}
		}
		/**
		 *得到所有已经被注册的回调类型 
		 * @return 
		 * 
		 */		
		public static function getTypes():Vector.<String>{
			return allType;
		}
		/**
		 *得到所有已经被注册的回调方法数量 
		 * @return 
		 * 
		 */		
		public static function getFunctionCount():int{
			return funcCount;
		}
		
		/**
		 *得到注册的回调明细信息 
		 */		
		public static function getDetail():void{
			if(allType){
				for each(var obj:String in allType){
					trace(obj+":"+counter[obj].num);
				}
				if(allType.length == 0){
					trace("啥都没");
				}
			}else{
				trace("啥都没");
			}
		}
		
		/**
		 *发出事件 
		 * @param type 回调类型
		 * @param data 事件携带的数据
		 * 
		 */		
		private var tempV:Vector.<Function>;
		public function dispatch(type:String, data:Object=null):void
		{
			if(funcDic[type]){
				for each(var func:Function in funcDic[type]){
					func(data);
				}
			}
			getDetail();
		}
	}
}