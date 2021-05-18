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


###############################
#   A(host 13) to D(host 2)   #
###############################


#tunnel 1 / TOS =1 :
#h13-->s12-->s5-->s7-->h2

#s12-->s5:
flow1={
	"switch":"00:00:00:00:00:00:00:0c",
	"name":"flow1",
	"ip_tos":"1",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.13",
	"ipv4_dst":"10.0.0.02",
	"priority":"32768",
	"in_port":"2",
	"active":"true",
	"actions":"push_mpls=0x8847,set_field=mpls_label->1,output=1"
}

#s5-->s7:
flow2={
	"switch":"00:00:00:00:00:00:00:05",
	"name":"flow2",
	"mpls_label":"1",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"2",
	"active":"true",
	"actions":"set_field=mpls_label->2,output=6"
}

#s7-->h2:
flow3={
	"switch":"00:00:00:00:00:00:00:07",
	"name":"flow3",
	"mpls_label":"2",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"4",
	"active":"true",
	"actions":"pop_mpls=0x0800,output=3"
}

###################################################

#tunnel 2 / TOS =2 :
#h13-->s12-->s4-->s3-->s2-->s7-->h2

#s12-->s4:
flow4={
	"switch":"00:00:00:00:00:00:00:0c",
	"name":"flow4",
	"ip_tos":"2",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.13",
	"ipv4_dst":"10.0.0.02",
	"priority":"32768",
	"in_port":"2",
	"active":"true",
	"actions":"push_mpls=0x8847,set_field=mpls_label->3,output=4"
}

#s4-->s3:
flow5={
	"switch":"00:00:00:00:00:00:00:04",
	"name":"flow5",
	"mpls_label":"3",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"6",
	"active":"true",
	"actions":"set_field=mpls_label->4,output=4"
}

#s3-->s2:
flow6={
	"switch":"00:00:00:00:00:00:00:03",
	"name":"flow6",
	"mpls_label":"4",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"4",
	"active":"true",
	"actions":"set_field=mpls_label->5,output=5"
}

#s2-->s7:
flow7={
	"switch":"00:00:00:00:00:00:00:02",
	"name":"flow7",
	"mpls_label":"5",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"5",
	"active":"true",
	"actions":"set_field=mpls_label->6,output=3"
}

#s7-->h2:
flow8={
	"switch":"00:00:00:00:00:00:00:07",
	"name":"flow8",
	"mpls_label":"6",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"pop_mpls=0x0800,output=3"
}


###############################
#   B(host 8) to E(host 9)    #
###############################


#tunnel 1 / TOS =1 :
#h8-->s9-->s4-->s12-->s5-->s7-->s2-->s6-->h4

#s9-->s4:
flow9={
	"switch":"00:00:00:00:00:00:00:09",
	"name":"flow9",
	"ip_tos":"1",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.08",
	"ipv4_dst":"10.0.0.04",
	"priority":"32768",
	"in_port":"3",
	"active":"true",
	"actions":"push_mpls=0x8847,set_field=mpls_label->7,output=1"
}

#s4-->s12:
flow10={
	"switch":"00:00:00:00:00:00:00:04",
	"name":"flow10",
	"mpls_label":"7",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"3",
	"active":"true",
	"actions":"set_field=mpls_label->8,output=6"
}

#s12-->s5:
flow11={
	"switch":"00:00:00:00:00:00:00:0c",
	"name":"flow11",
	"mpls_label":"8",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"4",
	"active":"true",
	"actions":"set_field=mpls_label->9,output=1"
}

#s5-->s7:
flow12={
	"switch":"00:00:00:00:00:00:00:05",
	"name":"flow12",
	"mpls_label":"9",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"2",
	"active":"true",
	"actions":"set_field=mpls_label->10,output=6"
}

#s7-->s2:
flow13={
	"switch":"00:00:00:00:00:00:00:07",
	"name":"flow13",
	"mpls_label":"10",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"4",
	"active":"true",
	"actions":"set_field=mpls_label->11,output=1"
}

#s2-->s6:
flow14={
	"switch":"00:00:00:00:00:00:00:02",
	"name":"flow14",
	"mpls_label":"11",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"3",
	"active":"true",
	"actions":"set_field=mpls_label->12,output=2"
}

#s6-->h4:
flow15={
	"switch":"00:00:00:00:00:00:00:06",
	"name":"flow15",
	"mpls_label":"12",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"pop_mpls=0x0800,output=3"
}

###################################################

#tunnel 2 / TOS =2 :
#h8-->s9-->s4-->s8-->s3-->s10-->s2-->s6-->h4

#s9-->s4:
flow16={
	"switch":"00:00:00:00:00:00:00:09",
	"name":"flow16",
	"ip_tos":"2",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.08",
	"ipv4_dst":"10.0.0.04",
	"priority":"32768",
	"in_port":"3",
	"active":"true",
	"actions":"push_mpls=0x8847,set_field=mpls_label->13,output=1"
}

#s4-->s8:
flow17={
	"switch":"00:00:00:00:00:00:00:04",
	"name":"flow17",
	"mpls_label":"13",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"3",
	"active":"true",
	"actions":"set_field=mpls_label->14,output=2"
}

#s8-->s3:
flow18={
	"switch":"00:00:00:00:00:00:00:08",
	"name":"flow18",
	"mpls_label":"14",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"set_field=mpls_label->15,output=4"
}

#s3-->s10:
flow19={
	"switch":"00:00:00:00:00:00:00:03",
	"name":"flow19",
	"mpls_label":"15",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"6",
	"active":"true",
	"actions":"set_field=mpls_label->16,output=2"
}

#s10-->s2:
flow20={
	"switch":"00:00:00:00:00:00:00:0a",
	"name":"flow20",
	"mpls_label":"16",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"set_field=mpls_label->17,output=4"
}

#s2-->s6:
flow21={
	"switch":"00:00:00:00:00:00:00:02",
	"name":"flow21",
	"mpls_label":"17",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"6",
	"active":"true",
	"actions":"set_field=mpls_label->18,output=2"
}

#s6-->h4:
flow22={
	"switch":"00:00:00:00:00:00:00:06",
	"name":"flow22",
	"mpls_label":"18",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"pop_mpls=0x0800,output=3"
}

###############################
#   C(host 5) to F(host 16)   #
###############################


#tunnel 1 / TOS =1 :
#h5-->s8-->s4-->s5-->s13-->h16

#s8-->s4:
flow23={
	"switch":"00:00:00:00:00:00:00:08",
	"name":"flow23",
	"ip_tos":"1",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.05",
	"ipv4_dst":"10.0.0.16",
	"priority":"32768",
	"in_port":"2",
	"active":"true",
	"actions":"push_mpls=0x8847,set_field=mpls_label->19,output=1"
}

#s4-->s5:
flow24={
	"switch":"00:00:00:00:00:00:00:04",
	"name":"flow24",
	"mpls_label":"19",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"2",
	"active":"true",
	"actions":"set_field=mpls_label->20,output=5"
}

#s5-->s13:
flow25={
	"switch":"00:00:00:00:00:00:00:05",
	"name":"flow25",
	"mpls_label":"20",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"4",
	"active":"true",
	"actions":"set_field=mpls_label->21,output=3"
}

#s13-->h16:
flow26={
	"switch":"00:00:00:00:00:00:00:0d",
	"name":"flow26",
	"mpls_label":"21",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"pop_mpls=0x0800,output=3"
}

###################################################

#tunnel 2 / TOS =2 :
#h5-->s8-->s3-->s10-->s2-->s7-->s5-->s13-->h16

#s8-->s3:
flow27={
	"switch":"00:00:00:00:00:00:00:08",
	"name":"flow27",
	"ip_tos":"2",
	"eth_type":"0x0800",
	"ipv4_src":"10.0.0.05",
	"ipv4_dst":"10.0.0.16",
	"priority":"32768",
	"in_port":"2",
	"active":"true",
	"actions":"push_mpls=0x8847,set_field=mpls_label->22,output=4"
}

#s3-->s10:
flow28={
	"switch":"00:00:00:00:00:00:00:03",
	"name":"flow28",
	"mpls_label":"22",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"6",
	"active":"true",
	"actions":"set_field=mpls_label->23,output=2"
}

#s10-->s2:
flow29={
	"switch":"00:00:00:00:00:00:00:0a",
	"name":"flow29",
	"mpls_label":"23",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"set_field=mpls_label->24,output=4"
}

#s2-->s7:
flow30={
	"switch":"00:00:00:00:00:00:00:02",
	"name":"flow30",
	"mpls_label":"24",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"6",
	"active":"true",
	"actions":"set_field=mpls_label->25,output=3"
}

#s7-->s5:
flow31={
	"switch":"00:00:00:00:00:00:00:07",
	"name":"flow31",
	"mpls_label":"25",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"set_field=mpls_label->26,output=4"
}

#s5-->s13:
flow32={
	"switch":"00:00:00:00:00:00:00:05",
	"name":"flow32",
	"mpls_label":"26",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"6",
	"active":"true",
	"actions":"set_field=mpls_label->27,output=3"
}

#s13-->h16:
flow33={
	"switch":"00:00:00:00:00:00:00:0d",
	"name":"flow33",
	"mpls_label":"27",
	"eth_type":"0x8847",
	"priority":"32768",
	"in_port":"1",
	"active":"true",
	"actions":"pop_mpls=0x0800,output=3"
}




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
pusher.Set(flow27)
pusher.Set(flow28)
pusher.Set(flow29)
pusher.Set(flow30)
pusher.Set(flow31)
pusher.Set(flow32)
pusher.Set(flow33)
