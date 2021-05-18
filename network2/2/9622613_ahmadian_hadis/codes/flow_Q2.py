import httplib
import json
class StaticEntryPusher(object):
	
	def __init__(self,server):
		self.server = server

	def get(self,data):
		ret=self.rest_call({}, 'GET')
		return json.loads(ret[2])
	
	def Set(self,data):
		ret=self.rest_call(data,'POST')
		return ret[0]==200
	
	def remove(self,objtype,data):
		ret=self.rest_call(data,'DELETE')
		return ret[0]==200
	
	def rest_call(self,data,action):
		path='/wm/staticentrypusher/json'
		header={
			'Cantent-type':'application/json',
			'Accept':'application/json'
		}
		body=json.dumps(data)
		Conn=httplib.HTTPConnection(self.server,8080)
		Conn.request(action,path,body,header)
		response=Conn.getresponse()
		ret=(response.status,response.reason,response.read())
		print ret
		Conn.close()
		return ret

pusher=StaticEntryPusher('127.0.0.1')

#h9-->s3

#s3-->s1
flow1={
	"switch":"00:00:00:00:00:00:00:03",
	"name":"flow1",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.09",
	"ipv4_dst":"10.0.0.08",
	"priority":"32768",
	"in_port":"4",
	"active":"true",
	"actions":"output=1"}

#s1-->s4
flow2={
	"switch":"00:00:00:00:00:00:00:01",
	"name":"flow2",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.09",
	"ipv4_dst":"10.0.0.08",
	"priority":"32768",
	"in_port":"2",
	"active":"true",
	"actions":"output=3"}


#s4-->s6
flow3={
	"switch":"00:00:00:00:00:00:00:04",
	"name":"flow3",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.09",
	"ipv4_dst":"10.0.0.08",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=6"}


#s6-->s7
flow4={
	"switch":"00:00:00:00:00:00:00:06",
	"name":"flow4",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.09",
	"ipv4_dst":"10.0.0.08",
	"priority":"32768",
	"in_port":"4",
	"active":"true",
	"actions":"output=2"}


#s7-->s8
flow5={
	"switch":"00:00:00:00:00:00:00:07",
	"name":"flow5",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.09",
	"ipv4_dst":"10.0.0.08",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=3"}


#s8-->h8
flow6={
	"switch":"00:00:00:00:00:00:00:08",
	"name":"flow6",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.09",
	"ipv4_dst":"10.0.0.08",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=4"}

pusher.Set(flow1)
pusher.Set(flow2)
pusher.Set(flow3)
pusher.Set(flow4)
pusher.Set(flow5)
pusher.Set(flow6)
