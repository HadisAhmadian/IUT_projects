import httplib
import json
class StaticEntryPusher(object):
 
 def init(self,server):
  self.server = server

 def get(self,data):
  ret=self.rest_call({}, 'GET')
  return json.loads(ret[2])
 
 def Set(self,data):
  ret=self.rest_call(data,'PUT')
  return ret[0]==200
 
 def remove(self,objtype,data):
  ret=self.rest_call(data,'DELETE')
  return ret[0]==200
 
 def rest_call(self,data,action):
  path='restconf/config/opendaylight-inventory:nodes'
  header={
   'Cantent-type':'application/json',
   'Accept':'application/json'
  }
  body=json.dumps(data)
  Conn=httplib.HTTPConnection(self.server,8181) #8181
  Conn.request(action,path,body,header)
  response=Conn.getresponse()
  ret=(response.status,response.reason,response.read())
  print ret
  Conn.close()
  return ret

pusher=StaticEntryPusher('127.0.0.1')

############################################################
#H1->S1->S5->S4->H5

#H1->S1

#S1->S5

flow1={
     "flow-node-inventory:flow": [
         {
             "id": "124",
             "table_id": 1,
             "barrier": false,
             "flow-name": "flow1",
             "strict": false,
             "idle-timeout": 34,
             "priority": 1,
             "hard-timeout": 12,
             "cookie_mask": 255,
             "match": {
                 "ipv4-source": "10.0.0.1/24",
     		 "ipv4-destination": "10.0.0.5/24",
       		 "in-port":1,
                 "ethernet-match": {
                     "ethernet-type": {
                         "type": 2048
                     }
                 }
             },
             "cookie": 1,
             "instructions": {
                 "instruction": [
                     {
                         "order": 0,
                         "apply-actions": {
                             "action": [
                                 {
                                     "output-node-connector": 2
                                 }
                             ]
                         }
                     }
                 ]
             }
         }
     ]
 }

#S5->S4

flow2={
     "flow-node-inventory:flow": [
         {
             "id": "124",
             "table_id": 5,
             "barrier": false,
             "flow-name": "flow2",
             "strict": false,
             "idle-timeout": 34,
             "priority": 1,
             "hard-timeout": 12,
             "cookie_mask": 255,
             "match": {
                 "ipv4-source": "10.0.0.1/24",
     		 "ipv4-destination": "10.0.0.5/24",
       		 "in-port":1,
                 "ethernet-match": {
                     "ethernet-type": {
                         "type": 2048
                     }
                 }
             },
             "cookie": 1,
             "instructions": {
                 "instruction": [
                     {
                         "order": 0,
                         "apply-actions": {
                             "action": [
                                 {
                                     "output-node-connector": 4
                                 }
                             ]
                         }
                     }
                 ]
             }
         }
     ]
 }

#S4->H5

flow3={
     "flow-node-inventory:flow": [
         {
             "id": "124",
             "table_id": 4,
             "barrier": false,
             "flow-name": "flow3",
             "strict": false,
             "idle-timeout": 34,
             "priority": 1,
             "hard-timeout": 12,
             "cookie_mask": 255,
             "match": {
                 "ipv4-source": "10.0.0.1/24",
     		 "ipv4-destination": "10.0.0.5/24",
       		 "in-port":3,
                 "ethernet-match": {
                     "ethernet-type": {
                         "type": 2048
                     }
                 }
             },
             "cookie": 1,
             "instructions": {
                 "instruction": [
                     {
                         "order": 0,
                         "apply-actions": {
                             "action": [
                                 {
                                     "output-node-connector": 2
                                 }
                             ]
                         }
                     }
                 ]
             }
         }
     ]
 }

########################################################################
#H1->S1->S5->S4->H4
#H1->S1

#S1->S5

flow4={
     "flow-node-inventory:flow": [
         {
             "id": "124",
             "table_id": 1,
             "barrier": false,
             "flow-name": "flow4",
             "strict": false,
             "idle-timeout": 34,
             "priority": 1,
             "hard-timeout": 12,
             "cookie_mask": 255,
             "match": {
                 "ipv4-source": "10.0.0.1/24",
     		 "ipv4-destination": "10.0.0.4/24",
       		 "in-port":1,
                 "ethernet-match": {
                     "ethernet-type": {
                         "type": 2048
                     }
                 }
             },
             "cookie": 1,
             "instructions": {
                 "instruction": [
                     {
                         "order": 0,
                         "apply-actions": {
                             "action": [
                                 {
                                     "output-node-connector": 2
                                 }
                             ]
                         }
                     }
                 ]
             }
         }
     ]
 }

#S5->S4

flow5={
     "flow-node-inventory:flow": [
         {
             "id": "124",
             "table_id": 5,
             "barrier": false,
             "flow-name": "flow5",
             "strict": false,
             "idle-timeout": 34,
             "priority": 1,
             "hard-timeout": 12,
             "cookie_mask": 255,
             "match": {
                 "ipv4-source": "10.0.0.1/24",
     		 "ipv4-destination": "10.0.0.4/24",
       		 "in-port":1,
                 "ethernet-match": {
                     "ethernet-type": {
                         "type": 2048
                     }
                 }
             },
             "cookie": 1,
             "instructions": {
                 "instruction": [
                     {
                         "order": 0,
                         "apply-actions": {
                             "action": [
                                 {
                                     "output-node-connector": 4
                                 }
                             ]
                         }
                     }
                 ]
             }
         }
     ]
 }

#S4->H4

flow6={
     "flow-node-inventory:flow": [
         {
             "id": "124",
             "table_id": 4,
             "barrier": false,
             "flow-name": "flow6",
             "strict": false,
             "idle-timeout": 34,
             "priority": 1,
             "hard-timeout": 12,
             "cookie_mask": 255,
             "match": {
                 "ipv4-source": "10.0.0.1/24",
     		 "ipv4-destination": "10.0.0.4/24",
       		 "in-port":3,
                 "ethernet-match": {
                     "ethernet-type": {
                         "type": 2048
                     }
                 }
             },
             "cookie": 1,
             "instructions": {
                 "instruction": [
                     {
                         "order": 0,
                         "apply-actions": {
                             "action": [
                                 {
                                     "output-node-connector": 1
                                 }
                             ]
                         }
                     }
                 ]
             }
         }
     ]
 }


########################################################################
#H2->S2->S5->S4->H4
#H2->S2

#S2->S5

flow7={
     "flow-node-inventory:flow": [
         {
             "id": "124",
             "table_id": 2,
             "barrier": false,
             "flow-name": "flow7",
             "strict": false,
             "idle-timeout": 34,
             "priority": 1,
             "hard-timeout": 12,
             "cookie_mask": 255,
             "match": {
                 "ipv4-source": "10.0.0.2/24",
     		 "ipv4-destination": "10.0.0.4/24",
       		 "in-port":1,
                 "ethernet-match": {
                     "ethernet-type": {
                         "type": 2048
                     }
                 }
             },
             "cookie": 1,
             "instructions": {
                 "instruction": [
                     {
                         "order": 0,
                         "apply-actions": {
                             "action": [
                                 {
                                     "output-node-connector": 2
                                 }
                             ]
                         }
                     }
                 ]
             }
         }
     ]
 }

#S5->S4

flow8={
     "flow-node-inventory:flow": [
         {
             "id": "124",
             "table_id": 5,
             "barrier": false,
             "flow-name": "flow8",
             "strict": false,
             "idle-timeout": 34,
             "priority": 1,
             "hard-timeout": 12,
             "cookie_mask": 255,
             "match": {
                 "ipv4-source": "10.0.0.2/24",
     		 "ipv4-destination": "10.0.0.4/24",
       		 "in-port":3,
                 "ethernet-match": {
                     "ethernet-type": {
                         "type": 2048
                     }
                 }
             },
             "cookie": 1,
             "instructions": {
                 "instruction": [
                     {
                         "order": 0,
                         "apply-actions": {
                             "action": [
                                 {
                                     "output-node-connector": 4
                                 }
                             ]
                         }
                     }
                 ]
             }
         }
     ]
 }

#S4->H4

flow9={
     "flow-node-inventory:flow": [
         {
             "id": "124",
             "table_id": 4,
             "barrier": false,
             "flow-name": "flow9",
             "strict": false,
             "idle-timeout": 34,
             "priority": 1,
             "hard-timeout": 12,
             "cookie_mask": 255,
             "match": {
                 "ipv4-source": "10.0.0.2/24",
     		 "ipv4-destination": "10.0.0.4/24",
       		 "in-port":3,
                 "ethernet-match": {
                     "ethernet-type": {
                         "type": 2048
                     }
                 }
             },
             "cookie": 1,
             "instructions": {
                 "instruction": [
                     {
                         "order": 0,
                         "apply-actions": {
                             "action": [
                                 {
                                     "output-node-connector": 1
                                 }
                             ]
                         }
                     }
                 ]
             }
         }
     ]
 }



########################################################################
#H3->S3->S5->S4->H5
#H3->S3

#S3->S5

flow10={
     "flow-node-inventory:flow": [
         {
             "id": "124",
             "table_id": 3,
             "barrier": false,
             "flow-name": "flow10",
             "strict": false,
             "idle-timeout": 34,
             "priority": 1,
             "hard-timeout": 12,
             "cookie_mask": 255,
             "match": {
                 "ipv4-source": "10.0.0.3/24",
     		 "ipv4-destination": "10.0.0.5/24",
       		 "in-port":1,
                 "ethernet-match": {
                     "ethernet-type": {
                         "type": 2048
                     }
                 }
             },
             "cookie": 1,
             "instructions": {
                 "instruction": [
                     {
                         "order": 0,
                         "apply-actions": {
                             "action": [
                                 {
                                     "output-node-connector": 2
                                 }
                             ]
                         }
                     }
                 ]
             }
         }
     ]
 }

#S5->S4

flow11={
     "flow-node-inventory:flow": [
         {
             "id": "124",
             "table_id": 5,
             "barrier": false,
             "flow-name": "flow11",
             "strict": false,
             "idle-timeout": 34,
             "priority": 1,
             "hard-timeout": 12,
             "cookie_mask": 255,
             "match": {
                 "ipv4-source": "10.0.0.3/24",
     		 "ipv4-destination": "10.0.0.5/24",
       		 "in-port":3,
                 "ethernet-match": {
                     "ethernet-type": {
                         "type": 2048
                     }
                 }
             },
             "cookie": 1,
             "instructions": {
                 "instruction": [
                     {
                         "order": 0,
                         "apply-actions": {
                             "action": [
                                 {
                                     "output-node-connector": 4
                                 }
                             ]
                         }
                     }
                 ]
             }
         }
     ]
 }

#S4->H5

flow12={
     "flow-node-inventory:flow": [
         {
             "id": "124",
             "table_id": 4,
             "barrier": false,
             "flow-name": "flow12",
             "strict": false,
             "idle-timeout": 34,
             "priority": 1,
             "hard-timeout": 12,
             "cookie_mask": 255,
             "match": {
                 "ipv4-source": "10.0.0.3/24",
     		 "ipv4-destination": "10.0.0.5/24",
       		 "in-port":3,
                 "ethernet-match": {
                     "ethernet-type": {
                         "type": 2048
                     }
                 }
             },
             "cookie": 1,
             "instructions": {
                 "instruction": [
                     {
                         "order": 0,
                         "apply-actions": {
                             "action": [
                                 {
                                     "output-node-connector": 2
                                 }
                             ]
                         }
                     }
                 ]
             }
         }
     ]
 }


########################################################################
#H2->S2->S5->S3->H3
#H2->S2

#S2->S5

flow13={
     "flow-node-inventory:flow": [
         {
             "id": "124",
             "table_id": 2,
             "barrier": false,
             "flow-name": "flow13",
             "strict": false,
             "idle-timeout": 34,
             "priority": 1,
             "hard-timeout": 12,
             "cookie_mask": 255,
             "match": {
                 "ipv4-source": "10.0.0.2/24",
     		 "ipv4-destination": "10.0.0.3/24",
       		 "in-port":1,
                 "ethernet-match": {
                     "ethernet-type": {
                         "type": 2048
                     }
                 }
             },
             "cookie": 1,
             "instructions": {
                 "instruction": [
                     {
                         "order": 0,
                         "apply-actions": {
                             "action": [
                                 {
                                     "output-node-connector": 2
                                 }
                             ]
                         }
                     }
                 ]
             }
         }
     ]
 }

#S5->S3

flow14={
     "flow-node-inventory:flow": [
         {
             "id": "124",
             "table_id": 5,
             "barrier": false,
             "flow-name": "flow14",
             "strict": false,
             "idle-timeout": 34,
             "priority": 1,
             "hard-timeout": 12,
             "cookie_mask": 255,
             "match": {
                 "ipv4-source": "10.0.0.2/24",
     		 "ipv4-destination": "10.0.0.3/24",
       		 "in-port":2,
                 "ethernet-match": {
                     "ethernet-type": {
                         "type": 2048
                     }
                 }
             },
             "cookie": 1,
             "instructions": {
                 "instruction": [
                     {
                         "order": 0,
                         "apply-actions": {
                             "action": [
                                 {
                                     "output-node-connector": 3
                                 }
                             ]
                         }
                     }
                 ]
             }
         }
     ]
 }

#S3->H3

flow15={
     "flow-node-inventory:flow": [
         {
             "id": "124",
             "table_id": 3,
             "barrier": false,
             "flow-name": "flow15",
             "strict": false,
             "idle-timeout": 34,
             "priority": 1,
             "hard-timeout": 12,
             "cookie_mask": 255,
             "match": {
                 "ipv4-source": "10.0.0.2/24",
     		 "ipv4-destination": "10.0.0.3/24",
       		 "in-port":2,
                 "ethernet-match": {
                     "ethernet-type": {
                         "type": 2048
                     }
                 }
             },
             "cookie": 1,
             "instructions": {
                 "instruction": [
                     {
                         "order": 0,
                         "apply-actions": {
                             "action": [
                                 {
                                     "output-node-connector": 1
                                 }
                             ]
                         }
                     }
                 ]
             }
         }
     ]
 }




pusher.Set(flow1)