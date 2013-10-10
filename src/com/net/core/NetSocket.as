package com.net.core
{
	import com.netease.protobuf.Message;
    import com.net.util.CRC32;
    import com.net.util.MsgUtil;
    
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class NetSocket extends EventDispatcher
    {
		public var socket:Socket = null;
		
		private var socket_read_len:int;	//socket_read_len：可读的数据长度
		private var read_buffer_head:ByteArray;	//接收通信包头buffer,1个socket连接1个
		private var read_buffer_body:ByteArray;//接收有效载荷buffer,1个socket连接1个
		private var read_offset:int;		//接收buffer的当前接收位置，也是已收数据长度
		private var this_packet_total_len:uint;
		private var this_packet_option_byte1:uint;
		private var this_packet_option_byte2:uint;
		private var this_packet_crc32:uint;

        public function NetSocket(server:String,port:int)
        {
			read_buffer_head=MsgUtil.creatByteArray();
			read_buffer_body=MsgUtil.creatByteArray();
			socket=new Socket;
			socket.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			socket.addEventListener(Event.CLOSE, Net_Error);
			socket.addEventListener(Event.CONNECT,Net_Connect);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA,Net_Data);
			socket.connect(server,port);
            return;
        }// end function

		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			trace("Connection-ioErrorHandler");
			dispatchEvent(new NetEvent(NetEvent.ON_DISCONNECT));
		}		
		private function securityErrorHandler(evt:SecurityErrorEvent):void
		{
			trace("Connection-securityErrorHandler");
		}
		private function Net_Error(evt:Event):void
		{
			trace("Connection-Net_Error");
			dispatchEvent(new NetEvent(NetEvent.ON_DISCONNECT));
		}
		private function Net_Connect(evt:Event):void
		{
			trace('Connected');
			dispatchEvent(new NetEvent(NetEvent.ON_CONNECT));
		}
		
		
		//接收数据处理
		private function Net_Data(evt:ProgressEvent):void
		{
			try{
				socket_read_len=socket.bytesAvailable;
				
				while(true)
				{
					if(socket_read_len < 1)
					{
						break;
					}
					// 此次的接收到的长度
					var this_read_len:int = 0;
					if(read_offset < 16) //16: CommHead的长度
					{
						this_read_len = 16 - read_offset;
					}
					else
					{
						this_read_len = this_packet_total_len - read_offset;
					}
					
					if(this_read_len > socket_read_len)
					{
						this_read_len = socket_read_len;
					}
					
					if(read_offset < 16)
					{
						socket.readBytes(read_buffer_head, read_offset, this_read_len);
					}
					else
					{
						socket.readBytes(read_buffer_body, (read_offset - 16), this_read_len);
					}
					
					//	txt.text+=ByteCode.traceByte(read_buffer,'接收数据：')+'\n';
					
					read_offset += this_read_len;
					socket_read_len -= this_read_len;
					
					if(read_offset == 16)
					{
						//收全头了
						this_packet_total_len =  read_buffer_head.readUnsignedShort();//read_buffer_head.readUnsignedInt();
						this_packet_option_byte1 = read_buffer_head.readUnsignedByte();
						this_packet_option_byte2 = read_buffer_head.readUnsignedByte();
						this_packet_crc32 = read_buffer_head.readUnsignedInt();
					}
					
					if(read_offset == this_packet_total_len)
					{
						//收全整个包了
						//	var by:ByteArray=MsgUtil.creatByteArray();
						//	by.writeBytes(read_buffer,16,read_buffer.length-16);
						
						var crc:CRC32=new CRC32;
						//	crc.update(by);
						crc.update(read_buffer_body);
						var crcValue:uint=crc.getValue();
						if(crcValue== this_packet_crc32)	//crc32校验
						{
							//收到一个数据包，向上层送数据上去
							var funcStr:String=read_buffer_body.readUTF();
							var byte:ByteArray=MsgUtil.creatByteArray();
							
							read_buffer_body.readBytes(byte,0,read_buffer_body.bytesAvailable);
							byte.position=0;
							this.dispatchEvent(new NetEvent(NetEvent.ON_PACKET,funcStr,byte));
						}
						else
						{
							//收到一个错误包，报错
						}
						
						this_packet_total_len = 0;
						this_packet_option_byte1 = 0;
						this_packet_option_byte2 = 0;
						this_packet_crc32 = 0;
						read_offset=0;
						read_buffer_head=MsgUtil.creatByteArray();
						read_buffer_body=MsgUtil.creatByteArray();
					}
				}
				
			}catch(e:Error){
				trace("Connection:Net_Data()取数据异常:["+e.errorID+":"+e.name+":"+e.message+":"+e.getStackTrace()+"]");
			}
		}
		
		//发送方法伪代码
		//ByteArray:message：待发送的内容
		public function send_to_net(message:Message):void
		{
			/*var encrypt_info:ByteArray=MsgUtil.creatByteArray();//加密信息
			encrypt_info.writeInt(0);
			encrypt_info.writeInt(0);*/
			
			var body:ByteArray=MsgUtil.creatByteArray();
			message.writeTo(body);
			
			var head:ByteArray=MsgUtil.creatByteArray();//消息头
			head.writeShort(body.length + 16);
			head.writeShort(0x0000);
			/*var crc:CRC32=new CRC32;
			crc.update(body);
			head.writeUnsignedInt(crc.getValue());
			head.writeBytes(encrypt_info, 0, 8);*/
			socket.writeBytes(head, 0, 4);
			socket.writeBytes(body, 0, body.length);
			socket.flush();
		}
    }
}
