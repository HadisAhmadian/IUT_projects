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


#path 1 : h1 s7 s2 s1 s3 s10 h9

#h1-->s7

#s7-->s2
flow1={
	"switch":"00:00:00:00:00:00:00:07",
	"name":"flow1",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.01",
	"ipv4_dst":"10.0.0.09",
	"priority":"32768",
	"in_port":"2",
	"active":"true",
	"actions":"output=1"}

#s2-->s1
flow2={
	"switch":"00:00:00:00:00:00:00:02",
	"name":"flow2",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.01",
	"ipv4_dst":"10.0.0.09",
	"priority":"32768",
	"in_port":"3",
	"active":"true",
	"actions":"output=1"}


#s1-->s3
flow3={
	"switch":"00:00:00:00:00:00:00:01",
	"name":"flow3",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.01",
	"ipv4_dst":"10.0.0.09",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=2"}


#s3-->s10
flow4={
	"switch":"00:00:00:00:00:00:00:03",
	"name":"flow4",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.01",
	"ipv4_dst":"10.0.0.09",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=2"}


#s10-->h9
flow5={
	"switch":"00:00:00:00:00:00:00:0a",
	"name":"flow5",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.01",
	"ipv4_dst":"10.0.0.09",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=2"}


#path 2 : h5 s8 s4 s1 s5 s13 h16

#h5-->s8

#s8-->s4
flow6={
	"switch":"00:00:00:00:00:00:00:08",
	"name":"flow6",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.05",
	"ipv4_dst":"10.0.0.16",
	"priority":"32768",
	"in_port":"2",
	"active":"true",
	"actions":"output=1"}

#s4-->s1
flow7={
	"switch":"00:00:00:00:00:00:00:04",
	"name":"flow7",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.05",
	"ipv4_dst":"10.0.0.16",
	"priority":"32768",
	"in_port":"2",
	"active":"true",
	"actions":"output=1"}


#s1-->s5
flow8={
	"switch":"00:00:00:00:00:00:00:01",
	"name":"flow8",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.05",
	"ipv4_dst":"10.0.0.16",
	"priority":"32768",
	"in_port":"3",
	"active":"true",
	"actions":"output=4"}


#s5-->s13
flow9={
	"switch":"00:00:00:00:00:00:00:05",
	"name":"flow9",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.05",
	"ipv4_dst":"10.0.0.16",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=3"}


#s13-->h16
flow10={
	"switch":"00:00:00:00:00:00:00:0d",
	"name":"flow10",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.05",
	"ipv4_dst":"10.0.0.16",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=2"}


#path 3 : h11 s11 s3 s1 s5 s12 h13

#h11-->s11

#s11-->s3
flow11={
	"switch":"00:00:00:00:00:00:00:0b",
	"name":"flow11",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.11",
	"ipv4_dst":"10.0.0.13",
	"priority":"32768",
	"in_port":"2",
	"active":"true",
	"actions":"output=1"}

#s3-->s1
flow12={
	"switch":"00:00:00:00:00:00:00:03",
	"name":"flow12",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.11",
	"ipv4_dst":"10.0.0.13",
	"priority":"32768",
	"in_port":"3",
	"active":"true",
	"actions":"output=1"}


#s1-->s5
flow13={
	"switch":"00:00:00:00:00:00:00:01",
	"name":"flow13",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.11",
	"ipv4_dst":"10.0.0.13",
	"priority":"32768",
	"in_port":"2",
	"active":"true",
	"actions":"output=4"}


#s5-->s12
flow14={
	"switch":"00:00:00:00:00:00:00:05",
	"name":"flow14",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.11",
	"ipv4_dst":"10.0.0.13",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=2"}


#s12-->h13
flow15={
	"switch":"00:00:00:00:00:00:00:0c",
	"name":"flow15",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.11",
	"ipv4_dst":"10.0.0.13",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=2"}



#path 4 : h4 s6 s2 s1 s4 s9 h8

#h4-->s6

#s6-->s2
flow16={
	"switch":"00:00:00:00:00:00:00:06",
	"name":"flow16",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.04",
	"ipv4_dst":"10.0.0.08",
	"priority":"32768",
	"in_port":"2",
	"active":"true",
	"actions":"output=1"}

#s2-->s1
flow17={
	"switch":"00:00:00:00:00:00:00:02",
	"name":"flow17",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.04",
	"ipv4_dst":"10.0.0.08",
	"priority":"32768",
	"in_port":"2",
	"active":"true",
	"actions":"output=1"}


#s1-->s4
flow18={
	"switch":"00:00:00:00:00:00:00:01",
	"name":"flow18",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.04",
	"ipv4_dst":"10.0.0.08",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=3"}


#s4-->s9
flow19={
	"switch":"00:00:00:00:00:00:00:03",
	"name":"flow19",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.04",
	"ipv4_dst":"10.0.0.08",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=3"}


#s9-->h8
flow20={
	"switch":"00:00:00:00:00:00:00:09",
	"name":"flow20",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.04",
	"ipv4_dst":"10.0.0.08",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=2"}

#path 5 : h2 s7 s2 s1 s5 s13 h15

#h2-->s7

#s7-->s2
flow21={
	"switch":"00:00:00:00:00:00:00:07",
	"name":"flow21",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.02",
	"ipv4_dst":"10.0.0.15",
	"priority":"32768",
	"in_port":"3",
	"active":"true",
	"actions":"output=1"}

#s2-->s1 #written in path 1


#s1-->s5
flow22={
	"switch":"00:00:00:00:00:00:00:01",
	"name":"flow22",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.02",
	"ipv4_dst":"10.0.0.15",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=4"}


#s5-->s13 #written in path2


#s13-->h15
flow23={
	"switch":"00:00:00:00:00:00:00:0d",
	"name":"flow23",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.02",
	"ipv4_dst":"10.0.0.15",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=3"}


#path 6 : h6 s8 s4 s1 s3 s10 h10

#h6-->s8

#s8-->s4
flow24={
	"switch":"00:00:00:00:00:00:00:08",
	"name":"flow24",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.06",
	"ipv4_dst":"10.0.0.10",
	"priority":"32768",
	"in_port":"3",
	"active":"true",
	"actions":"output=1"}

#s4-->s1 #written in path 2


#s1-->s3
flow25={
	"switch":"00:00:00:00:00:00:00:01",
	"name":"flow25",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.06",
	"ipv4_dst":"10.0.0.10",
	"priority":"32768",
	"in_port":"3",
	"active":"true",
	"actions":"output=2"}


#s3-->s10 #written in path1


#s10-->h10
flow26={
	"switch":"00:00:00:00:00:00:00:0a",
	"name":"flow26",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.06",
	"ipv4_dst":"10.0.0.10",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"output=3"}




pusher.Set(flow1)
pusher.Set(flow2)
pusher.Set(flow3)
pusher.Set(flow4)
pusher.Set(flow5)
pusher.Set(flow6)
pusher.Set(flow7)
pusher.Set(flow8)
pusher.Set(flow9)
pusher.Set(flow10)
pusher.Set(flow11)
pusher.Set(flow12)
pusher.Set(flow13)
pusher.Set(flow14)
pusher.Set(flow15)
pusher.Set(flow16)
pusher.Set(flow17)
pusher.Set(flow18)
pusher.Set(flow19)
pusher.Set(flow20)
pusher.Set(flow21)
pusher.Set(flow22)
pusher.Set(flow23)
pusher.Set(flow24)
pusher.Set(flow25)
pusher.Set(flow26)
