data_dir = "/tmp/consul/server"

server           = true
bootstrap_expect = 3
advertise_addr   = "{{ GetInterfaceIP `enp0s8` }}"
client_addr      = "0.0.0.0"
bind_addr        = "{{GetInterfaceIP `enp0s8`}}"
ui               = true
datacenter       = "toronto"
retry_join       = ["172.16.1.101", "172.16.1.102", "172.16.1.103","172.16.1.104"]
